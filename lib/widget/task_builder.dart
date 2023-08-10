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
    final userList = widget.filter! == 'NoGroup'
        ? Provider.of<TasksProvider>(context).userTaskList
        : Provider.of<TasksProvider>(context).groupList(widget.filter!);
    final mediaQuery = MediaQuery.of(context);
    return userList.isEmpty
        ? Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'No Tasks!',
                  style: TextStyle(
                    fontSize: mediaQuery.textScaleFactor * 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
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
                itemCount: userList.length,
                itemBuilder: (BuildContext context, int index) {
                  return TaskTile(
                    user: user,
                    userList: userList,
                    index: index,
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
  });

  final TasksProvider user;
  final List<UserTask> userList;
  final int index;

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
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        final tempIndex = Provider.of<TasksProvider>(context, listen: false)
            .userTaskList
            .indexWhere(
              (element) => element.id == widget.userList[widget.index].id,
            );
        widget.user.deleteTask(tempIndex);
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
            direction: Axis.vertical,
            alignment: WrapAlignment.center,
            children: [
              Text(
                widget.userList[widget.index].startingDate == null
                    ? ''
                    : DateFormat.MMMMd('en_US')
                        .format(widget.userList[widget.index].startingDate!),
              ),
              Consumer<TasksProvider>(
                builder: (context, user, _) {
                  return Checkbox(
                    value: widget.userList[widget.index].isDone,
                    onChanged: (value) {
                      final String id = widget.userList[widget.index].id
                          .substring(
                              20, widget.userList[widget.index].id.length);
                      final indexTemp = user.userTaskList
                          .indexOf(widget.userList[widget.index]);
                      final check = user.userTaskList[indexTemp].isDone;
                      user.taskDone(
                        indexTemp,
                        check,
                      );
                      if (widget.userList[widget.index].startingDate
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
              IconButton(
                onPressed: () {
                  showDialog(
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
                            final String id = widget.userList[widget.index].id
                                .substring(20,
                                    widget.userList[widget.index].id.length);
                            final tempIndex = Provider.of<TasksProvider>(
                                    context,
                                    listen: false)
                                .userTaskList
                                .indexWhere(
                                  (element) =>
                                      element.id ==
                                      widget.userList[widget.index].id,
                                );
                            Navigator.of(context).pop(true);
                            widget.user.deleteTask(tempIndex);
                            if (widget.userList[widget.index].startingDate
                                .toString()
                                .isNotEmpty) {
                              notificationService
                                  .stopNotification(int.parse(id));
                            }
                          },
                          child: const Text(
                            'Yes',
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
