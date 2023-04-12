import 'dart:async';

class UseCaseCheck extends StreamView<UseCaseCheck> {
  UseCaseCheck._(this._controller) : super(_controller.stream);
  factory UseCaseCheck() => UseCaseCheck._(StreamController());

  final StreamController<UseCaseCheck> _controller;

  Future<void> close() => _controller.close();

  int _activate = 0;
  int get activate => _activate;

  bool goodMorningCheck(){
    // TODO: implement goodMorningCheck
    // return true if good morning use case is detected
    return false;
  }

  bool eventPlanningCheck(){
    // TODO: implement eventPlanningCheck
    // return true if event planning use case is detected
    return false;
  }

  bool newsCheck(){
    // TODO: implement newsCheck
    // return true if news use case is detected
    return false;
  }

  bool goodNightCheck(){
    // TODO: implement goodNightCheck
    // return true if good night use case is detected
    return false;
  }

  void monitor() {
    if (goodMorningCheck()) {
        _activate = 1;
      }
      if (eventPlanningCheck()) {
        _activate = 2;
      }
      if (newsCheck()) {
        _activate = 3;
      }
      if (goodNightCheck()) {
        _activate = 4;
      }
    _activate = 0;
    
    _controller.add(this);
  }
}
