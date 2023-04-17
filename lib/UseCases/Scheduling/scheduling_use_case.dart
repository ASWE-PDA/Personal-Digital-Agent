import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:luna/Services/Alarm/alarm_service.dart';
import 'package:luna/Services/Calendar/calendar_service.dart';
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
  List<String> mailTriggerWords = ["mail", "messages"];
  List<String> mapsTriggerWords = ["maps", "route"];

  FlutterTts flutterTts = FlutterTts();


  int notificationId = 2;

  SchedulingUseCase() {
    flutterTts.setLanguage("en-US");
  }

  /// Loads preferences from SharedPreferences.
  Future<void> loadPreferences() async {
  }

  @override
  void execute(String trigger) {
    if (schedulingTriggerWords.any((element) => trigger.contains(element))) {
      print("triggered scheduling case");
      wishGoodNight();
      return;
    } else if (calendarTriggerWords.any((element) => trigger.contains(element))) {
      print("triggered calendar case");
      listUpcomingEvents();
      return;
    } else if (mailTriggerWords.any((element) => trigger.contains(element))) {
      print("triggered mail case");
      startSleepPlayList();
      return;
    } else if (mapsTriggerWords.any((element) => trigger.contains(element))) {
      print("triggered maps case");
      setAlarm();
      return;
    }
    flutterTts.speak("I don't know what you want");
    return;
  }

  /// Schedules a daily notification for the good night use case.
  ///
  /// The method cancels the old notificaion schedule and schedules a new one
  /// at the time defined by [hours] and [minutes].
  Future<void> schedule(int hours, int minutes) async {
    await NotificationService.instance.init(onNotificationTap);

    await NotificationService.instance.cancel(notificationId);

    await NotificationService.instance.scheduleAlarmNotif(
      id: notificationId,
      title: "Good Night",
      body: "It is time to go to sleep!",
      dateTime: Time(hours, minutes, 0),
    );
    print("Notification scheduled for $hours:$minutes");
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
      ...mailTriggerWords,
      ...mapsTriggerWords
    ];
  }

  /// Lists all upcoming events
  void listUpcomingEvents() async {
    final events = await getUpcomingEvents();
    flutterTts.speak("You have ${events.length} events planned today.");
    for (var i = 0; i < events.length; i++) {
      flutterTts.speak(
        "From ${getTimeFromHoursMinutes(events[i].start!.hour, events[i].start!.minute)} till ${getTimeFromHoursMinutes(events[i].end!.hour, events[i].end!.minute)}.");
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

  // TODO: implement this
  void askForSleepPlaylist() {
    flutterTts.speak("Do you want me to start a sleep playlist for you?");
  }

  // TODO: implement this
  void startSleepPlayList() {
    print("starting sleep playlist");
    flutterTts.speak("I started your sleep playlist");
  }

  // TODO: implement this
  void askForWakeUpTime() {
    flutterTts.speak("When do you want to wake up tomorrow?");
  }

  // TODO: get user input
  void setAlarm() {
    DateTime dateTime = DateTime.now().add(Duration(seconds: 10));
    setAlarmByDateTime(dateTime);
    flutterTts.speak(
        "I set your alarm to ${dateTime.hour}:${dateTime.minute} tomorrow");
  }

  void wishGoodNight() {
    flutterTts.speak("Good Night. Sleep Well.");
  }
}