import 'dart:io';
import 'package:alarm/alarm.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// The purpose of this class is to show a notification to the user
/// The user can tap the notification to open directly the app.
class NotificationService {
  NotificationService._();

  /// Singleton instance of the [NotificationService] class.
  static final instance = NotificationService._();

  final FlutterLocalNotificationsPlugin localNotif =
      FlutterLocalNotificationsPlugin();

  /// Adds configuration for local notifications and initialize service.
  Future<void> init() async {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await localNotif.initialize(initializationSettings);
    tz.initializeTimeZones();
  }

  /// Shows notification permission request.
  Future<bool> requestPermission() async {
    late bool? result;

    if (Platform.isAndroid) {
      result = await localNotif
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestPermission();
    } else {
      result = await localNotif
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
    return result ?? false;
  }

  /// Returns the next instance of the given [time].
  tz.TZDateTime nextInstanceOfTime(Time time) {
    final DateTime now = DateTime.now();

    DateTime scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
      time.second,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return tz.TZDateTime.from(scheduledDate, tz.local);
  }

  /// Schedules daily notification at the given [dateTime].
  Future<void> scheduleAlarmNotif({
    required int id,
    required Time dateTime,
    required String title,
    required String body,
  }) async {
    const iOSPlatformChannelSpecifics = DarwinNotificationDetails(
      presentSound: false,
      presentAlert: false,
      presentBadge: false,
    );

    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'Luna',
      'Luna_Plugin',
      channelDescription: 'Luna plugin',
      importance: Importance.max,
      priority: Priority.max,
      enableLights: true,
      playSound: false,
    );

    const platformChannelSpecifics = NotificationDetails(
      iOS: iOSPlatformChannelSpecifics,
      android: androidPlatformChannelSpecifics,
    );

    final zdt = nextInstanceOfTime(
      Time(
        dateTime.hour,
        dateTime.minute,
        dateTime.second,
      ),
    );

    final hasPermission = await requestPermission();
    if (!hasPermission) {
      alarmPrint('Notification permission not granted');
      return;
    }

    try {
      await localNotif.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(zdt.toUtc(), tz.UTC),
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        // daily alarm
        matchDateTimeComponents: DateTimeComponents.time,
      );
      alarmPrint('Notification with id $id scheduled successfuly at $zdt');
    } catch (e) {
      alarmPrint('Schedule notification with id $id error: $e');
    }
  }

  /// Cancels notification with the given [id].
  Future<void> cancel(int id) async {
    await localNotif.cancel(id);
    alarmPrint('Notification with id $id canceled');
  }
}
