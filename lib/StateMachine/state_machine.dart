import 'package:luna/UseCases/good_morning_use_case.dart';
import 'package:luna/UseCases/EventPlanning/event_planning_use_case.dart';
import 'package:luna/UseCases/news/news_use_case.dart';
import 'package:statemachine/statemachine.dart';
import '../UseCases/good_night_use_case.dart';
import '../UseCases/use_case.dart';
import 'idle_service.dart';

/// Controller for the Personal Digital Agent.
/// Contains and runs the state [machine] to automatically detect and activate the use cases.
class Controller {
  static StateMachine machine = StateMachine();

  /// Returns the current state of the state machine.
  State<String>? getCurrentState() {
    return machine.getCurrentState();
  }

  /// Updates the state machine with the [input] and runs the idle state.
  void update(String input) {
    machine.update(input);
    machine.runIdleState();
  }

  /// Starts the state machine.
  void start() {
    machine
        .start(); // start state machine. machine automatically runs use case checks and transitions to appropriate state
  }
}

/// This class represents the state machine.
class StateMachine {
  static final machine = Machine<String>();
  final useCaseCheck = UseCaseCheck();
  static final idleState = machine.newState('idle'); // start state
  static final goodMorningState =
      machine.newState('good_morning'); // state for good morning use case
  static final eventPlanningState =
      machine.newState('event_planning'); // state for event planning use case
  static final newsState = machine.newState('news'); // state for news use case
  static final goodNightState =
      machine.newState('good_night'); // state for good night use case

  static UseCase _goodMorningUseCase = GoodMorningUseCase.instance;
  set goodMorningUseCase(UseCase instance) {
    _goodMorningUseCase = instance;
  }

  static UseCase _goodNightUseCase = GoodNightUseCase.instance;
  set goodNightUseCase(UseCase instance) {
    _goodNightUseCase = instance;
  }

  static UseCase _newsUseCase = NewsUseCase.instance;
  set newsUseCase(UseCase instance) {
    _newsUseCase = instance;
  }

  static UseCase _eventPlanningUseCase = EventPlanningUseCase.instance;
  set eventPlanningUseCase(UseCase instance) {
    _eventPlanningUseCase = instance;
  }

  /// Leaves the current state and transitions to the idle state.
  void transitionToIdle() {
    idleState.enter();
  }

  /// Transitions to the good morning state with the [trigger] words.
  void transitionToGoodMorning(String trigger) {
    goodMorningState.enter();
    _goodMorningUseCase.execute(trigger);
    transitionToIdle();
  }

  /// Transitions to the event planning state with the [trigger] words.
  void transitionToEventPlanning(String trigger) {
    eventPlanningState.enter();
    _eventPlanningUseCase.execute(trigger);
    transitionToIdle();
  }

  /// Transitions to the news state with the [trigger] words.
  void transitionToNews(String trigger) {
    newsState.enter();
    _newsUseCase.execute(trigger);
    transitionToIdle();
  }

  /// Transitions to the good night state with the [trigger] words.
  void transitionToGoodNight(String trigger) {
    goodNightState.enter();
    _goodNightUseCase.execute(trigger);
    transitionToIdle();
  }

  /// Returns the current state of the state machine.
  State<String>? getCurrentState() {
    return machine.current;
  }

  /// Runs the idle state. Checks for use cases and transitions to appropriate state.
  void runIdleState() {
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
      }
    }
  }

  /// Starts the state machine.
  void start() {
    // define transitions
    idleState.onEntry(() => runIdleState());
    idleState.onExit(() => {});
    goodMorningState.onEntry(() => {});
    goodMorningState.onExit(() => {});
    eventPlanningState.onEntry(() => {});
    eventPlanningState.onExit(() => {});
    newsState.onEntry(() => {});
    newsState.onExit(() => {});
    goodNightState.onEntry(() => {});
    goodNightState.onExit(() => {});
    machine.start();
  }

  /// Updates the state machine with the [input].
  void update(String input) {
    useCaseCheck.monitor(input);
  }
}
