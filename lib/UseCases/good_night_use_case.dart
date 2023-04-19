import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:luna/Services/Alarm/alarm_service.dart';
import 'package:luna/Services/SmartHome/bridge_model.dart';
import 'package:luna/Services/SmartHome/smart_home_service.dart';
import 'package:luna/Services/spotify_service.dart';
import 'package:luna/UseCases/good_morning_model.dart';
import 'package:luna/UseCases/good_night_model.dart';
import 'package:luna/UseCases/use_case.dart';
import 'package:luna/Services/notification_service.dart';
import 'package:speech_to_text/speech_to_text.dart';

@pragma('vm:entry-point')
void onNotificationTap(NotificationResponse response) {
  print('notificationTap');
}

/// Use case for the Good Night feature.
class GoodNightUseCase extends UseCase {
  /// Singleton instance of [GoodNightUseCase].
  static final instance = GoodNightUseCase._();

  /// Private constructor for [GoodNightUseCase] class.
  GoodNightUseCase._();

  /// List of trigger words for the Good Night feature.
  List<String> goodNightTriggerWords = ["good night", "night"];
  List<String> lightTriggerWords = ["light", "lights", "turn off"];
  List<String> sleepPlaylistTriggerWords = ["music", "playlist", "spotify"];
  List<String> alarmTriggerWords = ["alarm", "wake up", "wake me up"];
  List<String> yesTriggerWords = ["Yes", "Ja", "yes", "ja", "please", "Please"];

  BridgeModel bridgeModel = BridgeModel();
  GoodNightModel goodNightModel = GoodNightModel();
  SmartHomeService smartHomeService = SmartHomeService();
  SpotifySdkService spotifySdkService = SpotifySdkService();
  GoodMorningModel goodMorningModel = GoodMorningModel();

  String lastWords = '';
  String playlistId = "6X7wz4cCUBR6p68mzM7mZ4";
  int notificationId = 2;

  /// Loads preferences from SharedPreferences.
  Future<void> loadPreferences() async {
    await bridgeModel.getBridgePreferences();
    await goodNightModel.getGoodNightPreferences();
  }

  @override
  void execute(String trigger) async {
    flutterTts.setLanguage("en-US");
    if (goodNightTriggerWords.any((element) => trigger.contains(element))) {
      print("triggered good night case");
      executeCompleteUseCase();
      return;
    } else if (lightTriggerWords.any((element) => trigger.contains(element))) {
      print("triggered light case");
      await turnOffAllLights().then((value) {
        flutterTts.speak(value);
      });
      return;
    } else if (sleepPlaylistTriggerWords
        .any((element) => trigger.contains(element))) {
      print("triggered sleep playlist case");
      await startSleepPlayList();
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

  /// Turns off all lights using the smarthome service.
  Future<String> turnOffAllLights() async {
    // load preferences
    await loadPreferences();
    String ip = bridgeModel.ip;
    String user = bridgeModel.user;
    print("turning off lights: $ip, $user");

    // check if ip and user are set
    if (ip == "" && user == "") {
      return "I don't know your ip address or user. Sorry I can't turn off your lights.";
    } else {
      try {
        String response = "";
        var lights = await smartHomeService.getLights(ip, user);
        if (lights.isEmpty) {
          return "Sorry, you don't have any lights connected.";
        } else {
          for (var light in lights) {
            await smartHomeService
                .turnOffLight(light, ip, user)
                .then((value) {})
                .catchError((e) {
              print("error turning off light: $e");
              response +=
                  "Sorry, I couldn't turn off your light ${light.name}. ";
            });
          }
          response += "Your lights are turned off. ";
          return response;
        }
      } catch (_) {
        return "Sorry, I couldn't turn off your lights.";
      }
    }
  }

  /// Asks the user if he wants a sleep playlist and starts it if the user
  /// answers with yes.
  Future<void> askForSleepPlaylist() async {
    await textToSpeechOutput(
        "Do you want me to start a sleep playlist for you?");

    String answer = await listenForSpeech(Duration(seconds: 5));
    print("Spotify Answer is $answer");
    bool alarm = checkIfAnswerIsYes(answer);
    if (alarm) {
      await startSleepPlayList();
    } else {
      await textToSpeechOutput("Okay, I don't start a playlist. Good Night!");
      return;
    }
  }

  /// Connects to the Spotify App and starts a spotify sleeping playlist.
  Future<void> startSleepPlayList() async {
    try {
      bool result = await spotifySdkService.connect();
      print(result);
      if (result) {
        print("starting playlist");
        spotifySdkService.playPlaylist(playlistId);
      }
    } catch (e) {
      print(e);
    }
  }

  /// Asks the user if he wants an alarm and sets it if the user answers with yes.
  /// The alarm is set to the time defined by the user in the good morning preferences.
  Future<void> askForWakeUpTime() async {
    await textToSpeechOutput("Do you want an alarm for tomorrow?");
    String answer = await listenForSpeech(Duration(seconds: 5));
    print("Answer is $answer");
    bool alarm = checkIfAnswerIsYes(answer);
    if (alarm) {
      String result = await setAlarm();
      await textToSpeechOutput(result);
      return;
    } else {
      await textToSpeechOutput("Okay, I don't set an alarm.");
      return;
    }
  }

  /// Sets an alarm for the time defined by in the good morning preferences.
  ///
  /// Returns a string that contains the time of the alarm.
  Future<String> setAlarm() async {
    TimeOfDay timeOfDay = await goodMorningModel.getWakeUpTime();
    DateTime tomorrow = DateTime.now().add(Duration(days: 1));
    DateTime dateTime = DateTime(tomorrow.year, tomorrow.month, tomorrow.day,
        timeOfDay.hour, timeOfDay.minute, 0);
    setAlarmByDateTime(dateTime);
    return "I set your alarm to ${dateTime.hour}:${dateTime.minute} tomorrow";
  }

  /// Executes the complete good night use case.
  Future<void> executeCompleteUseCase() async {
    await textToSpeechOutput("Good Night. Sleep Well.");
    await askForWakeUpTime();
    String answer = await turnOffAllLights();
    await textToSpeechOutput(answer);
    await askForSleepPlaylist();
  }

  /// Checks if the answer of the user contains a yes trigger word.
  ///
  /// Returns true if the answer contains a yes trigger word.
  bool checkIfAnswerIsYes(String answer) {
    if (yesTriggerWords.any((element) => answer.contains(element))) {
      print("answer is yes");
      return true;
    }
    print("answer is not yes");
    return false;
  }
}
