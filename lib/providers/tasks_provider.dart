import 'package:flutter/material.dart';

import '../models/user_task.dart';
import '../helper/db_helper.dart';

class TasksProvider extends ChangeNotifier {
  List<UserTask> _userTaskList = [];

  final Map<String, String> _taskGroup = {
    'self': 'assets/images/self.png',
    'office': 'assets/images/office.png',
    'home': 'assets/images/home.png',
  };

  double totalPerc = 0.00;

  List<UserTask> get userTaskList {
    return [..._userTaskList];
  }

  List<UserTask> groupList(String filter) {
    return _userTaskList
        .where((element) => element.imagePath.contains(filter))
        .toList();
  }

  Map<String, String> get taskGroup {
    return _taskGroup;
  }

  void addTask(
    String title,
    String? desc,
    DateTime? startingDate,
    String groupKey,
    DateTime date,
  ) {
    final newUserTask = UserTask(
      date.toString(),
      title,
      desc,
      startingDate,
      imagePath: _taskGroup[groupKey]!,
    );
    _userTaskList.insert(
      0,
      newUserTask,
    );
    calculatePercentage();
    DBHelper.insert('USERTASK', {
      'id': newUserTask.id,
      'title': newUserTask.title,
      'desc': newUserTask.description ?? '',
      'stDate': newUserTask.startingDate != null
          ? newUserTask.startingDate.toString()
          : '',
      'image': newUserTask.imagePath,
      'isDone': 0,
    });
  }

  void deleteTask(int index) async {
    String id = _userTaskList[index].id;
    _userTaskList.removeAt(index);
    calculatePercentage();
    DBHelper.delete(id);
  }

  void taskDone(int index, bool check) async {
    _userTaskList[index].isDone = !check;
    calculatePercentage();
    int val = _userTaskList[index].isDone ? 1 : 0;
    String id = _userTaskList[index].id;
    DBHelper.update(id, val);
  }

  void calculatePercentage() {
    int totalLength = _userTaskList.length;

    if (totalLength == 0) {
      totalPerc = 0.00;
      notifyListeners();
      return;
    }

    int cnt = 0;

    for (int i = 0; i < _userTaskList.length; i++) {
      if (!_userTaskList[i].isDone) {
        cnt++;
      }
    }

    int taskDone = totalLength - cnt;

    double perc = (taskDone * 100) / totalLength;

    perc = perc / 100;
    totalPerc = perc;
    notifyListeners();
  }

  Future<void> fetchData() async {
    final dataList = await DBHelper.getData('USERTASK');

    _userTaskList = dataList
        .map(
          (item) => UserTask(
            item['id'],
            item['title'],
            item['desc'] == '' ? null : item['desc'],
            item['stDate'] == '' ? null : DateTime.tryParse(item['stDate']),
            imagePath: item['image'],
            isDone: item['isDone'] == 0 ? false : true,
          ),
        )
        .toList()
        .reversed
        .toList();
    calculatePercentage();
  }

  void logout() async {
    _userTaskList = [];
    calculatePercentage();
    DBHelper.close('USERTASK');
  }
}
