import "package:avatar_glow/avatar_glow.dart";
import "package:flutter/material.dart";
import "package:flutter_tts/flutter_tts.dart";
import "package:geolocator/geolocator.dart";
import "package:luna/Screens/news_screen.dart";
import "package:luna/Services/Alarm/alarm_service.dart";
import "package:luna/Services/location_service.dart";
import "package:luna/Services/maps_service.dart";
import "package:luna/Services/SmartHome/smart_home_service.dart";
import "package:luna/Services/SmartHome/bridge_model.dart";
import "package:luna/Services/notification_service.dart";
import 'package:luna/UseCases/EventPlanning/event_planning_use_case.dart';
import "package:luna/UseCases/good_night_use_case.dart";
import "package:luna/UseCases/news/news_use_case.dart";
import "package:provider/provider.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:speech_to_text/speech_recognition_result.dart";
import "package:speech_to_text/speech_to_text.dart";
import "package:luna/StateMachine/state_machine.dart";

class ChatPage extends StatefulWidget {
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Controller controller = Controller(); // State machine controller
  FlutterTts flutterTts = FlutterTts();
  SpeechToText _speechToText = SpeechToText();
  MapsService mapsService = MapsService();
  bool _speechEnabled = false;
  String lastWords = "";
  String user = "";
  String ip = "";

  @override
  void initState() {
    super.initState();
    loadPreferences();
    _initSpeech();
  }

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

  /// Initialize speech to text, only once
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    lastWords = "";
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      // State machine controller interface: push update with recognized words
      controller.update(lastWords);
    });
  }

  /// Callback that the SpeechToText plugin uses to return the recognized words
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords.toLowerCase();
    });
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    loadPreferences();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    // if recording is active: show the recognized words
                    _speechToText.isListening
                        ? lastWords
                        // if recording isn't active but could be tell the user
                        // how to start it, otherwise indicate that speed
                        // recognition is not yet ready or not supported on
                        // target device
                        : _speechEnabled
                            ? lastWords != ""
                                ? lastWords
                                : "Tap the microphone to start speaking..."
                            : "Speech recognition is not available on this device.",
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    stopAlarm();
                  },
                  child: Text("Stop Alarm DEBUG")),
              ElevatedButton(
                  onPressed: () async {
                    setAlarmByDateTime(
                        DateTime.now().add(Duration(seconds: 10)));
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
                    Map<String, dynamic> routeDetails =
                        await mapsService.getRouteDetails(
                            origin: _currentPosition!,
                            destination: "California",
                            travelMode: "driving",
                            departureTime: DateTime.now());
                    print("Duration: ${routeDetails["durationAsText"]}");
                  },
                  child: Text("Get Maps Info DEBUG")),
              ElevatedButton(
                  onPressed: () async {
                    //SchedulingUseCase.instance.execute("calendar");
                    controller.update("calendar");
                  },
                  child: Text("Test Calendar Usecase DEBUG")),
              ElevatedButton(
                  onPressed: () async {
                    NewsUseCase.instance.execute("news");
                  },
                  child: Text("Test News Use Case DEBUG")),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: AvatarGlow(
                  // using AvaterGLow to animate the recording button when active
                  animate: _speechToText.isListening,
                  glowColor: Theme.of(context).primaryColor,
                  endRadius: 75.0,
                  duration: const Duration(milliseconds: 2000),
                  repeatPauseDuration: const Duration(milliseconds: 100),
                  repeat: true,
                  child: FloatingActionButton(
                    onPressed:
                        // if not yet listening: start listening, otherwise stop
                        _speechToText.isNotListening
                            ? _startListening
                            : _stopListening,
                    child: Icon(_speechToText.isNotListening
                        ? Icons.mic_none
                        : Icons.mic),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
