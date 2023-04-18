import "package:luna/UseCases/Scheduling/scheduling_use_case.dart";
import "package:luna/UseCases/good_night_use_case.dart";

/// This class is used to check if a use case is triggered. 
/// It signals which use case to [activate] and contains the detected [triggerWord]s. 
class UseCaseCheck {
  int _activate = 0;  // 1 if good morning use case is triggered, 2 if event planning use case is triggered, 3 if news use case is triggered, 4 if good night use case is triggered, 0 if no use case is triggered
  int get activate => _activate;

  String _triggerWord = "";
  String get triggerWord => _triggerWord;

  static List<String> _goodNightTriggerWords = GoodNightUseCase.instance.getAllTriggerWords();
  set goodNightTriggerWords(List<String> goodNightTriggerWords) {
    _goodNightTriggerWords = goodNightTriggerWords;
  }

  static List<String> _eventPlanningTriggerWords = SchedulingUseCase.instance.getAllTriggerWords();
  set eventPlanningTriggerWords(List<String> goodNightTriggerWords) {
    _eventPlanningTriggerWords = goodNightTriggerWords;
  }

  /// checks if good morning use case is triggered
  bool goodMorningCheck(String input) {
    String trigger = "";
    bool detected = false;

    List<String> goodMorningTriggerWords = [
      "good morning",
      "morning",
      "wake up",
      "good morning luna"
    ];

    if (goodMorningTriggerWords.any((element) => input.contains(element))) {
      trigger = "good morning";
      detected = true;
    }
    _triggerWord = trigger;

    // return true if good morning use case is detected
    return detected;
  }

  /// checks if event planning use case is triggered
  bool eventPlanningCheck(String input) {
    bool detected = false;

    if (_eventPlanningTriggerWords.any((element) => input.contains(element))) {
      _triggerWord = input;
      detected = true;
    }
    return detected;
  }

  /// checks if news use case is triggered
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

  /// checks if good night use case is triggered
  bool goodNightCheck(String input) {
    bool detected = false;

    if (_goodNightTriggerWords.any((element) => input.contains(element))) {
      _triggerWord = input;
      detected = true;
    }
    return detected;
  }

  /// monitors the use case checks and updates the [activate] parameter accordingly
  void monitor(String input) {
    print("input: $input");
    if (goodMorningCheck(input)) {
      _activate = 1;
      print("entered goodmorning check");
    } else if (eventPlanningCheck(input)) {
      _activate = 2;
    } else if (newsCheck(input)) {
      _activate = 3;
    } else if (goodNightCheck(input)) {
      _activate = 4;
    } else {
      _activate = 0;
    }
  }
}
