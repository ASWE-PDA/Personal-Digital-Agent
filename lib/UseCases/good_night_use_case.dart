import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:luna/Services/Alarm/alarm_service.dart';
import 'package:luna/Services/SmartHome/bridge_model.dart';
import 'package:luna/Services/SmartHome/smart_home_service.dart';
import 'package:luna/UseCases/good_night_model.dart';
import 'package:luna/UseCases/use_case.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:luna/Services/notification_service.dart';

@pragma('vm:entry-point')
void onNotificationTap(NotificationResponse response) {
  print('notificationTap');
}

/// Use case for the Good Night feature.
class GoodNightUseCase implements UseCase {
  /// Singleton instance of [GoodNightUseCase].
  static final instance = GoodNightUseCase._();

  GoodNightUseCase._() {
    flutterTts.setLanguage("en-US");
  }

  List<String> goodNightTriggerWords = ["good night", "night"];
  List<String> lightTriggerWords = ["light", "lights", "turn off"];
  List<String> sleepPlaylistTriggerWords = ["music", "playlist", "spotify"];
  List<String> alarmTriggerWords = ["alarm", "wake up", "wake me up"];

  FlutterTts flutterTts = FlutterTts();

  BridgeModel bridgeModel = BridgeModel();
  GoodNightModel goodNightModel = GoodNightModel();

  int notificationId = 2;

  GoodNightUseCase() {
    flutterTts.setLanguage("en-US");
  }

  /// Loads preferences from SharedPreferences.
  Future<void> loadPreferences() async {
    await bridgeModel.getBridgePreferences();
    await goodNightModel.getGoodNightPreferences();
  }

  @override
  void execute(String trigger) {
    if (goodNightTriggerWords.any((element) => trigger.contains(element))) {
      print("triggered good night case");
      wishGoodNight();
      return;
    } else if (lightTriggerWords.any((element) => trigger.contains(element))) {
      print("triggered light case");
      turnOffLights();
      return;
    } else if (sleepPlaylistTriggerWords
        .any((element) => trigger.contains(element))) {
      print("triggered sleep playlist case");
      startSleepPlayList();
      return;
    } else if (alarmTriggerWords.any((element) => trigger.contains(element))) {
      print("triggered alarm case");
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
      ...goodNightTriggerWords,
      ...lightTriggerWords,
      ...sleepPlaylistTriggerWords,
      ...alarmTriggerWords
    ];
  }

  /// Turns off all lights.
  void turnOffLights() async {
    // get the ip and user from preferences
    await loadPreferences();
    String ip = bridgeModel.ip;
    String user = bridgeModel.user;
    print("turning off lights: $ip, $user");

    // only turn off lights if ip and user are set
    if (ip != "" && user != "") {
      turnOffAllLights(ip, user);
      flutterTts.speak("Your lights are turned off. Good Night.");
      return;
    }
    flutterTts.speak(
        "I don't know your ip address or user. Sorry I can't turn off your lights.");
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
