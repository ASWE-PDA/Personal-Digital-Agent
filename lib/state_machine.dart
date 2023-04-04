import 'package:statemachine/statemachine.dart';

class Controller {
  static StateMachine machine = StateMachine();

  State<String>? getCurrentState() {
    // return current state of the state machine
    return machine.getCurrentState();
  }

  void main() {
    // move machine.start call up to constructor?
    machine.start();  // start state machine. machine automatically runs use case checks and transitions to appropriate state

  }
}


class StateMachine {
  static final machine = Machine<String>();
  static final idleState = machine.newState('idle');                     // start state
  static final goodMorningState = machine.newState('good_morning');      // state for good morning use case
  static final eventPlanningState = machine.newState('event_planning');  // state for event planning use case
  static final newsState = machine.newState('news');                     // state for news use case
  static final goodNightState = machine.newState('good_night');          // state for good night use case

  void transitionToIdle() {
    // leave current state and transition to idle state
    print("transitioning to idle state");
    idleState.enter();
  }

  void transitionToGoodMorning() {
    // leave current state and transition to good morning state
    print("transitioning to good morning state");
    goodMorningState.enter();
  }

  void transitionToEventPlanning() {
    // leave current state and transition to event planning state
    print("transitioning to event planning state");
    eventPlanningState.enter();
  }

  void transitionToNews() {
    // leave current state and transition to news state
    print("transitioning to news state");
    newsState.enter();
  }

  void transitionToGoodNight() {
    // leave current state and transition to good night state
    print("transitioning to good night state");
    goodNightState.enter();
  }

  State<String>? getCurrentState() {
    // return current state
    return machine.current;
  }

  void runIdleState() {
    // check for use cases and transition to appropriate state
    int state = IdleStateChecks().check();
    if(state>0) {
      switch(state) {
        case 1:
          transitionToGoodMorning();
          break;
        case 2:
          transitionToEventPlanning();
          break;
        case 3:
          transitionToNews();
          break;
        case 4:
          transitionToGoodNight();
          break;
        default:
          print("error: invalid state");
      }
    }
  }

  void start() {
    // define transitions
    idleState.onEntry(() => runIdleState());
    idleState.onExit(() => print('leaving idle state'));
    goodMorningState.onEntry(() => print('entering good morning state'));     // TODO link to good morning state main
    goodMorningState.onExit(() => print('leaving good morning state'));
    eventPlanningState.onEntry(() => print('entering event planning state')); // TODO link to event planning state main
    eventPlanningState.onExit(() => print('leaving event planning state'));
    newsState.onEntry(() => print('entering news state'));                    // TODO link to news state main
    newsState.onExit(() => print('leaving news state'));
    goodNightState.onEntry(() => print('entering good night state'));         // TODO link to good night state main
    goodNightState.onExit(() => print('leaving good night state'));

    machine.start();
  }

}


class IdleStateChecks {

  bool goodMorningCheck() {
    // TODO: implement goodMorningCheck
    // return true if good morning use case is detected
    return false;
  }

  bool eventPlanningCheck() {
    // TODO: implement eventPlanningCheck
    // return true if event planning use case is detected
    return false;
  }

  bool newsCheck() {
    // TODO: implement newsCheck
    // return true if news use case is detected
    return false;
  }

  bool goodNightCheck() {
    // TODO: implement goodNightCheck
    // return true if good night use case is detected
    return false;
  }

  int check() { // TODO how do constructors work in dart?
    // check all checks, return if/which transition is needed
    if (goodMorningCheck()) {
      return 1;
    }
    if (eventPlanningCheck()) {
      return 2;
    }
    if (newsCheck()) {
      return 3;
    }
    if (goodNightCheck()) {
      return 4;
    }
  return 0;
  }
}