import 'package:luna/Services/SmartHome/smart_home_service.dart';
import 'package:luna/UseCases/use_case.dart';

class GoodNightUseCase implements UseCase {
  List<String> lightTriggerWords = ["light", "lights", "turn off"];
  List<String> sleepPlaylistTriggerWords = ["music", "playlist", "spotify"];
  List<String> alarmTriggerWords = ["alarm", "wake up", "wake me up"];

  @override
  Map<String, dynamic> settings = {};
  SmartHomeService smartHomeService = SmartHomeService(ip: "", user: "");

  GoodNightUseCase(this.settings);

  @override
  String execute(String trigger) {
    if (lightTriggerWords.any((element) => trigger.contains(element))) {
      print("triggered light case");
      return turnOffLights();
    } else if (sleepPlaylistTriggerWords
        .any((element) => trigger.contains(element))) {
      print("triggered sleep playlist case");
      return startSleepPlayList();
    } else if (alarmTriggerWords.any((element) => trigger.contains(element))) {
      print("triggered alarm case");
      return setAlarm();
    }
    return "I don't know what you want";
  }

  @override
  void trigger() {
    /// check proactively if good night case should be triggered
    print("good night use case triggered");
  }

  List<String> getAllTriggerWords() {
    return [
      ...lightTriggerWords,
      ...sleepPlaylistTriggerWords,
      ...alarmTriggerWords
    ];
  }

  String turnOffLights() {
    String ip = settings["ip"];
    String user = settings["user"];
    print("turning off lights: $ip, $user");
    smartHomeService.turnOffAllLights(ip, user);
    return "I turned of all your lights";
  }

  String startSleepPlayList() {
    print("starting sleep playlist");
    return "I started your sleep playlist";
  }

  String setAlarm() {
    print("setting alarm");
    return "I set your alarm";
  }
}
