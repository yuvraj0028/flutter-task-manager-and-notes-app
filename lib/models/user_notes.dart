import 'package:flutter/material.dart';

class UserNote {
  String id;
  String title;
  String info;
  Color noteColor;

  UserNote({
    required this.id,
    required this.title,
    required this.info,
    this.noteColor = const Color.fromARGB(255, 255, 242, 128),
  });
}
