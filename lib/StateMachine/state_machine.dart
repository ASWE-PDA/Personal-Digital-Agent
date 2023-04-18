import "package:statemachine/statemachine.dart";
import "../UseCases/good_night_use_case.dart";
import "../UseCases/use_case.dart";
import "idle_service.dart";

/// Controller for the Personal Digital Agent.
/// Contains and runs the state [machine] to automatically detect and activate the use cases.
class Controller {
  static StateMachine machine = StateMachine();

  /// return current state of the state [machine]
  State<String>? getCurrentState() {
    return machine.getCurrentState();
  }

  /// update the state [machine] with speech [input]
  void update(String input) {
    machine.update(input);
    machine.runIdleState();
  }

  /// start the state [machine]
  void start() {
    machine
        .start();
  }
}

/// State machine for the Personal Digital Agent.
/// The states of the state [machine] are as follows:
/// - the [idleState] runs use case checks and transitions to appropriate state
/// - the [goodMorningState] runs the good morning use case
/// - the [eventPlanningState] runs the event planning use case
/// - the [newsState] runs the news use case
/// - the [goodNightState] runs the good night use case
class StateMachine {
  static final machine = Machine<String>();
  final useCaseCheck = UseCaseCheck();
  static final idleState = machine.newState("idle"); // start state
  static final goodMorningState =
      machine.newState("good_morning"); // state for good morning use case
  static final eventPlanningState =
      machine.newState("event_planning"); // state for event planning use case
  static final newsState = machine.newState("news"); // state for news use case
  static final goodNightState =
      machine.newState("good_night"); // state for good night use case
  
  //static UseCase goodMorningUseCase = TODO link good morning use case;
  //static UseCase eventPlanningUseCase = TODO link event planning use case;
  //static UseCase newsUseCase = TODO link news use case;
  static UseCase _goodNightUseCase = GoodNightUseCase.instance;

  set goodNightUseCase(UseCase instance){
    _goodNightUseCase = instance;
  }

  /// leave current state and transition to [idleState]
  void transitionToIdle() {
    print("transitioning to idle state");
    idleState.enter();
  }

  /// leave current state and transition to [goodMorningState]
  void transitionToGoodMorning(String trigger) {
    print("transitioning to good morning state");
    goodMorningState.enter();
    // TODO link to good morning state main and transition back to idle afterwards
  }

  /// leave current state and transition to [eventPlanningState]
  void transitionToEventPlanning(String trigger) {
    print("transitioning to event planning state");
    eventPlanningState.enter();
    // TODO link to event planning state main and transition back to idle afterwards
  }

  /// leave current state and transition to [newsState]
  void transitionToNews(String trigger) {
    print("transitioning to news state");
    newsState.enter();
    // TODO link to news state main and transition back to idle afterwards
  }

  /// leave current state and transition to [goodNightState]
  void transitionToGoodNight(String trigger) {
    print("transitioning to good night state");
    goodNightState.enter();
    _goodNightUseCase.execute(trigger);
    transitionToIdle();
  }

  /// return current state of the state [machine]
  State<String>? getCurrentState() {
    return machine.current;
  }

  /// check for use cases and transition to appropriate state
  void runIdleState() {
    print("entered idle state");
      int state = useCaseCheck.activate;
      if (state > 0) {
        switch (state) {
          case 1:
            transitionToGoodMorning(useCaseCheck.triggerWord);
            break;
          case 2:
            transitionToEventPlanning(useCaseCheck.triggerWord);
            break;
          case 3:
            transitionToNews(useCaseCheck.triggerWord);
            break;
          case 4:
            transitionToGoodNight(useCaseCheck.triggerWord);
            break;
          default:
            print("error: invalid state");
        }
      }
  }

  /// start the state [machine], which automatically runs use case checks in the [idleState]
  void start() {
    // define transitions
    idleState.onEntry(() => runIdleState());
    idleState.onExit(() => print("leaving idle state"));
    goodMorningState.onEntry(() => print("entering good morning state"));
    goodMorningState.onExit(() => print("leaving good morning state"));
    eventPlanningState.onEntry(() => print("entering event planning state"));
    eventPlanningState.onExit(() => print("leaving event planning state"));
    newsState.onEntry(() => print("entering news state"));
    newsState.onExit(() => print("leaving news state"));
    goodNightState.onEntry(() => print("entering good night state"));
    goodNightState.onExit(() => print("leaving good night state"));

    machine.start();
  }

  /// update state [machine] with new speech input
  void update(String input) {
    useCaseCheck.monitor(input);
  }
}
