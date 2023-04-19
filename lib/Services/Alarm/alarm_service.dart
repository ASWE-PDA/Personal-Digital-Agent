import 'package:alarm/alarm.dart';

/// Sets an alarm for the given [dateTime].
setAlarmByDateTime(DateTime dateTime) async {
  // define the alarm settings
  final alarmSettings = AlarmSettings(
    id: 1,
    dateTime: dateTime,
    assetAudioPath: 'assets/audio/audience_of_one.mp3',
    loopAudio: false,
    vibrate: true,
    fadeDuration: 3.0,
    notificationTitle: 'Good Morning"',
    notificationBody: 'I wish you a wonderful morning!',
    enableNotificationOnKill: true,
  );
  // set the alarm
  await Alarm.set(alarmSettings: alarmSettings);
}

/// Stops the alarm with the given.
Future<void> stopAlarm() async {
  await Alarm.stop(1);
}
