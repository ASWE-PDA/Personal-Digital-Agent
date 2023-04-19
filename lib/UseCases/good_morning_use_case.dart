import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:luna/Services/location_service.dart';
import 'package:luna/Services/maps_service.dart';
import 'package:luna/Services/notification_service.dart';
import 'package:luna/Services/weather_service.dart';
import 'package:luna/UseCases/use_case.dart';
import 'package:luna/UseCases/good_morning_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

@pragma('vm:entry-point')
void onNotificationTap(NotificationResponse response) {
  print("notificationTap");
}

/// Use case for the Good Morning feature.
class GoodMorningUseCase extends UseCase {
  /// Singleton instance of [GoodMorningUseCase].
  static final instance = GoodMorningUseCase._();

  GoodMorningUseCase._() {
    flutterTts.setLanguage("en-US");
  }

  List<String> goodMorningTriggerWords = ["good morning", "morning"];
  FlutterTts flutterTts = FlutterTts();
  GoodMorningModel goodMorningModel = GoodMorningModel();
  int notificationId = 3;

  LocationService locationService = LocationService.instance;
  WeatherService weatherService = WeatherService();
  MapsService mapsService = MapsService();

  /// Loads preferences from SharedPreferences.
  Future<void> loadPreferences() async {
    await goodMorningModel.getGoodMorningPreferences();
  }

  String formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dateTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final formatter = DateFormat("jm"); // e.g. 5:08 AM
    return formatter.format(dateTime);
  }

  @override
  Future<void> execute(String trigger) async {
    if (goodMorningTriggerWords.any((element) => trigger.contains(element))) {
      print("triggered good morning case");

      String output = "Good morning. ";

      // Check current location
      Position? currentLocation = await locationService.getCurrentLocation();
      if (currentLocation == null) {
        output +=
            "Sorry, I couldn't get your current location. Hence, I can't get any weather data nor your route to work. ";
      } else {
        // Get weather data
        WeatherData? weatherData = await weatherService.getCurrentWeather();
        if (weatherData == null) {
          output += "Sorry, I couldn't get the weather data for you. ";
        } else {
          output +=
              "It's currently ${weatherData.currentTemp} degrees outside which feels like ${weatherData.feelsLikeTemp} degrees. ";
        }

        // Get route to work
        String? workAddress = await goodMorningModel.getWorkAddress();
        if (workAddress == null) {
          output +=
              "Please enter your work address in the setting page before I can get you any details on your route to work. ";
        } else {
          TimeOfDay preferredArrivalTime0 =
              await goodMorningModel.getPreferredArrivalTime();
          String transportMode0 = (await goodMorningModel.getTransportMode())!;

          print("in 'get route to work'");
          print("currentLocation: $currentLocation");
          print("workAddress: $workAddress");
          print("travelMode: $transportMode0");
          print("arrivalTime: $preferredArrivalTime0");
          Map<String, dynamic> routeDetails = await mapsService.getRouteDetails(
            origin: currentLocation,
            destination: workAddress,
            travelMode: transportMode0,
            arrivalTime: preferredArrivalTime0,
          );

          if (routeDetails == null) {
            output += "Unfortunately, I can't get your route to work. ";
          } else {
            // Calculate travel time
            String travelTimeString = routeDetails["durationAsText"];
            int travelTimeInSeconds = routeDetails["durationInSeconds"];
            int travelTimeInMinutes = travelTimeInSeconds ~/ 60;

            // convert _preferredArrivalTime to DateTime
            DateTime now = DateTime.now();
            DateTime preferredArrivalTime = DateTime(
                now.year,
                now.month,
                now.day,
                preferredArrivalTime0.hour,
                preferredArrivalTime0.minute);

            // convert travelTimeInMinutes to Duration
            Duration travelTimeDuration =
                Duration(minutes: travelTimeInMinutes);

            // subtract travelTimeDuration from preferredArrivalTime
            DateTime optimalDepartureDateTime =
                preferredArrivalTime.subtract(travelTimeDuration);

            // convert optimalDepartureTime to TimeOfDay
            TimeOfDay optimalDepartureTime =
                TimeOfDay.fromDateTime(optimalDepartureDateTime);

            // speak
            output += "It will take you $travelTimeString to get to work. ";
            output +=
                "To arrive at work at ${formatTimeOfDay(preferredArrivalTime0)}, you should leave at ${formatTimeOfDay(optimalDepartureTime)}. ";
          }
        }
      }
      output += "Have a great day!";
      flutterTts.speak(output);
      return;
    }
    flutterTts.speak("I don't know what you want");
    return;
  }

  /// Schedules a daily notification for the good morning use case.
  ///
  /// The method cancels the old notification schedule and schedules a new one
  /// at the time defined by [hours] and [minutes].
  Future<void> schedule(int hours, int minutes) async {
    await NotificationService.instance.init(onNotificationTap);

    await NotificationService.instance.cancel(notificationId);

    await NotificationService.instance.scheduleAlarmNotif(
      id: notificationId,
      title: "Good Morning",
      body: "It is time to wake up!",
      dateTime: Time(hours, minutes, 0),
    );
    print("Notification scheduled for $hours:$minutes");
  }

  /// Returns a list of all trigger words.
  List<String> getAllTriggerWords() {
    return [
      ...goodMorningTriggerWords,
    ];
  }

  @override
  Future<bool> checkTrigger() async {
    return false;
  }
}
