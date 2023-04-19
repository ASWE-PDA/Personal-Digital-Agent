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

@pragma("vm:entry-point")
void onNotificationTap(NotificationResponse response) {
  print("notificationTap");
}

class EventPlanningUseCase extends UseCase {
  /// Singleton instance of [GoodNightUseCase].
  static final instance = EventPlanningUseCase._();

  EventPlanningUseCase._() {
    flutterTts.setLanguage("en-US");
  }

  EventPlanningUseCase() {
    flutterTts.setLanguage("en-US");
  }

  List<String> schedulingTriggerWords = ["schedule", "scheduling"];
  List<String> calendarTriggerWords = ["calendar", "events", "plans"];
  List<String> movieTriggerWords = ["movie", "film", "movies", "films", "show", "shows"];

  @override
  void execute(String trigger) {
    if (calendarTriggerWords.any((element) => trigger.contains(element))) {
      print("triggered calendar case");
      listUpcomingEvents();
      return;
    } else if (movieTriggerWords.any((element) => trigger.contains(element))) {
      print("triggered movie case");
      listMovies();
      return;
    }
    textToSpeechOutput("I don't know what you want");
    return;
  }
  

  @override
  Future<bool> checkTrigger() async {
    return false;
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
    final events = await getUpcomingEvents();
    if (events.isEmpty) {
      await textToSpeechOutput("You have no events planned today.");
    }
    else if (events.length == 1) {
      await textToSpeechOutput("You have ${events.length} event planned today.");
    }
    else {
      await textToSpeechOutput("You have ${events.length} events planned today.");
    }
    
    String output = "";
    for (var i = 0; i < events.length; i++) {
      output += "The event ${events[i].title} takes place from ${getTimeFromHoursMinutes(events[i].start!.hour, events[i].start!.minute)} till ${getTimeFromHoursMinutes(events[i].end!.hour, events[i].end!.minute)}.";
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
        Map<String, dynamic> routeDetails =
                        await mapsService.getRouteDetails(
                            origin: position!,
                            destination: destination,
                            travelMode: "driving",
                            departureTime: TimeOfDay.now());
      return "${routeDetails["durationAsText"]}";
    } catch (e) {
      print(e);
    }
    return "unknown travel duration";
  }

  String getTimeFromHoursMinutes(int hours, int minutes) {
    String amPm = "a.m";
    int h = hours;
    if (hours > 11) {
      if (hours != 12) h = hours-12;
      amPm = "p.m";
    }

    if (minutes == 0) {
      return "$h $amPm";
    }
    else {
      return "$h:$minutes $amPm";
    }
  }

  DateTime? parseSpokenTime(String spokenTime) {
    final RegExp timePattern = RegExp(r'(\d{1,2})(\d{2})\s*(am|pm)');
    final RegExpMatch? match = timePattern.firstMatch(spokenTime.toLowerCase());
    if (match == null) return null;

    try {
      int hour = int.parse(match.group(1)!);
      int minute = int.parse(match.group(2)!);
      String amPm = match.group(3)!;
      if (hour == 12) {
        hour = 0;
      }
      if (amPm == 'pm') {
        hour += 12;
      }
      final DateTime now = DateTime.now();
      final DateTime timeOfDay = DateTime(now.year, now.month, now.day, hour, minute);
      final String timeZoneName = tz.local.name;
      final tz.Location location = tz.getLocation(timeZoneName);
      return tz.TZDateTime.from(timeOfDay, location);
    } catch (e) {
      return null;
    }
    
  }

  void listMovies() async{
    final movies = await getPopularMovies();
    String output = "The 5 most popular movies from the movie database are: ";
    
    for (var i = 0; i < 5; i++) {
      final movie = movies[i];
      output += "${movie["title"]}, ";
    }

    output += ". Would you like to watch on of those Movies today? ";
    await textToSpeechOutput(output);

    print("=======================================\n\n\nDONE Listing NOW LISTENING\n\n\n====================================");
    String watchMovie = await listenForSpeech(Duration(seconds: 3));
    if (!watchMovie.toLowerCase().contains("yes")) {
      print("=======================================\n\n\n No YES DETECTED got $watchMovie \n\n\n====================================");
      return;
    }

    await textToSpeechOutput("Which Movie would you like to watch tonight");

    print("=======================================\n\n\nDONE Asking NOW LISTENING\n\n\n====================================");
    String movieToWatch = await listenForSpeech(Duration(seconds: 3));
    
    for (var i = 0; i < 5; i++) {
      final movieTitle = movies[i]["title"];
      List<String> movieToWatcheSubstring = movieToWatch.split(" ");

      for (var substring in movieToWatcheSubstring) {

        if (movieTitle.toLowerCase().contains(substring.toLowerCase())) {
          
          await textToSpeechOutput("When would you like to watch the movie? An example answer would be eigth zero zero pm.");
          String movieTimeInput = await listenForSpeech(Duration(seconds: 3));
          DateTime? movieTime = parseSpokenTime(movieTimeInput);
          if (movieTime == null) {
            return;
          }

          createCalendarEvent(movieTime, 
                              movieTitle, 
                              await getMovieLength(movies[i]["id"])
                              );
          await textToSpeechOutput("I created an Event for the movie $movieTitle at ${getTimeFromHoursMinutes(movieTime.hour, movieTime.minute)}.");
          return;
        }
      }  
    }
    return;
  }


  
}