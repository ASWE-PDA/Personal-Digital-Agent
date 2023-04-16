import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:luna/Services/Alarm/alarm_service.dart';
import 'package:luna/Services/Calendar/calendar_service.dart';
import 'package:luna/UseCases/scheduling_model.dart';
import 'package:luna/UseCases/use_case.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:luna/Services/notification_service.dart';

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

  SchedulingModel goodNightModel = SchedulingModel();

  int notificationId = 2;

  SchedulingUseCase() {
    flutterTts.setLanguage("en-US");
  }

  /// Loads preferences from SharedPreferences.
  Future<void> loadPreferences() async {
    await goodNightModel.getGoodNightPreferences();
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
    final events = getUpcomingEvents();
    print(events);
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