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
  );

  // dark mode
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: const Color.fromRGBO(64, 63, 69, 1.0),
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
  );
}
