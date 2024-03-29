import 'package:luna/StateMachine/idle_service.dart';
import 'package:luna/StateMachine/state_machine.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna/UseCases/EventPlanning/event_planning_use_case.dart';
import 'package:luna/UseCases/good_morning_use_case.dart';
import 'package:luna/UseCases/good_night_use_case.dart';
import 'package:luna/UseCases/news/news_use_case.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mockito/annotations.dart';

import 'state_machine_test.mocks.dart';

@GenerateMocks([GoodNightUseCase, GoodMorningUseCase, EventPlanningUseCase, NewsUseCase])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  Map<String, Object> values = <String, Object>{
    'hours_key': 0,
    'minutes_key': 0,
  };
  SharedPreferences.setMockInitialValues(values);

  group('State Machine Transitions', () {
    test('State Machine should be initialized and in idle state', () {
      final sm = StateMachine();
      sm.start();
      expect(sm.getCurrentState(), StateMachine.idleState);
    });
    test('State Machine should transition to good morning state', () {
      final sm = StateMachine();
      sm.goodMorningUseCase = MockGoodMorningUseCase();
      sm.start();
      expect(sm.getCurrentState(), StateMachine.idleState);
      sm.transitionToGoodMorning("good morning");
      expect(sm.getCurrentState(), StateMachine.idleState);
    });
    test('State Machine should transition to event planning state', () {
      final sm = StateMachine();
      sm.eventPlanningUseCase = MockEventPlanningUseCase();
      sm.start();
      expect(sm.getCurrentState(), StateMachine.idleState);
      sm.transitionToEventPlanning("events");
      expect(sm.getCurrentState(), StateMachine.idleState);
    });
    test('State Machine should transition to news state', () {
      final sm = StateMachine();
      sm.newsUseCase = MockNewsUseCase();
      sm.start();
      expect(sm.getCurrentState(), StateMachine.idleState);
      sm.transitionToNews("news");
      expect(sm.getCurrentState(), StateMachine.idleState);
    });
    test('State Machine should transition to good night state', () {
      final sm = StateMachine();
      sm.goodNightUseCase = MockGoodNightUseCase();
      sm.start();
      expect(sm.getCurrentState(), StateMachine.idleState);
      sm.transitionToGoodNight("good night");
      expect(sm.getCurrentState(), StateMachine.idleState); //back to idle after good night
    });
    test('State Machine should transition to idle state', () {
      final sm = StateMachine();
      sm.start();
      expect(sm.getCurrentState(), StateMachine.idleState);
      sm.transitionToIdle();
      expect(sm.getCurrentState(), StateMachine.idleState);
    });
    test('idle state transition checks', () {
      final sm = StateMachine();
      sm.start();
      expect(sm.getCurrentState(), StateMachine.idleState);
      sm.runIdleState();
      expect(sm.getCurrentState(), StateMachine.idleState); //still idle, no incoming triggers
    });
    test('controller state machine call', () {
      final controller = Controller();
      controller.start();
      expect(controller.getCurrentState(), StateMachine.idleState);
    });
    test('state machine update input string', () {
      final sm = StateMachine();
      sm.start();
      expect(sm.getCurrentState(), StateMachine.idleState);
      sm.useCaseCheck.goodMorningTriggerWords = ["good morning"]; // mock the trigger words
      sm.useCaseCheck.eventPlanningTriggerWords = ["events"];
      sm.useCaseCheck.goodNightTriggerWords = ["good night"];
      sm.update("luna");
      expect(sm.getCurrentState(), StateMachine.idleState);
    });
    test('controller update input string', () {
      final controller = Controller();
      controller.start();
      expect(controller.getCurrentState(), StateMachine.idleState);
      controller.update("luna");
      expect(controller.getCurrentState(), StateMachine.idleState);
    });
    test('State Machine check leads to transition to good morning state', () {
      final sm = StateMachine();
      sm.goodMorningUseCase = MockGoodMorningUseCase();
      sm.start();
      expect(sm.getCurrentState(), StateMachine.idleState);
      sm.update("good morning");
      expect(sm.getCurrentState(), StateMachine.idleState);
    });
  });
  group('State Machine Use Case Checks', () {
    test('use case check service creation', () {
      final useCaseCheck = UseCaseCheck();
      expect(useCaseCheck.activate, 0);
      expect(useCaseCheck.triggerWord, "");
    });
    test('positive use case good morning check', () {
      final useCaseCheck = UseCaseCheck();
      bool detected = useCaseCheck.goodMorningCheck("good morning");
      expect(detected, true);
      expect(useCaseCheck.triggerWord, "good morning");
    });
    test('positive, more complex use case good morning check', () {
      final useCaseCheck = UseCaseCheck();
      bool detected = useCaseCheck.goodMorningCheck("hey good morning luna");
      expect(detected, true);
      expect(useCaseCheck.triggerWord, "hey good morning luna");
    });
    test('negative use case good morning check', () {
      final useCaseCheck = UseCaseCheck();
      bool detected = useCaseCheck.goodMorningCheck("good night");
      expect(detected, false);
      expect(useCaseCheck.triggerWord, "");
    });
    test('positive use case event planning check', () {
      final useCaseCheck = UseCaseCheck();
      useCaseCheck.eventPlanningTriggerWords = ["scheduling", "events"];
      bool detected = useCaseCheck.eventPlanningCheck("scheduling");
      expect(detected, true);
      expect(useCaseCheck.triggerWord, "scheduling");
    });
    test('positive, more complex use case event planning check', () {
      final useCaseCheck = UseCaseCheck();
      bool detected = useCaseCheck.eventPlanningCheck("hey luna events");
      expect(detected, true);
      expect(useCaseCheck.triggerWord, "hey luna events");
    });
    test('negative use case event planning check', () {
      final useCaseCheck = UseCaseCheck();
      bool detected = useCaseCheck.eventPlanningCheck("good night");
      expect(detected, false);
      expect(useCaseCheck.triggerWord, "");
    });
    test('positive use case news check', () {
      final useCaseCheck = UseCaseCheck();
      bool detected = useCaseCheck.newsCheck("news");
      expect(detected, true);
      expect(useCaseCheck.triggerWord, "news");
    });
    test('positive, more complex use case news check', () {
      final useCaseCheck = UseCaseCheck();
      bool detected = useCaseCheck.newsCheck("hey luna news");
      expect(detected, true);
      expect(useCaseCheck.triggerWord, "news");
    });
    test('negative use case news check', () {
      final useCaseCheck = UseCaseCheck();
      bool detected = useCaseCheck.newsCheck("good night");
      expect(detected, false);
      expect(useCaseCheck.triggerWord, "");
    });
    test('positive use case good night check', () {
      final useCaseCheck = UseCaseCheck();
      useCaseCheck.goodNightTriggerWords = ["good night", "night", "light", "lights", "turn off", "music", "playlist", "spotify", "alarm", "wake up", "wake me up"];
      bool detected = useCaseCheck.goodNightCheck("good night");
      expect(detected, true);
      expect(useCaseCheck.triggerWord, "good night");
    });
    test('positive, more complex use case good night check', () {
      final useCaseCheck = UseCaseCheck();
      bool detected = useCaseCheck.goodNightCheck("hey luna good night");
      expect(detected, true);
      expect(useCaseCheck.triggerWord, "hey luna good night");
    });
    test('negative use case good night check', () {
      final useCaseCheck = UseCaseCheck();
      bool detected = useCaseCheck.goodNightCheck("good morning");
      expect(detected, false);
      expect(useCaseCheck.triggerWord, "");
    });
    test('monitor use case selection good morning', () {
      final useCaseCheck = UseCaseCheck();
      useCaseCheck.monitor("good morning");
      expect(useCaseCheck.activate, 1);
      expect(useCaseCheck.triggerWord, "good morning");
    });
    test('monitor use case selection event planning', () {
      final useCaseCheck = UseCaseCheck();
      useCaseCheck.monitor("events");
      expect(useCaseCheck.activate, 2);
      expect(useCaseCheck.triggerWord, "events");
    });
    test('monitor use case selection news', () {
      final useCaseCheck = UseCaseCheck();
      useCaseCheck.monitor("news");
      expect(useCaseCheck.activate, 3);
      expect(useCaseCheck.triggerWord, "news");
    });
    test('monitor use case selection good night', () {
      final useCaseCheck = UseCaseCheck();
      useCaseCheck.monitor("good night");
      expect(useCaseCheck.activate, 4);
      expect(useCaseCheck.triggerWord, "good night");
    });
    test('monitor use case selection no match', () {
      final useCaseCheck = UseCaseCheck();
      useCaseCheck.monitor("good");
      expect(useCaseCheck.activate, 0);
      expect(useCaseCheck.triggerWord, "");
    });
    test('monitor use case selection more complex good morning match', () {
      final useCaseCheck = UseCaseCheck();
      useCaseCheck.monitor("good morning luna");
      expect(useCaseCheck.activate, 1);
      expect(useCaseCheck.triggerWord, "good morning luna");
    });
  });
}
