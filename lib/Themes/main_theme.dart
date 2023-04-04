import 'package:flutter/material.dart';

/// Class that contains the default colors and themes of the app.
class MyThemes {
  // light mode
  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.blueAccent,
    iconTheme: const IconThemeData(color: Colors.blueAccent),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      foregroundColor: Colors.black,
    ),
    textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.black)),
    colorScheme: const ColorScheme.light().copyWith(
      secondary: Colors.white,
      secondaryContainer: const Color.fromRGBO(218, 217, 222, 0.3),
      primary: Colors.black,
      tertiary: const Color.fromRGBO(181, 180, 186, 1.0),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        side: const BorderSide(color: Color.fromRGBO(181, 180, 186, 0.3)),
        disabledForegroundColor: const Color.fromRGBO(181, 180, 186, 1.0),
        disabledBackgroundColor: const Color.fromRGBO(218, 217, 222, 0.3),
        backgroundColor: Colors.blueAccent,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: const Color.fromRGBO(218, 217, 222, 0.3),
      filled: true,
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Color.fromRGBO(115, 114, 120, 1.0),
          width: 2.0,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent, width: 0),
        borderRadius: BorderRadius.circular(3),
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Color.fromRGBO(181, 180, 186, 1.0),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(3),
      ),
    ),
  );

  // dark mode
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: const Color.fromRGBO(64, 63, 69, 1.0),
    cardColor: const Color.fromRGBO(64, 63, 69, 1.0),
    primaryColor: Colors.blueAccent,
    iconTheme: const IconThemeData(color: Colors.blueAccent),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Color.fromRGBO(64, 63, 69, 1.0),
      foregroundColor: Colors.white,
    ),
    textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
    colorScheme: const ColorScheme.dark().copyWith(
      secondary: const Color.fromRGBO(64, 63, 69, 1.0),
      secondaryContainer: const Color.fromRGBO(115, 114, 120, 0.2),
      primary: Colors.white,
      tertiary: const Color.fromRGBO(181, 180, 186, 1.0),
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: const Color.fromRGBO(115, 114, 120, 0.2),
      filled: true,
      focusedBorder: const OutlineInputBorder(
        borderSide:
            BorderSide(color: Color.fromRGBO(218, 217, 222, 1.0), width: 2.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent, width: 0),
        borderRadius: BorderRadius.circular(3),
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Color.fromRGBO(115, 114, 120, 0.2),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(3),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        side: const BorderSide(color: Color.fromRGBO(181, 180, 186, 0.3)),
        disabledBackgroundColor: const Color.fromRGBO(115, 114, 120, 0.3),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
    ),
  );
}
