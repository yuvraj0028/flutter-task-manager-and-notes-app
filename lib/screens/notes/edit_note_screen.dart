import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import '/providers/notes_provider.dart';

class EditNote extends StatefulWidget {
  final int index;
  final String prevTitle;
  final String prevInfo;
  final Color color;

  const EditNote(
      {required this.prevTitle,
      required this.prevInfo,
      required this.index,
      required this.color,
      super.key});

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  var titleController = TextEditingController();
  var infoController = TextEditingController();

  List<Color> colorList = [
    const Color.fromARGB(255, 255, 242, 128),
    const Color.fromARGB(255, 122, 213, 255),
    const Color.fromARGB(255, 255, 129, 120),
    const Color.fromARGB(255, 237, 134, 255),
    const Color.fromARGB(255, 137, 255, 153),
  ];

  late Color noteColor;

  @override
  void initState() {
    noteColor = widget.color;
    titleController.text = widget.prevTitle;
    infoController.text = widget.prevInfo;
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    infoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Note',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            customTextField(
              'Title',
              titleController,
              50,
              1,
            ),
            customHeight(context),
            customTextField(
              'Information',
              infoController,
              500,
              10,
            ),
            customHeight(context),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              primary: false,
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5),
              itemCount: colorList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CircleAvatar(
                      backgroundColor: colorList[index],
                      child: noteColor == colorList[index]
                          ? Icon(
                              Icons.done,
                              color: Colors.black,
                              size: isLandscape
                                  ? MediaQuery.sizeOf(context).width * 0.1
                                  : MediaQuery.sizeOf(context).height * 0.05,
                            )
                          : null,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      noteColor = colorList[index];
                    });
                  },
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 70),
        child: FloatingActionButton(
          onPressed: () {
            _submit(context);
          },
          child: const Icon(
            Icons.done_outline_rounded,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      resizeToAvoidBottomInset: false,
    );
  }

  Widget customTextField(
    String hintText,
    TextEditingController txController,
    int maxLen,
    int maxLine,
  ) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextField(
        maxLength: maxLen,
        maxLines: maxLine,
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

  void _submit(BuildContext context) {
    final title = titleController.text.trim();
    final info = infoController.text
        .trim()
        .replaceAll(RegExp(r'(?:[\t ]*(?:\r?\n|\r))+'), '\n');
    if (title.isEmpty || info.isEmpty) {
      AwesomeDialog(
        dismissOnBackKeyPress: false,
        dismissOnTouchOutside: false,
        context: context,
        dialogType: DialogType.INFO,
        title: 'Please fill all the feilds!',
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

    Provider.of<NotesProvider>(context, listen: false).updateNote(
      title,
      info,
      widget.index,
      noteColor,
    );
    Navigator.of(context).pop();
  }
}
