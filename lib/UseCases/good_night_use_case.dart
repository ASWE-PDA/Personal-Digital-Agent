import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:luna/Services/Alarm/alarm_service.dart';
import 'package:luna/Services/SmartHome/bridge_model.dart';
import 'package:luna/Services/SmartHome/smart_home_service.dart';
import 'package:luna/Services/Spotify/spotify_sdk_service.dart';
import 'package:luna/UseCases/good_night_model.dart';
import 'package:luna/UseCases/use_case.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:luna/Services/notification_service.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

@pragma('vm:entry-point')
void onNotificationTap(NotificationResponse response) {
  print('notificationTap');
}

/// Use case for the Good Night feature.
class GoodNightUseCase implements UseCase {
  /// Singleton instance of [GoodNightUseCase].
  static final instance = GoodNightUseCase._();

  GoodNightUseCase._() {
    // flutterTts.setLanguage("en-US");
    //_initSpeech();
  }

  List<String> goodNightTriggerWords = ["good night", "night"];
  List<String> lightTriggerWords = ["light", "lights", "turn off"];
  List<String> sleepPlaylistTriggerWords = ["music", "playlist", "spotify"];
  List<String> alarmTriggerWords = ["alarm", "wake up", "wake me up"];
  List<String> yesTriggerWords = ["Yes", "Ja", "yes", "ja", "sure"];

  FlutterTts flutterTts = FlutterTts();
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String lastWords = '';

  BridgeModel bridgeModel = BridgeModel();
  GoodNightModel goodNightModel = GoodNightModel();
  SmartHomeService smartHomeService = SmartHomeService();
  SpotifySdkService spotifySdkService = SpotifySdkService();

  int notificationId = 2;
  String playlistId = "6X7wz4cCUBR6p68mzM7mZ4";

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
      wishGoodNight();
      return;
    } else if (lightTriggerWords.any((element) => trigger.contains(element))) {
      print("triggered light case");
      await turnOffAllLights().then(
        (value) {
          flutterTts.speak(value);
        },
      );
      return;
    } else if (sleepPlaylistTriggerWords
        .any((element) => trigger.contains(element))) {
      print("triggered sleep playlist case");
      startSleepPlayList();
      return;
    } else if (alarmTriggerWords.any((element) => trigger.contains(element))) {
      print("triggered alarm case");
      // setAlarm();
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

  /// Returns a list of all trigger words.
  List<String> getAllTriggerWords() {
    return [
      ...goodNightTriggerWords,
      ...lightTriggerWords,
      ...sleepPlaylistTriggerWords,
      ...alarmTriggerWords
    ];
  }

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
  void askForLights() async {
    flutterTts.speak("Do you want me to turn off your lights?");
    // await _startListening();

    await checkIfAnswerIsYes(lastWords);
  }

  // TODO: implement this
  Future<void> askForSleepPlaylist() async {
    await flutterTts
        .speak("Do you want me to start a sleep playlist for you?")
        .then((value) {
      print("Start listeniung");
    });
    sleep(Duration(seconds: 6));
    await _startListening(_onSpeechResult);
  }

  /// Connects to the Spotify App and starts a spotify sleeping playlist
  Future<void> startSleepPlayList() async {
    try {
      bool result = await spotifySdkService.connect();
      if (result) {
        spotifySdkService.playPlaylist(playlistId);
      }
    } catch (e) {
      print(e);
    }
  }

  // TODO: implement this
  Future<void> askForWakeUpTime() async {
    await flutterTts.speak("When do you want to wake up tomorrow?");
    sleep(Duration(seconds: 5));
    await _startListening(_onSpeechResultAlarm);

    print("test2: $lastWords");
  }

  /// Sets an alarm for a given [dateTime]
  ///
  /// Returns string that contains Lunas answer
  String setAlarm(DateTime dateTime) {
    setAlarmByDateTime(dateTime);
    return "I set your alarm to ${dateTime.hour}:${dateTime.minute} tomorrow";
  }

  /// Executes the different services of the good night use case
  Future<void> wishGoodNight() async {
    await flutterTts.speak("Good Night. Sleep Well.");
    // askForLights();
    String answer = await turnOffAllLights();
    await flutterTts.speak(answer);

    await askForWakeUpTime();
    // await askForWakeUpTime();
    await askForSleepPlaylist();

    // await startSleepPlayList();

    // askForWakeUpTime();
  }

  /// Initialize speech to text, only once
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
  }

  /// Each time to start a speech recognition session
  Future<void> _startListening(onSpeechResult) async {
    print("listening");
    lastWords = '';
    await _speechToText.listen(
        onResult: onSpeechResult,
        listenFor: Duration(seconds: 5),
        partialResults: false);
  }

  /// Manually stop the active speech recognition session
  Future<void> _stopListening() async {
    print("stopping");
    await _speechToText.stop();
  }

  bool checkIfAnswerIsYes(String answer) {
    if (yesTriggerWords.any((element) => answer.contains(element))) {
      print("answer is yes");
      return true;
    }
    print("answer is not yes");
    return false;
  }

  /// Callback that the SpeechToText plugin uses to return the recognized words
  void _onSpeechResult(SpeechRecognitionResult result) async {
    lastWords = result.recognizedWords;
    _stopListening();
    print("result: $lastWords");
    bool checkIfYes = checkIfAnswerIsYes(lastWords);
    if (checkIfYes) {
      print("Starting spotify playlist");
      await startSleepPlayList();
    }
  }

  /// Callback that the SpeechToText plugin uses to return the recognized words
  void _onSpeechResultAlarm(SpeechRecognitionResult result) async {
    lastWords = result.recognizedWords;
    _stopListening();
    print("result: $lastWords");
    bool checkIfYes = checkIfAnswerIsYes(lastWords);
    if (checkIfYes) {
      print("Starting spotify playlist");
      await startSleepPlayList();
    }
  }
}
