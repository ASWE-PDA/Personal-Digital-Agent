import 'dart:async';

/**
 * This class is used to check if a use case is triggered.
 * Parameters:
 * - activate: 1 if good morning use case is triggered, 2 if event planning use case is triggered, 3 if news use case is triggered, 4 if good night use case is triggered, 0 if no use case is triggered
 * - triggerWord: contains trigger words if a use case is triggered, usable by the use case
 * Methods:
 * - goodMorningCheck: checks if good morning use case is triggered
 * - eventPlanningCheck: checks if event planning use case is triggered
 * - newsCheck: checks if news use case is triggered
 * - goodNightCheck: checks if good night use case is triggered
 * - monitor: monitors the use case checks and updates the activate parameter accordingly
 */
class UseCaseCheck extends StreamView<UseCaseCheck> {
  UseCaseCheck._(this._controller) : super(_controller.stream);
  factory UseCaseCheck() => UseCaseCheck._(StreamController());

  final StreamController<UseCaseCheck> _controller;

  Future<void> close() => _controller.close();

  int _activate = 0;
  int get activate => _activate;

  String _triggerWord = "";
  String get triggerWord => _triggerWord;

  bool goodMorningCheck(List<String> input){
    String trigger = "";
    bool detected = false;

    List<String> goodMorningTriggerWords = ["good morning", "morning", "wake up", "good morning luna"];
    
    if (goodMorningTriggerWords.any((element) => _triggerWord.contains(element))) {
      trigger = "good morning";
      detected = true;
    }
    _triggerWord = trigger;

    // return true if good morning use case is detected
    return detected;
  }

  bool eventPlanningCheck(List<String> input){
    String trigger = "";
    bool detected = false;

    List<String> eventPlanningTriggerWords = ["event", "events", "planning", "plan", "calendar", "schedule", "scheduling", "schedules", "agenda"];
    
    if (eventPlanningTriggerWords.any((element) => input.contains(element))) {
      trigger = "event";
      detected = true;
    }
    _triggerWord = trigger;

    // return true if event planning use case is detected
    return detected;
  }

  bool newsCheck(List<String> input){
    String trigger = "";
    bool detected = false;

    List<String> newsTriggerWords = ["news", "headline", "headlines", "today's news", "today's headlines"];

    if (newsTriggerWords.any((element) => input.contains(element))) {
      trigger = "news";
      detected = true;
    }
    _triggerWord = trigger;
    
    // return true if news use case is detected
    return detected;
  }

  bool goodNightCheck(List<String> input){
    String trigger = "";
    bool detected = false;

    List<String> goodNightTriggerWords = ["good night", "night"];
    List<String> lightTriggerWords = ["light", "lights", "turn off"];
    List<String> sleepPlaylistTriggerWords = ["music", "playlist", "spotify"];
    List<String> alarmTriggerWords = ["alarm", "wake up", "wake me up"];

    if (goodNightTriggerWords.any((element) => input.contains(element))) {
      trigger = "good night";
      detected = true;
    } else if (lightTriggerWords.any((element) => trigger.contains(element))) {
      trigger = "light";
      detected = true;
    } else if (sleepPlaylistTriggerWords.any((element) => trigger.contains(element))) {
      trigger = "music";
      detected = true;
    } else if (alarmTriggerWords.any((element) => trigger.contains(element))) {
      trigger = "alarm";
      detected = true;
    }
    _triggerWord = trigger;  // contains trigger words if good night use case is detected
    return detected;
  }

  void monitor(List<String> input) {
    if (goodMorningCheck(input)) {
        _activate = 1;
      }
      if (eventPlanningCheck(input)) {
        _activate = 2;
      }
      if (newsCheck(input)) {
        _activate = 3;
      }
      if (goodNightCheck(input)) {
        _activate = 4;
      }
    _activate = 0;
    
    _controller.add(this);
  }
}
