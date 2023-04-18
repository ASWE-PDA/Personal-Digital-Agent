import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Class that is responsible for loading and updating the shared preferences for the bridge configuration.
class GoodMorningPreferences {
  static const wakeUpTimeKey = "wakeUpTime_key";
  static const preferredArrivalTimeKey = "preferredArrivalTime_key";
  static const workAddressKey = "workAddress_key";
  static const transportModeKey = "transportMode_key";
  static const latestDepartureKey = "latestDeparture_key";

  /// Updates the wake-up time.
  Future<void> setWakeUpTime(TimeOfDay wakeUpTime) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int wakeUpTimeInMinutes = wakeUpTime.hour * 60 + wakeUpTime.minute;
    sharedPreferences.setInt(wakeUpTimeKey, wakeUpTimeInMinutes);
  }

  /// Updates the preferred arrival time.
  Future<void> setPreferredArrivalTime(TimeOfDay preferredArrivalTime) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int preferredArrivalTimeInMinutes =
        preferredArrivalTime.hour * 60 + preferredArrivalTime.minute;
    sharedPreferences.setInt(
        preferredArrivalTimeKey, preferredArrivalTimeInMinutes);
  }

  /// Updates the [workAddress].
  Future<void> setWorkAddress(String workAddress) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(workAddressKey, workAddress);
  }

  /// Updates the [transportMode].
  Future<void> setTransportMode(String transportMode) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(transportModeKey, transportMode);
  }

  /// Updates the [latestDeparture].
  Future<void> setLatestDeparture(bool latestDeparture) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(latestDepartureKey, latestDeparture);
  }

  /// Loads the wake-up time.
  Future<TimeOfDay> getWakeUpTime() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int wakeUpTimeInMinutes = sharedPreferences.getInt(wakeUpTimeKey) ?? 0;
    int hours = wakeUpTimeInMinutes ~/ 60;
    int minutes = wakeUpTimeInMinutes % 60;
    return TimeOfDay(hour: hours, minute: minutes);
  }

  /// Loads the preferred arrival time.
  Future<TimeOfDay> getPreferredArrivalTime() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int preferredArrivalTimeInMinutes =
        sharedPreferences.getInt(preferredArrivalTimeKey) ?? 0;
    int hours = preferredArrivalTimeInMinutes ~/ 60;
    int minutes = preferredArrivalTimeInMinutes % 60;
    return TimeOfDay(hour: hours, minute: minutes);
  }

  /// Loads the work address value.
  getWorkAddress() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(workAddressKey) ?? "";
  }

  /// Loads the preferred transport mode.
  getTransportMode() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(transportModeKey);
  }

  /// Loads the latest departure value.
  getLatestDeparture() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(latestDepartureKey);
  }
}
