import 'package:shared_preferences/shared_preferences.dart';

/// Class that is responsible for loading and updating the shared preferences for the bridge configuration.
class GoodNightPreferences {
  static const hoursKey = 'hours_key';
  static const minutesKey = 'minutes_key';

  /// Updates the [hours] and [minutes] of the good night schedule time.
  Future<void> setHours(int hours) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt(hoursKey, hours);
  }

  /// Updates the [hours] and [minutes] of the good night schedule time.
  Future<void> setMinutes(int minutes) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt(minutesKey, minutes);
  }

  /// Deletes the time stamp.
  deleteTime() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove(hoursKey);
    sharedPreferences.remove(minutesKey);
  }

  /// Loads the hours value.
  getHours() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt(hoursKey);
  }

  /// Loads the minutes value.
  getMinutes() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt(minutesKey);
  }
}
