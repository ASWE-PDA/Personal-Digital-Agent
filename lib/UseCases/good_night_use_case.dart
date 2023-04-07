import 'package:luna/Services/Alarm/alarm_service.dart';
import 'package:luna/Services/SmartHome/bridge_model.dart';
import 'package:luna/Services/SmartHome/smart_home_model.dart';
import 'package:luna/Services/SmartHome/smart_home_service.dart';
import 'package:luna/UseCases/use_case.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';

class GoodNightUseCase implements UseCase {
  List<String> goodNightTriggerWords = ["good night", "night"];
  List<String> lightTriggerWords = ["light", "lights", "turn off"];
  List<String> sleepPlaylistTriggerWords = ["music", "playlist", "spotify"];
  List<String> alarmTriggerWords = ["alarm", "wake up", "wake me up"];

  FlutterTts flutterTts = FlutterTts();

  BridgeModel bridgeModel = BridgeModel();

  @override
  Map<String, dynamic> settings = {};

  GoodNightUseCase() {
    flutterTts.setLanguage("en-US");
  }

  loadPreferences() async {
    await bridgeModel.getBridgePreferences();
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

  @override
  bool checkTrigger() {
    /// check proactively if good night case should be triggered
    print("good night use case triggered");
    return true;
  }

  List<String> getAllTriggerWords() {
    return [
      ...lightTriggerWords,
      ...sleepPlaylistTriggerWords,
      ...alarmTriggerWords
    ];
  }

  void turnOffLights() async {
    await loadPreferences();
    String ip = bridgeModel.ip;
    String user = bridgeModel.user;
    print("turning off lights: $ip, $user");
    // only turn off lights if ip and user are set
    if (ip != "" && user != "") {
      turnOffAllLights(ip, user);
      flutterTts.speak("Your lights are turned off. Good Night.");
    }
    flutterTts.speak(
        "I don't know your ip address or user. Sorry I can't turn off your lights.");
  }

  void askForSleepPlaylist() {
    flutterTts.speak("Do you want me to start a sleep playlist for you?");
  }

  void startSleepPlayList() {
    print("starting sleep playlist");
    flutterTts.speak("I started your sleep playlist");
  }

  void askForWakeUpTime() {
    flutterTts.speak("When do you want to wake up tomorrow?");
  }

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
