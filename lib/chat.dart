import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:luna/Services/Alarm/alarm_service.dart';
import 'package:luna/Services/location_service.dart';
import 'package:luna/Services/SmartHome/smart_home_service.dart';
import 'package:luna/Services/SmartHome/bridge_model.dart';
import 'package:luna/Services/notification_service.dart';
import 'package:luna/UseCases/good_night_use_case.dart';
import 'package:luna/Services/Calendar/calendar_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatPage extends StatefulWidget {
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  FlutterTts flutterTts = FlutterTts();
  bool recording = false;
  String user = "";
  String ip = "";
  Position? _currentPosition;

  BridgeModel userModel = BridgeModel();
  loadPreferences() {
    user = Provider.of<BridgeModel>(context, listen: false).user;
    ip = Provider.of<BridgeModel>(context, listen: false).ip;
    print(ip);
    print(user);
  }

  void _getCurrentLocation() async {
    try {
      // check permisisons
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        // permission has not been granted, request permission
        final permissionStatus = await Geolocator.requestPermission();
        if (permissionStatus != LocationPermission.whileInUse &&
            permissionStatus != LocationPermission.always) {
          return;
        }
      }
      // get current location
      final position = await LocationService.instance.getCurrentLocation();
      setState(() {
        _currentPosition = position;
        print("current position: $_currentPosition");
        print("latitude: ${_currentPosition!.latitude}");
        print("longitude: ${_currentPosition!.longitude}");
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    loadPreferences();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    loadPreferences();
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
              onPressed: () async {
                stopAlarm();
              },
              child: Text("Stop Alarm DEBUG")),
          ElevatedButton(
              onPressed: () async {
                setAlarmByDateTime(DateTime.now().add(Duration(seconds: 10)));
              },
              child: Text("Test Alarm DEBUG")),
          ElevatedButton(
              onPressed: () async {
                GoodNightUseCase.instance.execute("good night");
              },
              child: Text("Test Good Night Use Case DEBUG")),
          ElevatedButton(
              onPressed: () async {
                _getCurrentLocation();
              },
              child: Text("Get Location DEBUG")),

          ElevatedButton(
              onPressed: () async {
                final calendars = await getUpcomingEventsWithDetails();
                print("events::");
                print(calendars);
              },
              child: Text("Get Calendar DEBUG")),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: FloatingActionButton(
              onPressed: () {
                recording = !recording;
              },
              child: Icon(Icons.mic),
            ),
          ),
        ],
      ),
    ));
  }
}
