import 'package:flutter/material.dart';
import 'package:luna/Themes/theme_preferences.dart';

/// Class that stores the current theme and notifies the app.
class ThemeModel extends ChangeNotifier {
  ThemePreferences themePreferences = ThemePreferences();
  bool _isDark = false;
  bool get isDark => _isDark;

  /// Constructor of the [ThemeModel] class.
  ThemeModel() {
    getPreferences();
  }

  /// Loads the theme that is stored as shared preference.
  getPreferences() async {
    _isDark = await themePreferences.getTheme() ?? false;
    notifyListeners();
  }

  /// Deletes the stored theme preference.
  deleteThemePreferences() async {
    await themePreferences.deleteTheme();
    _isDark = false;
    notifyListeners();
  }

  /// Returns the current theme preference of the app.
  ThemeMode currentTheme() {
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  /// Updates the [value] of the theme and notifies the app.
  ///
  /// -> true: dark mode
  /// -> false: light mode
  set setTheme(bool value) {
    _isDark = value;
    themePreferences.setTheme(value);
    notifyListeners();
  }
}
