import 'package:flutter/material.dart';
import 'package:luna/UseCases/good_morning_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Class that stores an the philips hue bridge configuration and notifies the app.
class GoodMorningModel extends ChangeNotifier {
  GoodMorningPreferences goodMorningPreferences = GoodMorningPreferences();

  TimeOfDay? _wakeUpTime;
  TimeOfDay? _preferredArrivalTime;
  String? _workAddress;
  String? _transportMode;
  bool? _latestDeparture;

  static const List<String> transportModes = [
    "Driving",
    "Transit",
    "Bicycling",
    "Walking"
  ];

  Future<TimeOfDay> get wakeUpTime async => await getWakeUpTime();
  Future<TimeOfDay> get preferredArrivalTime async =>
      await getPreferredArrivalTime();
  Future<String?> get workAddress async => await getWorkAddress();
  Future<String?> get transportMode async => await getTransportMode();
  Future<bool?> get latestDeparture async => await getLatestDeparture();

  /// Constructor of the [GoodMorningModel] class.
  GoodMorningModel(
      {TimeOfDay? wakeUpTime,
      TimeOfDay? preferredArrivalTime,
      String? workAddress,
      String? transportMode,
      bool? latestDeparture}) {
    _wakeUpTime = wakeUpTime;
    _preferredArrivalTime = preferredArrivalTime;
    _workAddress = workAddress;
    _transportMode = transportMode;
    _latestDeparture = latestDeparture;
    getGoodMorningPreferences();
  }

  static Future<GoodMorningModel> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return GoodMorningModel(
      wakeUpTime: TimeOfDay(
        hour: prefs.getInt("wakeUpTimeHour") ?? 7,
        minute: prefs.getInt("wakeUpTimeMinute") ?? 0,
      ),
      preferredArrivalTime: TimeOfDay(
        hour: prefs.getInt("preferredArrivalTimeHour") ?? 9,
        minute: prefs.getInt("preferredArrivalTimeMinute") ?? 0,
      ),
      workAddress: prefs.getString("workAddress") ?? "",
      transportMode: prefs.getString("transportMode") ?? transportModes.first,
      latestDeparture: prefs.getBool("latestDeparture") ?? false,
    );
  }

  getGoodMorningPreferences() async {
    _wakeUpTime = await goodMorningPreferences.getWakeUpTime();
    _preferredArrivalTime =
        await goodMorningPreferences.getPreferredArrivalTime();
    _workAddress = await goodMorningPreferences.getWorkAddress();
    _transportMode = await goodMorningPreferences.getTransportMode();
    _latestDeparture = await goodMorningPreferences.getLatestDeparture();
    notifyListeners();
  }

  Future<TimeOfDay> getWakeUpTime() async {
    return await goodMorningPreferences.getWakeUpTime();
  }

  Future<TimeOfDay> getPreferredArrivalTime() async {
    return await goodMorningPreferences.getPreferredArrivalTime();
  }

  Future<String?> getWorkAddress() async {
    return await goodMorningPreferences.getWorkAddress();
  }

  Future<String?> getTransportMode() async {
    return await goodMorningPreferences.getTransportMode();
  }

  Future<bool?> getLatestDeparture() async {
    return await goodMorningPreferences.getLatestDeparture();
  }

  /// Updates the [value] of the wake-up time.
  set setWakeUpTime(TimeOfDay value) {
    _wakeUpTime = value;
    goodMorningPreferences.setWakeUpTime(value);
    notifyListeners();
  }

  /// Updates the [value] of the preferred arrival time.
  set setPreferredArrivalTime(TimeOfDay value) {
    _preferredArrivalTime = value;
    goodMorningPreferences.setPreferredArrivalTime(value);
    notifyListeners();
  }

  /// Updates the [value] of the work address.
  set setWorkAddress(String value) {
    _workAddress = value;
    goodMorningPreferences.setWorkAddress(value);
    notifyListeners();
  }

  /// Updates the [value] of the transport mode.
  set setTransportMode(String value) {
    _transportMode = value;
    goodMorningPreferences.setTransportMode(value);
    notifyListeners();
  }

  /// Updates the [value] of the latest departure.
  set setLatestDeparture(bool value) {
    _latestDeparture = value;
    goodMorningPreferences.setLatestDeparture(value);
    notifyListeners();
  }
}
