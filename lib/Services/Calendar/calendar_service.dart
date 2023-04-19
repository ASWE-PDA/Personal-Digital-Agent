import "package:device_calendar/device_calendar.dart";
import "package:timezone/data/latest.dart" as tzdata;
import "package:timezone/timezone.dart" as tz;


class CalendarService {
  final DeviceCalendarPlugin calendarPlugin;

  CalendarService({DeviceCalendarPlugin? calendarPlugin})
    : calendarPlugin = calendarPlugin ?? DeviceCalendarPlugin();

  Future<String?> getCalendarId() async {
    final calendarPlugin = await requestCalendarPermissions(this.calendarPlugin);
    if (calendarPlugin == null) return null;

    final calendarListResult = await calendarPlugin.retrieveCalendars();
    String? calendarId;
    for (var calendar in calendarListResult.data!) {
      final defaultCalendar = calendar.isDefault!;
      if (defaultCalendar) {
        calendarId = calendar.id!;
        return calendarId;
      }
    }
    return null;
  }

  Future<DeviceCalendarPlugin?> requestCalendarPermissions(
      DeviceCalendarPlugin calendarPlugin) async {
    try {
      var permissionsGranted = await calendarPlugin.hasPermissions();
      if (permissionsGranted.data == null) return null;

      if (permissionsGranted.isSuccess && !permissionsGranted.data!) {
        permissionsGranted = await calendarPlugin.requestPermissions();
        if (!permissionsGranted.isSuccess || !permissionsGranted.data!) return null;
      }
      return calendarPlugin;
    } catch (e) {
      return null;
    }
  }

  Future<List<Event>> getUpcomingEvents() async {
    final calendarPlugin = await requestCalendarPermissions(this.calendarPlugin);
    if (calendarPlugin == null) return [];
    
    String? calendarId = await getCalendarId();
    
    if (calendarId != null) {
      final now = DateTime.now();
      final start = DateTime(now.year, now.month, now.day, 0).toUtc();
      final end = DateTime(now.year, now.month, now.day, 24).toUtc();
      
      final eventsResult = await calendarPlugin.retrieveEvents(
          calendarId, RetrieveEventsParams(startDate: start, endDate: end));
      return eventsResult.data ?? [];
    } else {
      return [];
    }
  }


  Future<void> createCalendarEvent(DateTime date, String name, int durationInMin) async {
    // Get the default calendar
    final calendarPlugin = await requestCalendarPermissions(this.calendarPlugin);
    if (calendarPlugin == null) return;
    
    String? calendarId = await getCalendarId();

    // Create the event
    tzdata.initializeTimeZones();
    final location = tz.getLocation("Europe/Berlin");
    final start = tz.TZDateTime.from(date, location);
    final end = tz.TZDateTime.from(date.add(Duration(minutes: durationInMin)), location);
    final event = Event(calendarId, title: name, start: start, end: end);

    final createResult = await calendarPlugin.createOrUpdateEvent(event);

    if (createResult == null) {
      return;
    }
    if (createResult.isSuccess && createResult.data != null) {
    } else {
    }
  }
}
