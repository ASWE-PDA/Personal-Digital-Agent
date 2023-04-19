import "dart:async";
import "package:flutter/material.dart";
import "package:flutter_local_notifications/flutter_local_notifications.dart";
import "package:geolocator/geolocator.dart";
import "package:luna/Services/Calendar/calendar_service.dart";
import "package:luna/Services/Movies/movie_service.dart";
import "package:luna/Services/maps_service.dart";
import "package:luna/UseCases/use_case.dart";
import '../../Services/location_service.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

class EventPlanningUseCase extends UseCase {
  /// Singleton instance of [GoodNightUseCase].
  static final instance = EventPlanningUseCase._();

  EventPlanningUseCase._() {
    flutterTts.setLanguage("en-US");
  }

  List<String> schedulingTriggerWords = ["schedule", "scheduling"];
  List<String> calendarTriggerWords = ["calendar", "events", "plans"];
  List<String> movieTriggerWords = [
    "movie",
    "film",
    "movies",
    "films",
    "show",
    "shows"
  ];

  @override
  void execute(String trigger) {
    if (calendarTriggerWords.any((element) => trigger.contains(element))) {
      listUpcomingEvents();
      return;
    } else if (movieTriggerWords.any((element) => trigger.contains(element))) {
      listMovies();
      return;
    }
    textToSpeechOutput("I don't know what you want");
    return;
  }

  /// Returns a list of all trigger words.
  List<String> getAllTriggerWords() {
    return [
      ...schedulingTriggerWords,
      ...calendarTriggerWords,
      ...movieTriggerWords,
    ];
  }

  /// Lists all upcoming events
  void listUpcomingEvents() async {
    CalendarService calendar = CalendarService();
    final events = await calendar.getUpcomingEvents();
    if (events.isEmpty) {
      await textToSpeechOutput("You have no events planned today.");
    } else if (events.length == 1) {
      await textToSpeechOutput(
          "You have ${events.length} event planned today.");
    } else {
      await textToSpeechOutput(
          "You have ${events.length} events planned today.");
    }

    String output = "";
    for (var i = 0; i < events.length; i++) {
      output +=
          "The event ${events[i].title} takes place from ${getTimeFromHoursMinutes(events[i].start!.hour, events[i].start!.minute)} till ${getTimeFromHoursMinutes(events[i].end!.hour, events[i].end!.minute)}.";
      if (events[i].description != null) {
        output += "It following description: ${events[i].description}. ";
      }
      if (events[i].location != null) {
        output += "The location of the event is: ${events[i].location}: ";
        final travelDuration = await getTravelDuration(events[i].location!);
        output += "You will need an estimated time of $travelDuration. ";
      }
    }
    await textToSpeechOutput(output);

    var tryAgain = true;
    while (tryAgain) {
      await textToSpeechOutput(
          "Would you like to create another Event for today?");
      String answer = await listenForSpeech(Duration(seconds: 3));
      if (!answer.toLowerCase().contains("yes")) return;

      await textToSpeechOutput("Whats the name of the event?");
      String eventTitle = await listenForSpeech(Duration(seconds: 5));

      await textToSpeechOutput(
          "At what time would you like this event to take place?");
      String eventTimeInput = await listenForSpeech(Duration(seconds: 5));
      DateTime? eventTime = parseSpokenTime(eventTimeInput);
      if (eventTime == null) {
        await textToSpeechOutput(
            "I didn't get that right. Do you want to try again?");
        tryAgain = (await listenForSpeech(Duration(seconds: 3)))
            .toLowerCase()
            .contains("yes");
        continue;
      }
      await textToSpeechOutput("How many minutes should this event last?");
      String eventDurationInput = await listenForSpeech(Duration(seconds: 3));
      try {
        int eventDuration = int.parse(eventDurationInput);
        calendar.createCalendarEvent(eventTime, eventTitle, eventDuration);
        await textToSpeechOutput(
            "I created the event $eventTitle for today starting at ${getTimeFromHoursMinutes(eventTime.hour, eventTime.minute)}.");
      } catch (e) {
        await textToSpeechOutput(
            "I didn't get that right. Make sure that you only pass in the amount of minutes you want this event to last. Do you want to try again?");
        tryAgain = (await listenForSpeech(Duration(seconds: 3)))
            .toLowerCase()
            .contains("yes");
        continue;
      }
    }
  }

  Future<String> getTravelDuration(String destination) async {
    try {
      // check permisisons
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        // permission has not been granted, request permission
        final permissionStatus = await Geolocator.requestPermission();
        if (permissionStatus != LocationPermission.whileInUse &&
            permissionStatus != LocationPermission.always) {
          return "Unknown travel duration please allow location access";
        }
      }
      // get current location
      final position = await LocationService.instance.getCurrentLocation();
      MapsService mapsService = MapsService();
      Map<String, dynamic> routeDetails = await mapsService.getRouteDetails(
          origin: position!,
          destination: destination,
          departureTime: TimeOfDay.now());
      return "${routeDetails["durationAsText"]}";
    } catch (e) {}
    return "unknown travel duration";
  }

  String getTimeFromHoursMinutes(int hours, int minutes) {
    String amPm = "a.m";
    int h = hours;
    if (hours > 11) {
      if (hours != 12) h = hours - 12;
      amPm = "p.m";
    }

    if (minutes == 0) {
      return "$h $amPm";
    } else {
      return "$h:$minutes $amPm";
    }
  }

  DateTime? parseSpokenTime(String spokenTime) {
    RegExp regExp =
        RegExp(r"(\d{1,2}):?(\d{2})?\s*(a.?m.?|p.?m.?)", caseSensitive: false);
    RegExpMatch? match = regExp.firstMatch(spokenTime);

    if (match == null) {
      return null;
    }
    try {
      int hour = int.parse(match.group(1)!);
      int minute = int.parse(match.group(2) ?? "0");
      String period = match.group(3)!.toLowerCase();

      if (hour == 12) {
        hour = 0;
      }

      if (period.contains("p")) {
        hour += 12;
      }

      if (hour > 23 || minute > 59) {
        return null;
      }

      return DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, hour, minute);
    } catch (e) {
      return null;
    }
  }

  void listMovies() async {
    MovieService movieService = MovieService();
    final movies = await movieService.getPopularMovies();
    String output = "The 5 most popular movies from the movie database are: ";

    for (var i = 0; i < 5; i++) {
      final movie = movies[i];
      output += "${movie["title"]}, ";
    }

    output += ". Would you like to watch on of those Movies today? ";
    await textToSpeechOutput(output);
    String watchMovie = await listenForSpeech(Duration(seconds: 3));
    if (!watchMovie.toLowerCase().contains("yes")) {
      return;
    }
    var tryAgain = true;
    while (tryAgain) {
      String movieToWatch = await listenForSpeech(Duration(seconds: 3));
      for (var i = 0; i < 5; i++) {
        final movieTitle = movies[i]["title"];
        List<String> movieToWatcheSubstring = movieToWatch.split(" ");

        for (var substring in movieToWatcheSubstring) {
          if (movieTitle.toLowerCase().contains(substring.toLowerCase())) {
            while (tryAgain) {
              await textToSpeechOutput(
                  "When would you like to watch the movie? An example answer would be eigth zero zero pm.");
              String movieTimeInput =
                  await listenForSpeech(Duration(seconds: 5));
              DateTime? movieTime = parseSpokenTime(movieTimeInput);
              if (movieTime == null) {
                await textToSpeechOutput(
                    "I didn't get that right. Do you want to try again?");
                tryAgain = (await listenForSpeech(Duration(seconds: 3)))
                    .toLowerCase()
                    .contains("yes");
                continue;
              }
              CalendarService calendar = CalendarService();
              calendar.createCalendarEvent(movieTime, movieTitle,
                  await movieService.getMovieLength(movies[i]["id"]));
              await textToSpeechOutput(
                  "I created an Event for the movie $movieTitle at ${getTimeFromHoursMinutes(movieTime.hour, movieTime.minute)}.");
              return;
            }
          }
        }
      }
      await textToSpeechOutput(
          "I couldn't find the movie $movieToWatch. Would you like to try again?");
      tryAgain = (await listenForSpeech(Duration(seconds: 3)))
          .toLowerCase()
          .contains("yes");
    }
    return;
  }
}
