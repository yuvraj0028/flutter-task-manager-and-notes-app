import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screens/user_add_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (!isLandscape)
            Image.asset(
              'assets/images/splashimg.png',
              fit: BoxFit.contain,
            ),
          Text(
            'Task Management & To-Do List',
            textAlign: TextAlign.center,
            style: GoogleFonts.oswald(
              fontSize: mediaQuery.textScaleFactor * 27,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            width: mediaQuery.size.width * 0.7,
            child: Text(
              'This productive tool is designed to help you better manage your task project-wise conveniently!',
              textAlign: TextAlign.center,
              style: GoogleFonts.oswald(
                fontSize: mediaQuery.textScaleFactor * 20,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(15),
            height: isLandscape
                ? mediaQuery.size.width * 0.08
                : mediaQuery.size.height * 0.08,
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(25),
                  ),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(
                  UserAddScreen.routeName,
                );
              },
              label: Text(
                'Let\'s Start',
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
    );
  }
}
