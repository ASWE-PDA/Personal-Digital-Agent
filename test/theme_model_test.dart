import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna/Services/SmartHome/bridge_model.dart';
import 'package:luna/Themes/theme_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SharedPreferences.setMockInitialValues({});
  ThemeModel themeModel = ThemeModel();

  test("Test if dark theme is false if no preferences are set", () {
    expect(themeModel.isDark, false);
  });

  test("Test if dark theme is set to false if preferences are set", () async {
    SharedPreferences.setMockInitialValues({"theme_key": false});
    await themeModel.getPreferences();
    expect(themeModel.isDark, false);
  });

  test("Test if dark theme is set to true if preferences are set", () async {
    SharedPreferences.setMockInitialValues({"theme_key": true});
    await themeModel.getPreferences();
    expect(themeModel.isDark, true);
  });

  test("Test if theme is set correctly if preferences are updated", () async {
    themeModel.setTheme = true;
    await themeModel.getPreferences();
    expect(themeModel.isDark, true);
  });

  test("Test if the preferences are deleted", () async {
    SharedPreferences.setMockInitialValues({"theme_key": true});
    await themeModel.deleteThemePreferences();
    expect(themeModel.isDark, false);
  });

  test("Test if the current theme is light mode if no preferences are set", () {
    expect(themeModel.currentTheme(), ThemeMode.light);
  });

  test("Test if the current theme is dark mode if the preferences are set",
      () async {
    SharedPreferences.setMockInitialValues({"theme_key": true});
    await themeModel.getPreferences();
    expect(themeModel.currentTheme(), ThemeMode.dark);
  });
}
