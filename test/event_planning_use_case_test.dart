import 'package:flutter_test/flutter_test.dart';
import 'package:luna/UseCases/EventPlanning/event_planning_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:luna/Services/Calendar/calendar_service.dart';
import 'package:luna/Services/Movies/movie_service.dart';

import 'event_planning_use_case_test.mocks.dart';

@GenerateMocks([CalendarService, MovieService])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('EventPlanningUseCase', () {
    test('getAllTriggerWords should return all trigger words', () {
      final eventPlanningUseCase = EventPlanningUseCase.instance;
      final allTriggerWords = eventPlanningUseCase.getAllTriggerWords();

      expect(allTriggerWords, [
        ...eventPlanningUseCase.schedulingTriggerWords,
        ...eventPlanningUseCase.calendarTriggerWords,
        ...eventPlanningUseCase.movieTriggerWords,
      ]);
    });

    test('getTimeFromHoursMinutes should return the correct time', () {
      final eventPlanningUseCase = EventPlanningUseCase.instance;
      expect(eventPlanningUseCase.getTimeFromHoursMinutes(1, 0), '1 a.m');
      expect(eventPlanningUseCase.getTimeFromHoursMinutes(0, 0), '0 a.m');
      expect(eventPlanningUseCase.getTimeFromHoursMinutes(12, 0), '12 p.m');
      expect(eventPlanningUseCase.getTimeFromHoursMinutes(13, 0), '1 p.m');
      expect(eventPlanningUseCase.getTimeFromHoursMinutes(23, 0), '11 p.m');
      expect(eventPlanningUseCase.getTimeFromHoursMinutes(1, 30), '1:30 a.m');
      expect(eventPlanningUseCase.getTimeFromHoursMinutes(23, 30), '11:30 p.m');
    });

    test('parseSpokenTime should return the correct DateTime', () {
      final eventPlanningUseCase = EventPlanningUseCase.instance;
      expect(eventPlanningUseCase.parseSpokenTime('1 am')!.hour, 1);
      expect(eventPlanningUseCase.parseSpokenTime('12 am')!.hour, 0);
      expect(eventPlanningUseCase.parseSpokenTime('12 pm')!.hour, 12);
      expect(eventPlanningUseCase.parseSpokenTime('1 pm')!.hour, 13);
      expect(eventPlanningUseCase.parseSpokenTime('11 pm')!.hour, 23);
      expect(eventPlanningUseCase.parseSpokenTime('1:30 am')!.minute, 30);
      expect(eventPlanningUseCase.parseSpokenTime('11:30 pm')!.minute, 30);
      expect(eventPlanningUseCase.parseSpokenTime('invalid time'), null);
    });
  });
}
