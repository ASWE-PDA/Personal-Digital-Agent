import 'package:flutter/material.dart';
import 'package:luna/UseCases/good_night_preferences.dart';

/// Class that stores a good night time and notifies the app.
class GoodNightModel extends ChangeNotifier {
  GoodNightPreferences goodNightPreferences = GoodNightPreferences();
  int? _hours;
  int? _minutes;

  int? get hours => _hours;
  int? get minutes => _minutes;

  /// Constructor of the [GoodNightModel] class.
  GoodNightModel() {
    getGoodNightPreferences();
  }

  /// Returns the stored good night time as a string.
  String getPreferencesAsString() {
    if (_hours != null && _minutes != null) {
      if (_hours! < 10 && _minutes! < 10) {
        return "0$_hours:0$_minutes";
      } else if (_hours! < 10) {
        return "0$_hours:$_minutes";
      } else if (_minutes! < 10) {
        return "$_hours:0$_minutes";
      } else {
        return "$_hours:$_minutes";
      }
    }
    return "";
  }

  /// Loads the good night time that is stored as shared preference.
  getGoodNightPreferences() async {
    _hours = await goodNightPreferences.getHours();
    _minutes = await goodNightPreferences.getMinutes();
    notifyListeners();
  }

  /// Deletes the stored good night time.
  deleteGoodNightPreferences() async {
    await goodNightPreferences.deleteTime();
    _hours = null;
    _minutes = null;
    notifyListeners();
  }

  /// Updates the [value] of the stored hours.
  set setHours(int value) {
    _hours = value;
    goodNightPreferences.setHours(value);
    notifyListeners();
  }

  /// Updates the [value] of the stored minutes.
  set setMinutes(int value) {
    _minutes = value;
    goodNightPreferences.setMinutes(value);
    notifyListeners();
  }
}
