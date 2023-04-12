import 'package:statemachine/statemachine.dart';
import '../UseCases/good_night_use_case.dart';
import 'idle_service.dart';

class Controller {
  static StateMachine machine = StateMachine();

  State<String>? getCurrentState() {
    // return current state of the state machine
    return machine.getCurrentState();
  }

  void start() {
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
    GoodNightUseCase.instance.execute("good night");
    transitionToIdle();
    //goodNightState.onFuture(GoodNightUseCase.instance.execute("good night"), (value) => idleState.enter());
  }

  State<String>? getCurrentState() {
    // return current state
    return machine.current;
  }

  void runIdleState() {
    // check for use cases and transition to appropriate state
    // someState.onStream(element.onClick, (value) => anotherState.enter());
    // idleState.onStream(value.activate, (value) => transitionToGoodNight());
    final useCaseCheck = UseCaseCheck();
    useCaseCheck.listen((value) {
      int state = value.activate;
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
    });
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
    goodNightState.onEntry(() => print('entering good night state'));
    goodNightState.onExit(() => print('leaving good night state'));

  /*
    final goodMorningCheck = GoodMorningCheck();
    final eventPlanningCheck = EventPlanningCheck();
    final newsCheck = NewsCheck();
    final goodNightCheck = GoodNightCheck();
    idleState.onStream(goodMorningCheck, (value) => transitionToGoodMorning());
    idleState.onStream(eventPlanningCheck, (value) => transitionToEventPlanning());
    idleState.onStream(newsCheck, (value) => transitionToNews());
    idleState.onStream(goodNightCheck, (value) => transitionToGoodNight());
*/

    machine.start();
  }

}