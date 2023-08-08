import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import '../providers/user_provider.dart';
import '../screens/splash_screen.dart';
import '../providers/auth.dart';
import '../providers/tasks_provider.dart';
import '../widget/my_drawer.dart';
import '../providers/notes_provider.dart';
import '../screens/tabs_screen.dart';
import '../helper/notification_service.dart';

class UserDetailScreen extends StatefulWidget {
  static const routeName = '/user-detail';

  const UserDetailScreen({super.key});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  @override
  void initState() {
    Provider.of<UserProvider>(context, listen: false).fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context).colorScheme.secondary;
    final mediaQuery = MediaQuery.of(context);
    final userData = Provider.of<UserProvider>(context);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
      ),
      drawer: const MyDrawer(),
      extendBodyBehindAppBar: true,
      body: isLandscape
          ? _landscapeView(mediaQuery, themeData, userData, context)
          : _protraitView(mediaQuery, themeData, userData, context),
    );
  }

  Widget _protraitView(MediaQueryData mediaQuery, Color themeData,
      UserProvider userData, BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom),
        child: SizedBox(
          height: mediaQuery.size.height * 1.0,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 50),
                    ),
                    CircleAvatar(
                      backgroundColor: themeData,
                      maxRadius: mediaQuery.size.height * 0.1,
                      minRadius: mediaQuery.size.height * 0.05,
                      backgroundImage: userData.user.image.isEmpty
                          ? null
                          : NetworkImage(userData.user.image),
                    ),
                    SizedBox(
                      height: mediaQuery.size.height * 0.03,
                    ),
                    Text(
                      userData.user.name,
                      style: TextStyle(
                        fontSize: mediaQuery.textScaleFactor * 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: mediaQuery.size.height * 0.02,
                    ),
                    InkWell(
                      onTap: () {
                        changeAbout(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          userData.user.about != ''
                              ? userData.user.about
                              : 'Tap to add Description!',
                          style: TextStyle(
                            fontSize: mediaQuery.textScaleFactor * 20,
                            color: Colors.grey[700],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    customButton('Home', () {
                      Navigator.of(context).pushReplacementNamed(
                        Tabs.routeName,
                      );
                    }, const Icon(Icons.home), themeData),
                    customButton('Light Mode', () {
                      userData.setTheme(false);
                    }, const Icon(Icons.sunny), themeData),
                    customButton('Dark Mode', () {
                      userData.setTheme(true);
                    }, const Icon(Icons.nightlight), themeData),
                  ],
                ),
                customButton('Logout', () {
                  confirmDialog(context);
                }, const Icon(Icons.logout), Colors.red[300]!),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _landscapeView(MediaQueryData mediaQuery, Color themeData,
      UserProvider userData, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: mediaQuery.size.width * 0.05,
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 90),
              ),
              CircleAvatar(
                backgroundColor: themeData,
                maxRadius: mediaQuery.size.width * 0.1,
                // minRadius: mediaQuery.size.width * 0.05,
                backgroundImage: NetworkImage(userData.user.image),
              ),
              Text(
                userData.user.name,
                style: TextStyle(
                    fontSize: mediaQuery.textScaleFactor * 30,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        SizedBox(
          width: mediaQuery.size.width * 0.1,
        ),
        SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 90),
              ),
              customButton('Home', () {
                Navigator.of(context).pushReplacementNamed(
                  Tabs.routeName,
                );
              }, const Icon(Icons.home), themeData),
              customButton('Light Mode', () {
                userData.setTheme(false);
              }, const Icon(Icons.sunny), themeData),
              customButton('Dark Mode', () {
                userData.setTheme(true);
              }, const Icon(Icons.nightlight), themeData),
              customButton('Logout', () {
                confirmDialog(context);
              }, const Icon(Icons.logout), Colors.red[300]!),
            ],
          ),
        ),
      ],
    );
  }

  Widget customButton(String title, Function fx, Icon icon, Color color) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Container(
      width: isLandscape ? mediaQuery.size.width * 0.5 : double.infinity,
      height: isLandscape
          ? mediaQuery.size.width * 0.075
          : mediaQuery.size.height * 0.075,
      padding: const EdgeInsets.all(5.0),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
        ),
        onPressed: () {
          fx();
        },
        label: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: TextStyle(
              fontSize: mediaQuery.textScaleFactor * 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        icon: icon,
      ),
    );
  }

  void changeAbout(BuildContext context) async {
    final about = TextEditingController();
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    bool check = false;
    showModalBottomSheet(
      barrierColor: Colors.black.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      isScrollControlled: true,
      context: context,
      builder: (context) {
        final mediaQuery = MediaQuery.of(context);
        return Container(
          padding: EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom),
          child: SizedBox(
            height: isLandscape
                ? mediaQuery.size.width * 0.3
                : mediaQuery.size.height * 0.3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: isLandscape
                      ? mediaQuery.size.width * 0.15
                      : mediaQuery.size.height * 0.15,
                  padding: const EdgeInsets.all(5.0),
                  child: TextField(
                    maxLength: 30,
                    maxLines: 1,
                    decoration: const InputDecoration(
                      label: Text('Add Description'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    controller: about,
                  ),
                ),
                SizedBox(
                  height: mediaQuery.size.height * 0.02,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    height: isLandscape
                        ? mediaQuery.size.width * 0.075
                        : mediaQuery.size.height * 0.075,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: IconButton(
                      onPressed: () {
                        if (about.text.isEmpty) {
                          return;
                        }
                        check = true;
                        Provider.of<UserProvider>(context, listen: false)
                            .updateAbout(about.text.trim());
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.done_all_sharp),
                      color: Colors.white,
                      iconSize: isLandscape
                          ? mediaQuery.size.width * 0.05
                          : mediaQuery.size.height * 0.05,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (check) {
      about.dispose();
    }
  }

  void confirmDialog(BuildContext context) {
    final NotificationService notificationService = NotificationService();
    AwesomeDialog(
      dismissOnBackKeyPress: false,
      dismissOnTouchOutside: false,
      context: context,
      dialogType: DialogType.INFO,
      title: 'This will delete your all data!',
      btnOkOnPress: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const SplashScreen(),
          ),
        );
        Navigator.of(context).pop;
        Provider.of<TasksProvider>(context, listen: false).logout();
        Provider.of<UserProvider>(context, listen: false).logout();
        Provider.of<Auth>(context, listen: false).logout();
        Provider.of<NotesProvider>(context, listen: false).logout();
        Provider.of<UserProvider>(context, listen: false).deleteThemeData();
        notificationService.stopAllNotification();
      },
      btnOkText: 'OK',
      btnOkColor: Colors.red[300],
      btnCancelOnPress: () {
        Navigator.of(context).pop;
      },
      btnCancelText: 'NO',
      btnCancelColor: Theme.of(context).colorScheme.primary,
      buttonsTextStyle: const TextStyle(
        color: Colors.white,
      ),
    ).show();
  }
}
