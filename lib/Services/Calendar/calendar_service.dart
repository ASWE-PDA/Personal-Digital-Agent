import 'package:device_calendar/device_calendar.dart';

Future<List<Event>> getUpcomingEvents() async {
  final calendarPlugin = DeviceCalendarPlugin();

  try {
    var permissionsGranted = await calendarPlugin.hasPermissions();
    if (permissionsGranted.data != null) {

      if (permissionsGranted.isSuccess && !permissionsGranted.data!) {
        permissionsGranted = await calendarPlugin.requestPermissions();
        if (!permissionsGranted.isSuccess || !permissionsGranted.data!) return [];
      }
    }
  }
  catch (e) { print("error in permission req ");}
  
  
  
  final calendarListResult = await calendarPlugin.retrieveCalendars();
  final calendarId = calendarListResult.data?.isNotEmpty ?? false ? calendarListResult.data?.first.id : null;

  if (calendarId != null) {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day).toUtc();
    final end = DateTime(now.year, now.month, now.day + 3).toUtc();

    final eventsResult = await calendarPlugin.retrieveEvents(
        calendarId, RetrieveEventsParams(startDate: start, endDate: end));
    return eventsResult.data ?? [];
  } else {
    return [];
  }
}