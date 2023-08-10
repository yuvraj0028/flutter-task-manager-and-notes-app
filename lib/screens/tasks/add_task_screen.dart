import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import '/providers/tasks_provider.dart';
import '/helper/notification_service.dart';

class AddTask extends StatefulWidget {
  static const routeName = '/add-task';

  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  DateTime? startDate;

  final titleText = TextEditingController();

  final descText = TextEditingController();

  String dropDownValue = 'Self';

  bool isStrechedDropDown = false;

  final DateTime _date = DateTime.now();

  var listItems = [
    'Office',
    'Home',
    'Self',
  ];

  NotificationService notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    notificationService.initializeNotifications();
  }

  @override
  void dispose() {
    super.dispose();
    titleText.dispose();
    descText.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imagesMap =
        Provider.of<TasksProvider>(context, listen: false).taskGroup;
    final mediaQuery = MediaQuery.of(context);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Add Task'),
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            customTextField('Title', titleText),
            customHeight(context),
            customTextField('Description', descText),
            customHeight(context),
            Padding(
              padding: const EdgeInsets.all(10),
              child: dateButtonDecoration(
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      foregroundColor:
                          startDate == null ? Colors.black45 : Colors.white,
                      backgroundColor: startDate == null
                          ? Colors.grey[300]
                          : Theme.of(context).colorScheme.primary,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                    ),
                    onPressed: () {
                      _selectStartDate();
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: startDate == null
                          ? Text(
                              'Select Date',
                              style: TextStyle(
                                  fontSize: mediaQuery.textScaleFactor * 17),
                            )
                          : Text(
                              DateFormat.MMMMd('en_US').format(startDate!),
                              style: TextStyle(
                                  fontSize: mediaQuery.textScaleFactor * 17),
                            ),
                    ),
                  ),
                  context),
            ),
            customHeight(context),
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isStrechedDropDown = !isStrechedDropDown;
                    });
                  },
                  child: Container(
                    height: isLandscape
                        ? mediaQuery.size.width * 0.12
                        : mediaQuery.size.height * 0.12,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 211, 210, 210),
                      borderRadius: isStrechedDropDown
                          ? const BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25),
                            )
                          : const BorderRadius.all(
                              Radius.circular(25),
                            ),
                    ),
                    width: double.infinity,
                    margin: const EdgeInsets.only(
                      top: 20,
                      bottom: 0,
                      left: 10,
                      right: 10,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.transparent,
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                        imagesMap[dropDownValue.toLowerCase()]!,
                                      ),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                dropDownValue,
                                style: TextStyle(
                                  fontSize: mediaQuery.textScaleFactor * 23,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isStrechedDropDown = !isStrechedDropDown;
                              });
                            },
                            child: isStrechedDropDown
                                ? const Icon(
                                    Icons.arrow_upward,
                                    color: Colors.black,
                                  )
                                : const Icon(
                                    Icons.arrow_downward,
                                    color: Colors.black,
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  height: isStrechedDropDown
                      ? listItems.length * mediaQuery.size.height * 0.11
                      : 0,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 211, 210, 210),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                  ),
                  width: double.infinity,
                  margin: const EdgeInsets.only(
                    top: 0,
                    bottom: 50,
                    left: 10,
                    right: 10,
                  ),
                  child: ListView.builder(
                    itemCount: listItems.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              dropDownValue = listItems[index];
                              isStrechedDropDown = false;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                          imagesMap[
                                              listItems[index].toLowerCase()]!,
                                        ),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: mediaQuery.size.width * 0.05,
                                ),
                                Text(
                                  listItems[index],
                                  style: TextStyle(
                                    fontSize: mediaQuery.textScaleFactor * 23,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 70),
        child: FloatingActionButton(
          onPressed: () {
            _submitData(context);
            if (titleText.text.trim().isNotEmpty && startDate != null) {
              final String id =
                  _date.toString().substring(20, _date.toString().length);

              notificationService.scheduleNotification(
                  titleText.text.trim(), "Task Pending", int.parse(id));
            }
          },
          child: const Icon(
            Icons.done_outline_rounded,
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  Widget customTextField(String hintText, TextEditingController txController) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextField(
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black45),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[300],
        ),
        controller: txController,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }

  Widget customHeight(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.01,
    );
  }

  Widget dateButtonDecoration(ElevatedButton button, BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return SizedBox(
      width: double.infinity,
      height: isLandscape ? size.width * 0.06 : size.height * 0.075,
      child: button,
    );
  }

  void _selectStartDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        startDate = pickedDate;
      });
    });
  }

  void _submitData(BuildContext context) {
    final taskTitle = titleText.text.trim();
    final taskDesc = descText.text.trim();

    if (taskTitle.isEmpty) {
      AwesomeDialog(
        dismissOnBackKeyPress: false,
        dismissOnTouchOutside: false,
        context: context,
        dialogType: DialogType.INFO,
        title: 'Add a title to the task!',
        btnOkOnPress: () {
          Navigator.of(context).pop;
        },
        btnOkText: 'OK',
        btnOkColor: Theme.of(context).colorScheme.primary,
        buttonsTextStyle: const TextStyle(
          color: Colors.white,
        ),
      ).show();
      return;
    }

    Provider.of<TasksProvider>(context, listen: false).addTask(
      taskTitle,
      taskDesc,
      startDate,
      dropDownValue.toLowerCase(),
      _date,
    );
    isStrechedDropDown = false;
    Navigator.of(context).pop();
  }
}
