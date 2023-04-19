import 'package:luna/UseCases/good_morning_use_case.dart';
import 'package:luna/UseCases/good_night_use_case.dart';
import 'package:luna/UseCases/EventPlanning/event_planning_use_case.dart';

/// This class is used to check if a use case is triggered.
/// Parameters:
/// - activate: 1 if good morning use case is triggered, 2 if event planning use case is triggered, 3 if news use case is triggered, 4 if good night use case is triggered, 0 if no use case is triggered
/// - triggerWord: contains trigger words if a use case is triggered, usable by the use case
/// Methods:
/// - goodMorningCheck: checks if good morning use case is triggered
/// - eventPlanningCheck: checks if event planning use case is triggered
/// - newsCheck: checks if news use case is triggered
/// - goodNightCheck: checks if good night use case is triggered
/// - monitor: monitors the use case checks and updates the activate parameter accordingly
class UseCaseCheck {
  int _activate = 0;
  int get activate => _activate;

  String _triggerWord = "";
  String get triggerWord => _triggerWord;

  static List<String> _goodMorningTriggerWords =
      GoodMorningUseCase.instance.getAllTriggerWords();
  static List<String> _goodNightTriggerWords =
      GoodNightUseCase.instance.getAllTriggerWords();
  set goodMorningTriggerWords(List<String> goodMorningTriggerWords) {
    _goodMorningTriggerWords = goodMorningTriggerWords;
  }

  set goodNightTriggerWords(List<String> goodNightTriggerWords) {
    _goodNightTriggerWords = goodNightTriggerWords;
  }

  static List<String> _eventPlanningTriggerWords = EventPlanningUseCase.instance.getAllTriggerWords();
  set eventPlanningTriggerWords(List<String> goodNightTriggerWords) {
    _eventPlanningTriggerWords = goodNightTriggerWords;
  }

  bool goodMorningCheck(String input) {
    bool detected = false;

    if (_goodMorningTriggerWords.any((element) => input.contains(element))) {
      _triggerWord = input;
      detected = true;
    }
    return detected;
  }

  bool goodNightCheck(String input) {
    bool detected = false;

    if (_goodNightTriggerWords.any((element) => input.contains(element))) {
      _triggerWord = input;
      detected = true;
    }
    return detected;
  }

  bool eventPlanningCheck(String input) {
    bool detected = false;

    if (_eventPlanningTriggerWords.any((element) => input.contains(element))) {
      _triggerWord = input;
      detected = true;
    }
    return detected;
  }

  bool newsCheck(String input) {
    String trigger = "";
    bool detected = false;

    List<String> newsTriggerWords = [
      "news",
      "headline",
      "headlines",
      "today's news",
      "today's headlines"
    ];

    if (newsTriggerWords.any((element) => input.contains(element))) {
      trigger = "news";
      detected = true;
    }
    _triggerWord = trigger;

    // return true if news use case is detected
    return detected;
  }

  void monitor(String input) {
    print("input: $input");
    if (goodMorningCheck(input)) {
      _activate = 1;
      print("entered goodmorning check");
      return;
    } else if (eventPlanningCheck(input)) {
      _activate = 2;
      return;
    } else if (newsCheck(input)) {
      _activate = 3;
      return;
    } else if (goodNightCheck(input)) {
      _activate = 4;
    } else {
      _activate = 0;
    }
  }
}
