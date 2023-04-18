import "package:alarm/alarm.dart";

setAlarmByDateTime(DateTime dateTime) async {
  final alarmSettings = AlarmSettings(
    id: 1,
    dateTime: dateTime,
    assetAudioPath: "assets/audio/audience_of_one.mp3",
    loopAudio: false,
    vibrate: true,
    fadeDuration: 3.0,
    notificationTitle: "Good Morning",
    notificationBody: "I wish you a wonderful morning!",
    enableNotificationOnKill: true,
  );

  await Alarm.set(alarmSettings: alarmSettings);
}

stopAlarm() async {
  await Alarm.stop(1);
}
