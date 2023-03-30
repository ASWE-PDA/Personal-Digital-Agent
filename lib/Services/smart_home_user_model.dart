import 'package:flutter/material.dart';
import 'package:luna/Services/smart_home_user_preferences.dart';

/// Class that stores an user name and notifies the app.
class UserModel extends ChangeNotifier {
  UserPreferences userPreferences = UserPreferences();
  String _user = "";
  String _ip = "";

  String get user => _user;
  String get ip => _ip;

  /// Constructor of the [UserModel] class.
  UserModel() {
    getUserPreferences();
  }

  /// Deletes the stored user name.
  deleteUserPreferences() async {
    await userPreferences.deleteUser();
    await userPreferences.deleteIpAddress();
    _user = "";
    _ip = "";
    notifyListeners();
  }

  /// Loads the user name that is stored as shared preference.
  getUserPreferences() async {
    _user = await userPreferences.getUser() ?? "";
    _ip = await userPreferences.getIpAddress() ?? "";
    notifyListeners();
  }

  /// Updates the [value] of the stored user name.
  set setUser(String value) {
    _user = value;
    userPreferences.setUser(value);
    notifyListeners();
  }

  /// Updates the [value] of the stored ip address.
  set setIpAddress(String value) {
    _ip = value;
    userPreferences.setIpAddress(value);
    notifyListeners();
  }
}
