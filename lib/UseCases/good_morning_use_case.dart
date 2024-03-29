import 'package:geolocator/geolocator.dart';
import 'package:luna/Services/location_service.dart';
import 'package:luna/Services/maps_service.dart';
import 'package:luna/Services/quote_service.dart';
import 'package:luna/Services/weather_service.dart';
import 'package:luna/UseCases/use_case.dart';
import 'package:luna/UseCases/good_morning_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Use case for the Good Morning feature.
class GoodMorningUseCase extends UseCase {
  /// Singleton instance of [GoodMorningUseCase].
  static final instance = GoodMorningUseCase._();

  /// Private constructor for [GoodMorningUseCase] class.
  GoodMorningUseCase._();

  /// List of trigger words for the Good Morning feature.
  List<String> goodMorningTriggerWords = ["good morning", "morning"];
  List<String> locationTriggerWords = ["location", "where am i"];
  List<String> weatherTriggerWords = ["weather", "how's the weather"];
  List<String> routeTriggerWords = ["route", "how do i get to work"];
  List<String> quoteTriggerWords = ["quote", "inspire me"];

  GoodMorningModel goodMorningModel = GoodMorningModel();
  LocationService locationService = LocationService.instance;
  WeatherService weatherService = WeatherService();
  QuoteService quoteService = QuoteService();
  MapsService mapsService = MapsService();
  Position? currentLocation;
  WeatherData? weatherData;
  late Map<String, dynamic> routeDetails;
  QuoteData? quoteData;

  /// Loads preferences from SharedPreferences.
  Future<void> loadPreferences() async {
    await goodMorningModel.getGoodMorningPreferences();
  }

  /// Formats the [time] of day to a string.
  ///
  /// Returns a string in the format of "5:08 AM".
  String formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dateTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final formatter = DateFormat("jm"); // e.g. 5:08 AM
    return formatter.format(dateTime);
  }

  @override
  Future<void> execute(String trigger) async {
    flutterTts.setLanguage("en-US");
    if (goodMorningTriggerWords.any((element) => trigger.contains(element))) {
      textToSpeechOutput(await executeCompleteUseCase());
      return;
    } else if (locationTriggerWords
        .any((element) => trigger.contains(element))) {
      textToSpeechOutput(await executeLocationUseCase(true));
      return;
    } else if (weatherTriggerWords
        .any((element) => trigger.contains(element))) {
      textToSpeechOutput(await executeWeatherUseCase());
      return;
    } else if (routeTriggerWords.any((element) => trigger.contains(element))) {
      textToSpeechOutput(await executeRouteUseCase());
      return;
    } else if (quoteTriggerWords.any((element) => trigger.contains(element))) {
      textToSpeechOutput(await executeQuoteUseCase());
      return;
    }
    textToSpeechOutput("I don't know what you want");
    return;
  }

  /// Returns a list of all trigger words.
  List<String> getAllTriggerWords() {
    return [
      ...goodMorningTriggerWords,
      ...locationTriggerWords,
      ...weatherTriggerWords,
      ...routeTriggerWords,
      ...quoteTriggerWords
    ];
  }

  /// Executes the location use case.
  ///
  /// Returns the output string.
  Future<String> executeLocationUseCase(bool outputEnabled) async {
    String output = "";
    currentLocation = await locationService.getCurrentLocation();
    if (currentLocation == null) {
      output += "Sorry, I couldn't get your current location.";
    } else if (outputEnabled) {
      output +=
          "You are currently at latitude ${currentLocation!.latitude} and longitude ${currentLocation!.longitude}.";
    }
    return output;
  }

  /// Executes the weather use case.
  ///
  /// Returns the output string.
  Future<String> executeWeatherUseCase() async {
    String output = "";
    if (currentLocation == null) {
      await executeLocationUseCase(false);
    }
    if (currentLocation == null) {
      output +=
          "Sorry, I couldn't get your current location. Please try again later.";
    } else {
      weatherData = await weatherService.getCurrentWeather();
      if (weatherData == null) {
        output += "Sorry, I couldn't get the weather data for you.";
      } else {
        output +=
            "It's currently ${weatherData!.currentTemp} degrees outside which feels like ${weatherData!.feelsLikeTemp} degrees.";
      }
    }
    return output;
  }

  /// Executes the route use case.
  ///
  /// Returns the output string.
  Future<String> executeRouteUseCase() async {
    String output = "";
    String? workAddress = await goodMorningModel.getWorkAddress();
    if (workAddress == "") {
      output +=
          "Please enter your work address in the setting page before I can get you any details on your route to work.";
    } else {
      if (currentLocation == null) {
        await executeLocationUseCase(false);
      }
      if (currentLocation == null) {
        output +=
            "Sorry, I couldn't get your current location. Please try again later.";
      } else {
        TimeOfDay preferredArrivalTime0 =
            await goodMorningModel.getPreferredArrivalTime();

        routeDetails = await mapsService.getRouteDetails(
          origin: currentLocation!,
          destination: workAddress!,
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
          DateTime preferredArrivalTime = DateTime(now.year, now.month, now.day,
              preferredArrivalTime0.hour, preferredArrivalTime0.minute);

          // convert travelTimeInMinutes to Duration
          Duration travelTimeDuration = Duration(minutes: travelTimeInMinutes);

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
    return output;
  }

  /// Executes the quote use case.
  ///
  /// Returns the output string.
  Future<String> executeQuoteUseCase() async {
    quoteData = await quoteService.getQuoteOfTheDay();
    String output = "";
    if (quoteData == null) {
      output += "Sorry, I couldn't get a quote for you. ";
    } else {
      output += "Here's a quote for you: ${quoteData!.quote} ";
      output += "This was by ${quoteData!.author}. ";
    }
    return output;
  }

  /// Executes the complete use case.
  ///
  /// Returns the output string.
  Future<String> executeCompleteUseCase() async {
    String output = "Good morning. ";

    output += await executeLocationUseCase(false); // Check current location
    if (currentLocation != null) {
      output += await executeWeatherUseCase(); // Get weather
      output += await executeRouteUseCase(); // Get route to work
    }
    output += await executeQuoteUseCase(); // Get quote of the day

    output += "Have a great day!";
    return output;
  }
}
