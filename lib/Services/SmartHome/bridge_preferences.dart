import "package:shared_preferences/shared_preferences.dart";

/// Class that is responsible for loading and updating the shared preferences for the bridge configuration.
class BridgePreferences {
  static const userKey = "user_key";
  static const ipKey = "ip_key";

  /// Updates the [value] of the user.
  Future<void> setUser(String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(userKey, value);
  }

  /// Deletes the user name.
  deleteUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove(userKey);
  }

  /// Loads the value of the stored user.
  getUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(userKey);
  }

  /// Updates the [value] of the ip address.
  Future<void> setIpAddress(String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(ipKey, value);
  }

  /// Deletes the ip address.
  deleteIpAddress() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove(ipKey);
  }

  /// Loads the value of the ip address.
  getIpAddress() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(ipKey);
  }
}
