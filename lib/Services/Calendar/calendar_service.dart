import 'package:device_calendar/device_calendar.dart';

Future<List<Event>> getUpcomingEvents() async {
  final calendarPlugin = DeviceCalendarPlugin();
  final calendarListResult = await calendarPlugin.retrieveCalendars();
  final calendarId = calendarListResult.data?.isNotEmpty ?? false ? calendarListResult.data?.first.id : null;

  if (calendarId != null) {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day).toUtc();
    final end = DateTime(now.year, now.month, now.day + 30).toUtc();

    final eventsResult = await calendarPlugin.retrieveEvents(
        calendarId, RetrieveEventsParams(startDate: start, endDate: end));
    return eventsResult?.data ?? [];
  } else {
    return [];
  }
}

Future<List<Map<String, dynamic>>> getUpcomingEventsWithDetails() async {
  final events = await getUpcomingEvents();

  return events.map((event) {
    final name = event.title;
    final date = event.start;
    return {'name': name, 'date': date};
  }).toList();
}
