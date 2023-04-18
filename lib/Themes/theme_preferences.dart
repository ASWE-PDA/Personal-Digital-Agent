import "package:shared_preferences/shared_preferences.dart";

/// Class that is responsible for loading and updating the theme preference.
class ThemePreferences {
  static const themeKey = "theme_key";

  /// Updates the [value] of the theme.
  setTheme(bool value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(themeKey, value);
  }

  /// Deletes the theme preference.
  deleteTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove(themeKey);
  }

  /// Loads the value of the stored theme.
  getTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(themeKey);
  }
}
