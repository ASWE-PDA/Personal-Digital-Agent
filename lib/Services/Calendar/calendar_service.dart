import "package:device_calendar/device_calendar.dart";
import "package:timezone/data/latest.dart" as tzdata;
import "package:timezone/timezone.dart" as tz;

Future<List<Event>> getUpcomingEvents() async {
  final calendarPlugin = await requestCalendarPermissions();
  if (calendarPlugin == null) return [];
  
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

Future<void> createCalendarEvent(DateTime date, String name, int durationInMin) async {
  // Get the default calendar
  final calendarPlugin = await requestCalendarPermissions();
  if (calendarPlugin == null) return;

  final calendarListResult = await calendarPlugin.retrieveCalendars();
  final calendarId = calendarListResult.data?.isNotEmpty ?? false ? calendarListResult.data?.first.id : null;

  if (calendarId == null) {
    print("Unable to find default calendar");
    return;
  }

  // Create the event
  tzdata.initializeTimeZones();
  final location = tz.getLocation("Europe/Berlin");
  final start = tz.TZDateTime.from(date, location);
  final end = tz.TZDateTime.from(date.add(Duration(minutes: durationInMin)), location);
  final event = Event(calendarId, title: name, start: start, end: end);

  final createResult = await calendarPlugin.createOrUpdateEvent(event);

  if (createResult == null) {
    print("Error creating event result = null");
    return;
  }
  if (createResult.isSuccess && createResult.data != null) {
    print("Event created successfully");
  } else {
    print("Error creating event");
  }
}

Future<DeviceCalendarPlugin?> requestCalendarPermissions() async{
  final calendarPlugin = DeviceCalendarPlugin();

  try {
    var permissionsGranted = await calendarPlugin.hasPermissions();
    if (permissionsGranted.data != null) {

      if (permissionsGranted.isSuccess && !permissionsGranted.data!) {
        permissionsGranted = await calendarPlugin.requestPermissions();
        if (!permissionsGranted.isSuccess || !permissionsGranted.data!) return null;
      }
    }
  }
  catch (e) { print("error in permission req ");}

  return calendarPlugin;
}