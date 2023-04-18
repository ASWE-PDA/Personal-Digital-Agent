import "package:flutter/material.dart";
import "package:luna/Services/SmartHome/bridge_preferences.dart";

/// Class that stores an the philips hue bridge configuration and notifies the app.
class BridgeModel extends ChangeNotifier {
  BridgePreferences userPreferences = BridgePreferences();
  String _user = "";
  String _ip = "";

  String get user => _user;
  String get ip => _ip;

  /// Constructor of the [BridgeModel] class.
  BridgeModel() {
    getBridgePreferences();
  }

  /// Deletes the stored bridge configuration.
  deleteBridgePreferences() async {
    await userPreferences.deleteUser();
    await userPreferences.deleteIpAddress();
    _user = "";
    _ip = "";
    notifyListeners();
  }

  /// Loads the user name and the ip that is stored as shared preference.
  getBridgePreferences() async {
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
