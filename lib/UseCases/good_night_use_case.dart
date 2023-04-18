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
import 'package:flutter_tts/flutter_tts.dart';
import 'package:luna/Services/notification_service.dart';
import 'package:speech_to_text/speech_to_text.dart';

@pragma('vm:entry-point')
void onNotificationTap(NotificationResponse response) {
  print('notificationTap');
}

/// Use case for the Good Night feature.
class GoodNightUseCase implements UseCase {
  /// Singleton instance of [GoodNightUseCase].
  static final instance = GoodNightUseCase._();

  GoodNightUseCase._();

  List<String> goodNightTriggerWords = ["good night", "night"];
  List<String> lightTriggerWords = ["light", "lights", "turn off"];
  List<String> sleepPlaylistTriggerWords = ["music", "playlist", "spotify"];
  List<String> alarmTriggerWords = ["alarm", "wake up", "wake me up"];
  List<String> yesTriggerWords = ["Yes", "Ja", "yes", "ja", "please", "Please"];

  FlutterTts flutterTts = FlutterTts();

  BridgeModel bridgeModel = BridgeModel();
  GoodNightModel goodNightModel = GoodNightModel();
  SmartHomeService smartHomeService = SmartHomeService();
  SpotifySdkService spotifySdkService = SpotifySdkService();
  GoodMorningModel goodMorningModel = GoodMorningModel();

  String lastWords = '';
  SpeechToText _speechToText = SpeechToText();
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
      await executeCompleteUseCase();
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

  /// Turns off all lights using the smarthome service.
  Future<String> turnOffAllLights() async {
    await loadPreferences();
    String ip = bridgeModel.ip;
    String user = bridgeModel.user;
    print("turning off lights: $ip, $user");

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

  // TODO: implement this
  Future<void> askForSleepPlaylist() async {
    Completer<bool> completer = Completer<bool>();
    await flutterTts.speak("Do you want me to start a sleep playlist for you?");
    flutterTts.setCompletionHandler(() {
      print("completed spotify speaking");
      completer.complete(true);
    });
    bool done = await completer.future;

    if (done) {
      completer = Completer();
      String answer = await listenForSpeech(Duration(seconds: 5));
      print("Spotify Answer is $answer");
      bool alarm = checkIfAnswerIsYes(answer);
      if (alarm) {
        await startSleepPlayList();
      } else {
        await flutterTts.speak("Okay, I don't start a playlist. Good Night!");
        flutterTts.setCompletionHandler(() {
          print("completed speaking");
          completer.complete(true);
        });
        done = await completer.future;
        if (done) {
          return;
        }
      }
    }
  }

  /// Connects to the Spotify App and starts a spotify sleeping playlist
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

  // TODO: implement this
  Future<void> askForWakeUpTime() async {
    Completer<bool> completer = Completer<bool>();
    await flutterTts.speak("Do you want an alarm for tomorrow?");

    flutterTts.setCompletionHandler(() {
      print("completed speaking");
      completer.complete(true);
    });

    bool done = await completer.future;

    if (done) {
      completer = Completer();
      String answer = await listenForSpeech(Duration(seconds: 5));
      print("Answer is $answer");
      bool alarm = checkIfAnswerIsYes(answer);
      if (alarm) {
        String result = await setAlarm();
        await flutterTts.speak(result);
        flutterTts.setCompletionHandler(() {
          print("completed speaking");
          completer.complete(true);
        });
        done = await completer.future;
        if (done) {
          return;
        }
      } else {
        await flutterTts.speak("Okay, I don't set an alarm.");
        flutterTts.setCompletionHandler(() {
          print("completed speaking");
          completer.complete(true);
        });
        done = await completer.future;
        if (done) {
          return;
        }
      }
    }
  }

  // TODO: get user input
  Future<String> setAlarm() async {
    TimeOfDay timeOfDay = await goodMorningModel.getWakeUpTime();
    DateTime tomorrow = DateTime.now().add(Duration(days: 1));
    DateTime dateTime = DateTime(tomorrow.year, tomorrow.month, tomorrow.day,
        timeOfDay.hour, timeOfDay.minute, 0);
    setAlarmByDateTime(dateTime);
    return "I set your alarm to ${dateTime.hour}:${dateTime.minute} tomorrow";
  }

  Future<void> executeCompleteUseCase() async {
    Completer<bool> completer = Completer<bool>();
    await flutterTts.speak("Good Night. Sleep Well.");
    flutterTts.setCompletionHandler(() {
      print("completed good night speaking");
      completer.complete(true);
    });
    await completer.future;

    completer = Completer<bool>();
    await askForWakeUpTime();
    completer = Completer<bool>();
    String answer = await turnOffAllLights();
    await flutterTts.speak(answer);
    flutterTts.setCompletionHandler(() {
      print("completed light speaking");
      completer.complete(true);
    });
    await completer.future;
    await askForSleepPlaylist();
  }

  bool checkIfAnswerIsYes(String answer) {
    if (yesTriggerWords.any((element) => answer.contains(element))) {
      print("answer is yes");
      return true;
    }
    print("answer is not yes");
    return false;
  }

  Future<String> listenForSpeech(Duration duration) async {
    // Check if the device supports speech recognition
    bool isAvailable = await _speechToText.initialize();
    if (!isAvailable) {
      print("Speech recognition not available");
      return "";
    }

    // Create a completer to create a future that completes with the recognized text
    Completer<String> completer = Completer<String>();
    print("Start listening");
    // Start listening for speech for the specified duration
    Timer timer = Timer(duration, () async {
      print("timer stop");
      await _speechToText.stop();
    });
    await _speechToText.listen(
      partialResults: false,
      onResult: (result) async {
        lastWords = result.recognizedWords;
        print("Speech recognition result: ${result.recognizedWords}");
        timer.cancel();
        completer.complete(result.recognizedWords);
        await _speechToText.stop();
      },
      listenFor: duration,
    );

    // Wait for the future to complete and return the recognized text
    try {
      String recognizedText = await completer.future;
      return recognizedText;
    } catch (e) {
      print("Error: $e");
      timer.cancel();
      return "";
    } finally {
      timer.cancel();
    }
  }
}
