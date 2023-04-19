import 'package:luna/UseCases/good_morning_use_case.dart';
import 'package:luna/UseCases/good_night_use_case.dart';
import 'package:luna/UseCases/EventPlanning/event_planning_use_case.dart';

/// This class is used to check if a use case is triggered. Based on the
/// [triggerWord], a use case is executed.
/// There are 4 use cases: good morning, event planning, news and good night.
/// Those use cases are checked in the [monitor] method and the [activate]
/// parameter is updated accordingly.
/// For every use case is a separate method to check if the use case is triggered:
/// [goodMorningCheck], [eventPlanningCheck], [newsCheck] and [goodNightCheck].
class UseCaseCheck {
  int _activate = 0;
  int get activate => _activate;

  String _triggerWord = "";
  String get triggerWord => _triggerWord;

  /// Getter for the trigger words of the good morning use case.
  static List<String> _goodMorningTriggerWords =
      GoodMorningUseCase.instance.getAllTriggerWords();

  /// Detter for the trigger words of the good morning use case.
  set goodMorningTriggerWords(List<String> goodMorningTriggerWords) {
    _goodMorningTriggerWords = goodMorningTriggerWords;
  }

  /// Getter for the trigger words of the good night use case.
  static List<String> _goodNightTriggerWords =
      GoodNightUseCase.instance.getAllTriggerWords();

  /// Setter for the trigger words of the good night use case.
  set goodNightTriggerWords(List<String> goodNightTriggerWords) {
    _goodNightTriggerWords = goodNightTriggerWords;
  }

  /// Getter for the trigger words of the event planning use case.
  static List<String> _eventPlanningTriggerWords =
      EventPlanningUseCase.instance.getAllTriggerWords();

  /// Setter for the trigger words of the event planning use case.
  set eventPlanningTriggerWords(List<String> goodNightTriggerWords) {
    _eventPlanningTriggerWords = goodNightTriggerWords;
  }

  /// Checks if the [input] contains a trigger word of the good morning use case.
  ///
  /// Returns true if the good morning use case is triggered.
  bool goodMorningCheck(String input) {
    bool detected = false;
    if (_goodMorningTriggerWords.any((element) => input.contains(element))) {
      _triggerWord = input;
      detected = true;
    }
    return detected;
  }

  /// Checks if the [input] contains a trigger word of the good night use case.
  ///
  /// Returns true if the good night use case is triggered.
  bool goodNightCheck(String input) {
    bool detected = false;

    if (_goodNightTriggerWords.any((element) => input.contains(element))) {
      _triggerWord = input;
      detected = true;
    }
    return detected;
  }

  /// Checks if the [input] contains a trigger word of the event planning use case.
  ///
  /// Returns true if the event planning use case is triggered.
  bool eventPlanningCheck(String input) {
    bool detected = false;

    if (_eventPlanningTriggerWords.any((element) => input.contains(element))) {
      _triggerWord = input;
      detected = true;
    }
    return detected;
  }

  /// Checks if the [input] contains a trigger word of the news use case.
  ///
  /// Returns true if the news use case is triggered.
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

  /// Executes all checks and activates the use case based on the [input].
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
