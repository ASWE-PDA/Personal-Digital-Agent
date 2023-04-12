import 'package:statemachine/statemachine.dart';
import '../UseCases/good_night_use_case.dart';
import 'idle_service.dart';

/**
 * Controller for the Personal Digital Agent.
 * Contains and runs the state machine to automatically detect and activate the use cases.
 * Parameters:
 * - machine: the state machine
 * Methods:
 * - getCurrentState: return current state of the state machine
 * - start: start state machine. machine automatically runs use case checks and transitions to appropriate state
 */
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

/**
 * State machine for the Personal Digital Agent.
 * Parameters:
 *  - machine: the state machine
 * - idleState: the idle state
 * - goodMorningState: the good morning state
 * - eventPlanningState: the event planning state
 * - newsState: the news state
 * - goodNightState: the good night state
 * Methods:
 * - transitionToIdle: leave current state and transition to idle state
 * - transitionToGoodMorning: leave current state and transition to good morning state
 * - transitionToEventPlanning: leave current state and transition to event planning state
 * - transitionToNews: leave current state and transition to news state
 * - transitionToGoodNight: leave current state and transition to good night state
 * - getCurrentState: return current state
 * - runIdleState: check for use cases and transition to appropriate state
 * - start: start state machine. machine automatically runs use case checks and transitions to appropriate state
 */
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

  void transitionToGoodMorning(String trigger) {
    // leave current state and transition to good morning state
    print("transitioning to good morning state");
    goodMorningState.enter();
    // TODO link to good morning state main and transition back to idle afterwards
  }

  void transitionToEventPlanning(String trigger) {
    // leave current state and transition to event planning state
    print("transitioning to event planning state");
    eventPlanningState.enter();
    // TODO link to event planning state main and transition back to idle afterwards
  }

  void transitionToNews(String trigger) {
    // leave current state and transition to news state
    print("transitioning to news state");
    newsState.enter();
    // TODO link to news state main and transition back to idle afterwards
  }

  void transitionToGoodNight(String trigger) {
    // leave current state and transition to good night state
    print("transitioning to good night state");
    goodNightState.enter();
    GoodNightUseCase.instance.execute(trigger);
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
            transitionToGoodMorning(value.triggerWord);
            break;
          case 2:
            transitionToEventPlanning(value.triggerWord);
            break;
          case 3:
            transitionToNews(value.triggerWord);
            break;
          case 4:
            transitionToGoodNight(value.triggerWord);
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
    goodMorningState.onEntry(() => print('entering good morning state'));
    goodMorningState.onExit(() => print('leaving good morning state'));
    eventPlanningState.onEntry(() => print('entering event planning state'));
    eventPlanningState.onExit(() => print('leaving event planning state'));
    newsState.onEntry(() => print('entering news state'));
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