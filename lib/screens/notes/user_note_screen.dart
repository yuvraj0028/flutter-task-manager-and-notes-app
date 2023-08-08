import 'package:flutter/material.dart';

import '/widget/my_drawer.dart';
import '/widget/notes_builder.dart';

class UserNoteScreen extends StatelessWidget {
  static const routeName = '/user-notes';
  const UserNoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      drawer: const MyDrawer(),
      body: const NotesBuilder(),
    );
  }
}
