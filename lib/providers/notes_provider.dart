import 'package:flutter/material.dart';

import '../models/user_notes.dart';
import '../helper/db_helper_notes.dart';

class NotesProvider extends ChangeNotifier {
  List<UserNote> _userList = [];

  List<UserNote> get userList {
    return [..._userList];
  }

  void addNote(String title, String info, Color color) {
    UserNote newNote = UserNote(
      id: DateTime.now().toString(),
      title: title,
      info: info,
    );

    newNote.noteColor = color;

    _userList.add(newNote);
    notifyListeners();

    DBHelperNotes.insert('USERNOTE', {
      'id': newNote.id,
      'title': newNote.title,
      'info': newNote.info,
      'color': newNote.noteColor.toString().toUpperCase().substring(10, 16),
    });
  }

  void updateNote(String title, String info, int index, Color color) {
    _userList[index].title = title;
    _userList[index].info = info;
    _userList[index].noteColor = color;
    notifyListeners();
    DBHelperNotes.update(
      _userList[index].id,
      _userList[index].title,
      _userList[index].info,
      _userList[index].noteColor.toString().toUpperCase().substring(10, 16),
    );
  }

  void deleteNote(int index) {
    final id = _userList[index].id;
    _userList.removeAt(index);
    notifyListeners();
    DBHelperNotes.delete(id);
  }

  void logout() {
    _userList = [];
    notifyListeners();
    DBHelperNotes.close('USERNOTE');
  }

  Future<void> fetchData() async {
    final dataList = await DBHelperNotes.getData('USERNOTE');

    _userList = dataList
        .map(
          (item) => UserNote(
            id: item['id'],
            info: item['info'],
            title: item['title'],
            noteColor: Color(int.parse(item['color'], radix: 16) + 0xFF000000),
          ),
        )
        .toList();
    notifyListeners();
  }
}
