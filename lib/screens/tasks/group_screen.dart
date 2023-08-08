import 'package:flutter/material.dart';
import 'package:task_master/widget/task_builder.dart';

class GroupScreen extends StatelessWidget {
  final String groupName;

  const GroupScreen(this.groupName, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(groupName),
            pinned: true,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Image.asset(
                  'assets/images/${groupName.toLowerCase()}.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            expandedHeight: 200,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: TaskBuilder(
                filter: groupName.toLowerCase(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
