import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../providers/notes_provider.dart';
import '../screens/notes/edit_note_screen.dart';

class NotesBuilder extends StatefulWidget {
  const NotesBuilder({super.key});

  @override
  State<NotesBuilder> createState() => _NotesBuilderState();
}

class _NotesBuilderState extends State<NotesBuilder> {
  var isInit = false;

  @override
  void initState() {
    isInit = true;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isInit) fetchData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final notes = Provider.of<NotesProvider>(context);
    final notesList = Provider.of<NotesProvider>(context).userList;
    final mediaQuery = MediaQuery.of(context);
    return notesList.isEmpty
        ? SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      'No Notes!',
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
              ),
            ),
          )
        : isInit
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : StaggeredGridView.countBuilder(
                itemCount: notesList.length,
                staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
                crossAxisCount: 2,
                shrinkWrap: true,
                itemBuilder: (context, index) => Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 7,
                  margin: const EdgeInsets.all(10),
                  color: notesList[index].noteColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          notesList[index].title,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: mediaQuery.textScaleFactor * 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Divider(
                        thickness: 2,
                        color: Color.fromARGB(255, 104, 104, 104),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          maxLines: 6,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          notesList[index].info,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: mediaQuery.textScaleFactor * 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Divider(
                        thickness: 2,
                        color: Color.fromARGB(255, 104, 104, 104),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditNote(
                                    index: index,
                                    prevInfo: notesList[index].info,
                                    prevTitle: notesList[index].title,
                                    color: notesList[index].noteColor,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.black,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              notes.deleteNote(index);
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
  }

  void fetchData() async {
    Future.delayed(const Duration(seconds: 1), () {
      isInit = false;
    });
    await Provider.of<NotesProvider>(context).fetchData();
  }
}
