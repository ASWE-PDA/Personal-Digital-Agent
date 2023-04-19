import 'dart:collection';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna/Services/Calendar/calendar_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import "package:device_calendar/device_calendar.dart";
import "package:timezone/data/latest.dart" as tzdata;
import "package:timezone/timezone.dart" as tz;

import 'calendar_service_test.mocks.dart';

@GenerateMocks([DeviceCalendarPlugin])
void main() {
  final mockCalendarPlugin = MockDeviceCalendarPlugin();
  final calendarService = CalendarService(calendarPlugin: mockCalendarPlugin);

  test('getCalendarId returns right id', () async {
  final calendars = [
    Calendar(id: "1", name: "Calendar 1", isDefault: true),
    Calendar(id: "2", name: "Calendar 2"),
    Calendar(id: "3", name: "Calendar 3"),
  ];

  Result<bool> reqPerm = Result<bool>();
  reqPerm.data = true;
  // Mock hasPermissions() and requestPermissions() methods
  when(mockCalendarPlugin.hasPermissions()).thenAnswer((_) async => reqPerm);
  when(mockCalendarPlugin.requestPermissions()).thenAnswer((_) async => reqPerm);

  final calendarListResult = Result<UnmodifiableListView<Calendar>>();
  calendarListResult.data = UnmodifiableListView(calendars);
  when(mockCalendarPlugin.retrieveCalendars()).thenAnswer((_) async => calendarListResult);

  final result = await calendarService.getCalendarId();
  expect(result, equals("1"));
  });

  test('getUpcomingEvents returns a list of events for the default calendar', () async {
    final calendars = [
      Calendar(id: "1", name: "Calendar 1", isDefault: true),
      Calendar(id: "2", name: "Calendar 2"),
      Calendar(id: "3", name: "Calendar 3"),
    ];

    // Mock hasPermissions() and requestPermissions() methods
    Result<bool> reqPerm = Result<bool>();
    reqPerm.data = true;
    when(mockCalendarPlugin.hasPermissions()).thenAnswer((_) async => reqPerm);
    when(mockCalendarPlugin.requestPermissions()).thenAnswer((_) async => reqPerm);

    final calendarListResult = Result<UnmodifiableListView<Calendar>>();
    calendarListResult.data = UnmodifiableListView(calendars);
    when(mockCalendarPlugin.retrieveCalendars()).thenAnswer((_) async => calendarListResult);

    tzdata.initializeTimeZones();
    final location = tz.getLocation("Europe/Berlin");
    final now = tz.TZDateTime.from(DateTime.now(), location);
    final start = tz.TZDateTime.from(DateTime(now.year, now.month, now.day, 0).toUtc(), location);
    final end = tz.TZDateTime.from(DateTime(now.year, now.month, now.day, 24).toUtc(),location);
    
    String? calendarId = "1";
    final events = [
      Event(
        calendarId,
        eventId: 'event1',
        title: 'Event 1',
        start: start.add(Duration(hours: 1)),
        end: start.add(Duration(hours: 2)),
      ),
      Event(
        calendarId,
        eventId: 'event2',
        title: 'Event 2',
        start: start.add(Duration(hours: 3)),
        end: start.add(Duration(hours: 4)),
      ),
    ];

    Result<UnmodifiableListView<Event>> data = Result<UnmodifiableListView<Event>>();
    data.data = UnmodifiableListView(events);
    when(
      mockCalendarPlugin.retrieveEvents(
        any,
        any,
      ),
    ).thenAnswer((_) async => data);

    final result = await calendarService.getUpcomingEvents();
    expect(result, isA<List<Event>>());
    expect(result.length, 2);
    expect(result[0].title, equals('Event 1'));
    expect(result[1].title, equals('Event 2'));
  });

  test('createCalendarEvent creates an event successfully', () async {
    final calendars = [
      Calendar(id: "1", name: "Calendar 1", isDefault: true),
      Calendar(id: "2", name: "Calendar 2"),
      Calendar(id: "3", name: "Calendar 3"),
    ];

    // Mock hasPermissions() and requestPermissions() methods
    Result<bool> reqPerm = Result<bool>();
    reqPerm.data = true;
    when(mockCalendarPlugin.hasPermissions()).thenAnswer((_) async => reqPerm);
    when(mockCalendarPlugin.requestPermissions()).thenAnswer((_) async => reqPerm);

    final calendarListResult = Result<UnmodifiableListView<Calendar>>();
    calendarListResult.data = UnmodifiableListView(calendars);
    when(mockCalendarPlugin.retrieveCalendars()).thenAnswer((_) async => calendarListResult);

    final eventDate = DateTime.now().add(Duration(days: 1));
    final eventName = "Test Event";
    final eventDurationInMin = 60;

    Result<String> createOrUpdateStr = Result<String>();
    createOrUpdateStr.data = "created_event_id";
    when(mockCalendarPlugin.createOrUpdateEvent(any)).thenAnswer(
      (_) async => createOrUpdateStr,
    );

    await calendarService.createCalendarEvent(eventDate, eventName, eventDurationInMin);

    final captor = verify(mockCalendarPlugin.createOrUpdateEvent(captureAny)).captured.single as Event;

    expect(captor.title, equals(eventName));
    expect(captor.start!.toUtc(), equals(eventDate.toUtc()));
    expect(captor.end!.toUtc(), equals(eventDate.add(Duration(minutes: eventDurationInMin)).toUtc()));
    expect(captor.calendarId, equals("1"));
  });
}
