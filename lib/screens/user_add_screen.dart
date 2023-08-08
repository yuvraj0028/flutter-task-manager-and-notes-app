import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../providers/auth.dart';
import '../screens/tabs_screen.dart';

class UserAddScreen extends StatefulWidget {
  static const routeName = '/user-add';
  const UserAddScreen({super.key});

  @override
  State<UserAddScreen> createState() => _UserAddScreenState();
}

class _UserAddScreenState extends State<UserAddScreen> {
  final _formKey = GlobalKey<FormState>();

  final name = TextEditingController();
  final about = TextEditingController();

  String selectedImage =
      'https://www.tvinsider.com/wp-content/uploads/2019/08/the-boys-homelander.jpg';

  final List<String> profileImages = [
    'https://www.tvinsider.com/wp-content/uploads/2019/08/the-boys-homelander.jpg',
    'https://wallpaperaccess.com/full/4005061.jpg',
    'https://tvseriesfinale.com/wp-content/uploads/2018/11/marvel-daredevil.jpg',
    'https://static1.moviewebimages.com/wordpress/wp-content/uploads/2023/04/oppenheimer-trailer.jpg',
  ];

  @override
  void dispose() {
    name.dispose();
    about.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fill Details'),
      ),
      body: Form(
        key: _formKey,
        child: isLandscape
            ? landScapeView(mediaQuery, context)
            : portraitView(mediaQuery, context),
      ),
    );
  }

  Widget portraitView(MediaQueryData mediaQuery, BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            SizedBox(
              height: mediaQuery.size.height * 0.1,
            ),
            SizedBox(
              height: mediaQuery.size.height * 0.25,
              child: SizedBox(
                height: mediaQuery.size.height * 0.25,
                width: mediaQuery.size.height * 0.3,
                child: Swiper(
                  scrollDirection: Axis.horizontal,
                  pagination: const SwiperPagination(),
                  loop: true,
                  itemCount: profileImages.length,
                  itemBuilder: (context, index) => CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      backgroundImage: NetworkImage(
                        profileImages[index],
                      ),
                      child: selectedImage.compareTo(profileImages[index]) == 0
                          ? Icon(
                              Icons.done,
                              size: mediaQuery.size.width * 0.08,
                            )
                          : null),
                  onTap: (index) {
                    setState(() {
                      selectedImage = profileImages[index];
                    });
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                maxLength: 15,
                maxLines: 1,
                decoration: const InputDecoration(
                  label: Text('Enter Name'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter name to continue';
                  }
                  return null;
                },
                controller: name,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                maxLength: 30,
                maxLines: 1,
                decoration: const InputDecoration(
                  label: Text('About'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                ),
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value == null) {
                    return null;
                  }
                  return null;
                },
                controller: about,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(15),
              height: mediaQuery.size.height * 0.075,
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                ),
                onPressed: () {
                  _submit(context);
                },
                label: Text(
                  'Task It',
                  style: TextStyle(
                    fontSize: mediaQuery.textScaleFactor * 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                icon: Icon(Icons.arrow_forward_sharp,
                    size: mediaQuery.textScaleFactor * 30),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget landScapeView(MediaQueryData mediaQuery, BuildContext context) {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: mediaQuery.size.width * 0.05,
          ),
          Flexible(
            child: SizedBox(
              height: mediaQuery.size.width * 0.25,
              width: mediaQuery.size.width * 0.3,
              child: Swiper(
                scrollDirection: Axis.horizontal,
                pagination: const SwiperPagination(),
                loop: true,
                itemCount: profileImages.length,
                itemBuilder: (context, index) => CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    backgroundImage: NetworkImage(
                      profileImages[index],
                    ),
                    child: selectedImage.compareTo(profileImages[index]) == 0
                        ? Icon(
                            Icons.done,
                            size: mediaQuery.size.width * 0.08,
                          )
                        : null),
                onTap: (index) {
                  setState(() {
                    selectedImage = profileImages[index];
                  });
                },
              ),
            ),
          ),
          SizedBox(
            width: mediaQuery.size.width * 0.1,
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: mediaQuery.size.height * 0.08,
                ),
                Container(
                  width: mediaQuery.size.width * 0.5,
                  margin: const EdgeInsets.all(5),
                  child: TextFormField(
                    maxLength: 15,
                    maxLines: 1,
                    decoration: const InputDecoration(
                      label: Text('Enter Name'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter name to continue';
                      }
                      return null;
                    },
                    controller: name,
                  ),
                ),
                Container(
                  width: mediaQuery.size.width * 0.5,
                  margin: const EdgeInsets.all(5),
                  child: TextFormField(
                    maxLength: 30,
                    maxLines: 1,
                    decoration: const InputDecoration(
                      label: Text('About'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    validator: (value) {
                      if (value == null) {
                        return null;
                      }
                      return null;
                    },
                    controller: about,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(5),
                  height: mediaQuery.size.width * 0.075,
                  width: mediaQuery.size.width * 0.5,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                    ),
                    onPressed: () {
                      _submit(context);
                    },
                    label: Text(
                      'Task It',
                      style: TextStyle(
                        fontSize: mediaQuery.textScaleFactor * 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    icon: Icon(Icons.arrow_forward_sharp,
                        size: mediaQuery.textScaleFactor * 30),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _submit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Provider.of<UserProvider>(context, listen: false).login(
      DateTime.now().toString(),
      selectedImage,
      name.text.trim(),
      about.text.trim(),
    );

    Provider.of<Auth>(context, listen: false).authenticate('Logged in!');

    Navigator.of(context).pushReplacementNamed(
      Tabs.routeName,
    );
  }
}
