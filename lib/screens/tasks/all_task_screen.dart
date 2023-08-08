import 'package:flutter/material.dart';

import '/widget/task_builder.dart';
import '/widget/my_drawer.dart';

class AllTask extends StatelessWidget {
  const AllTask({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Tasks'),
      ),
      drawer: const MyDrawer(),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 20),
          child: TaskBuilder(
            filter: 'NoGroup',
          ),
        ),
      ),
    );
  }
}
