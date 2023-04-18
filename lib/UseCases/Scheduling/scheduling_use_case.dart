import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:luna/Services/Calendar/calendar_service.dart';
import 'package:luna/Services/Movies/movie_service.dart';
import 'package:luna/Services/maps_service.dart';
import 'package:luna/UseCases/use_case.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:luna/Services/notification_service.dart';

import '../../Services/location_service.dart';

@pragma('vm:entry-point')
void onNotificationTap(NotificationResponse response) {
  print('notificationTap');
}

class SchedulingUseCase implements UseCase {
  /// Singleton instance of [GoodNightUseCase].
  static final instance = SchedulingUseCase._();

  SchedulingUseCase._() {
    flutterTts.setLanguage("en-US");
  }

  List<String> schedulingTriggerWords = ["schedule", "scheduling"];
  List<String> calendarTriggerWords = ["calendar", "events", "plans"];
  List<String> movieTriggerWords = ["movie", "film", "movies", "films", "show", "shows"];

  FlutterTts flutterTts = FlutterTts();

  SchedulingUseCase() {
    flutterTts.setLanguage("en-US");
  }

  @override
  void execute(String trigger) {
    if (calendarTriggerWords.any((element) => trigger.contains(element))) {
      print("triggered calendar case");
      listUpcomingEvents();
      return;
    } else if (movieTriggerWords.any((element) => trigger.contains(element))) {
      print("triggered maps case");
      listMovies();
      return;
    }
    flutterTts.speak("I don't know what you want");
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
      flutterTts.speak("You have no events planned today.");
    }
    else if (events.length == 1) {
      flutterTts.speak("You have ${events.length} event planned this today.");
    }
    else {
      flutterTts.speak("You have ${events.length} events planned today.");
    }
    
    for (var i = 0; i < events.length; i++) {
      flutterTts.speak(
        "The event ${events[i].title} takes place from ${getTimeFromHoursMinutes(events[i].start!.hour, events[i].start!.minute)} till ${getTimeFromHoursMinutes(events[i].end!.hour, events[i].end!.minute)}.");
      if (events[i].description != null) {
        flutterTts.speak("The event has following description: ${events[i].description}");
      }
      if (events[i].location != null) {
        flutterTts.speak("The event takes place in the location ${events[i].location}");
        final travelDuration = await getTravelDuration(events[i].location!);
        flutterTts.speak("You will need an estimated time of $travelDuration");
        
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
        Map<String, dynamic> routeDetails =
                        await mapsService.getRouteDetails(
                            origin: position!,
                            destination: destination,
                            travelMode: "driving",
                            departureTime: DateTime.now());
      return "${routeDetails['durationAsText']}";
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

  void listMovies() async{
    final movies = await getPopularMovies();
    flutterTts.speak("The 5 most popular movies from the movie database are:");
    
    for (var i = 0; i < 5; i++) {
      final movie = movies[i];
      flutterTts.speak(movie["title"]);
    }
  }
}