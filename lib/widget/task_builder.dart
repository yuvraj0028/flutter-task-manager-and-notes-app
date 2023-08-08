import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/tasks_provider.dart';
import '../helper/notification_service.dart';
import '../models/user_task.dart';

class TaskBuilder extends StatefulWidget {
  final String? filter;
  const TaskBuilder({required this.filter, super.key});

  @override
  State<TaskBuilder> createState() => _TaskBuilderState();
}

class _TaskBuilderState extends State<TaskBuilder> {
  var isInit = false;

  @override
  void initState() {
    isInit = true;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isInit) _fetchData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<TasksProvider>(context);
    final userList = Provider.of<TasksProvider>(context).userTaskList;
    final groupList =
        Provider.of<TasksProvider>(context).groupList(widget.filter!);
    final mediaQuery = MediaQuery.of(context);
    return (widget.filter == 'NoGroup' ? userList.isEmpty : groupList.isEmpty)
        ? Center(
            child: Column(
              children: [
                Text(
                  'No Tasks!',
                  style: TextStyle(
                    fontSize: mediaQuery.textScaleFactor * 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 15),
                  width: mediaQuery.size.width * 0.7,
                  height: mediaQuery.size.width * 0.5,
                  child: Image.asset(
                    'assets/images/notask.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          )
        : isInit
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                primary: false,
                shrinkWrap: true,
                itemCount: widget.filter == 'NoGroup'
                    ? userList.length
                    : groupList.length,
                itemBuilder: (BuildContext context, int index) {
                  return TaskTile(
                    user: user,
                    userList: widget.filter == 'NoGroup' ? userList : groupList,
                    index: index,
                    filter: widget.filter!,
                  );
                },
              );
  }

  void _fetchData() async {
    Future.delayed(const Duration(seconds: 1), () {
      isInit = false;
    });
    await Provider.of<TasksProvider>(context).fetchData();
  }
}

class TaskTile extends StatefulWidget {
  const TaskTile({
    super.key,
    required this.user,
    required this.userList,
    required this.index,
    required this.filter,
  });

  final TasksProvider user;
  final List<UserTask> userList;
  final int index;
  final String filter;

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  final NotificationService notificationService = NotificationService();

  @override
  void initState() {
    notificationService.initializeNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: widget.filter == 'NoGroup'
          ? DismissDirection.endToStart
          : DismissDirection.none,
      onDismissed: (direction) {
        widget.user.deleteTask(widget.index);
      },
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure!'),
            content: const Text('This will delete the current task!'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text(
                  'No',
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        );
      },
      background: const Card(
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(25),
          ),
        ),
        elevation: 4,
        margin: const EdgeInsets.all(5),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(widget.userList[widget.index].imagePath),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          title: Text(
            maxLines: 1,
            overflow: TextOverflow.fade,
            softWrap: false,
            widget.userList[widget.index].title,
            style: TextStyle(
              decoration: widget.userList[widget.index].isDone
                  ? TextDecoration.lineThrough
                  : null,
            ),
          ),
          subtitle: widget.userList[widget.index].description == null
              ? const Text('')
              : Text(
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  widget.userList[widget.index].description!,
                  style: TextStyle(
                    color: Colors.grey,
                    decoration: widget.userList[widget.index].isDone
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
          trailing: Wrap(
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 3,
                  ),
                  widget.userList[widget.index].startingDate == null
                      ? const Text('')
                      : Text(
                          DateFormat.MMMMd('en_US').format(
                              widget.userList[widget.index].startingDate!),
                        ),
                  const SizedBox(
                    height: 10,
                  ),
                  widget.userList[widget.index].endingDate == null
                      ? const Text('')
                      : Text(
                          DateFormat.MMMMd('en_US').format(
                              widget.userList[widget.index].endingDate!),
                        ),
                ],
              ),
              if (widget.filter == 'NoGroup')
                Consumer<TasksProvider>(
                  builder: (context, user, _) {
                    return Checkbox(
                      value: widget.userList[widget.index].isDone,
                      onChanged: (value) {
                        final String id = widget.userList[widget.index].id
                            .substring(
                                20, widget.userList[widget.index].id.length);
                        user.taskDone(
                          widget.index,
                          widget.userList[widget.index].isDone,
                        );
                        if (widget.userList[widget.index].startingDate
                                .toString()
                                .isNotEmpty &&
                            widget.userList[widget.index].endingDate
                                .toString()
                                .isNotEmpty) {
                          if (value == false) {
                            notificationService.scheduleNotification(
                                widget.userList[widget.index].title,
                                "Task Pending",
                                int.parse(id));
                          } else {
                            notificationService.stopNotification(int.parse(id));
                          }
                        }
                      },
                    );
                  },
                ),
              if (widget.filter == 'NoGroup')
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Are you sure!'),
                        content:
                            const Text('This will delete the current task!'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: const Text(
                              'No',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              final String id = widget.userList[widget.index].id
                                  .substring(20,
                                      widget.userList[widget.index].id.length);
                              Navigator.of(context).pop(true);
                              widget.user.deleteTask(widget.index);
                              if (widget.userList[widget.index].startingDate
                                      .toString()
                                      .isNotEmpty &&
                                  widget.userList[widget.index].endingDate
                                      .toString()
                                      .isNotEmpty) {
                                notificationService
                                    .stopNotification(int.parse(id));
                              }
                            },
                            child: const Text(
                              'Yes',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
