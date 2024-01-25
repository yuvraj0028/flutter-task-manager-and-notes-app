import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LightTheme {
  static ThemeData lightThemeData = ThemeData(
    useMaterial3: false,
    appBarTheme: const AppBarTheme(
      elevation: 1,
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: const Color.fromARGB(255, 174, 133, 255),
      secondary: const Color.fromARGB(255, 215, 183, 255),
    ),
    textTheme: ThemeData.light().textTheme.copyWith(
          bodyMedium: GoogleFonts.robotoCondensed(
            color: Colors.black,
          ),
          titleLarge: GoogleFonts.robotoCondensed(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          titleMedium: GoogleFonts.robotoCondensed(
            color: Colors.black,
          ),
          titleSmall: GoogleFonts.robotoCondensed(
            color: Colors.black,
          ),
        ),
  );
}

class DarkTheme {
  static ThemeData darkThemeData = ThemeData(
    useMaterial3: false,
    appBarTheme: const AppBarTheme(
      elevation: 1,
    ),
    colorScheme: ColorScheme.fromSwatch(
      brightness: Brightness.dark,
    ).copyWith(
      primary: const Color.fromARGB(255, 105, 105, 105),
      secondary: const Color.fromARGB(255, 117, 117, 117),
    ),
    textTheme: ThemeData.light().textTheme.copyWith(
          bodyMedium: GoogleFonts.robotoCondensed(
            color: Colors.white,
          ),
          titleLarge: GoogleFonts.robotoCondensed(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          titleMedium: GoogleFonts.robotoCondensed(
            color: Colors.white,
          ),
          titleSmall: GoogleFonts.robotoCondensed(
            color: Colors.white,
          ),
        ),
  );
}
