import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:luna/Services/Alarm/alarm_service.dart';
import 'package:luna/Services/location_service.dart';
import 'package:luna/Services/SmartHome/smart_home_service.dart';
import 'package:luna/Services/SmartHome/bridge_model.dart';
import 'package:luna/Services/notification_service.dart';
import 'package:luna/UseCases/good_night_use_case.dart';
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
      final position = await LocationService.instance.getCurrentLocation();
      setState(() {
        _currentPosition = position;
        print("current position: $_currentPosition");
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
              child: Text("Location DEBUG")),
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
