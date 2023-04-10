import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:luna/Services/Alarm/alarm_service.dart';
import 'package:luna/Services/SmartHome/smart_home_service.dart';
import 'package:luna/Services/SmartHome/bridge_model.dart';
import 'package:luna/Services/notification_service.dart';
import 'package:luna/UseCases/good_night_use_case.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ChatPage extends StatefulWidget {
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  FlutterTts flutterTts = FlutterTts();
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String lastWords = '';
  String user = "";
  String ip = "";

  @override
  void initState() {
    super.initState();
    loadPreferences();
    _initSpeech();
  }

  BridgeModel userModel = BridgeModel();
  loadPreferences() {
    user = Provider.of<BridgeModel>(context, listen: false).user;
    ip = Provider.of<BridgeModel>(context, listen: false).ip;
    print(ip);
    print(user);
  }

  // initialize speech to text, only once
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  // each time to start a speech recognition session
  void _startListening() async {
    lastWords = '';
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  // manually stop the active speech recognition session
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  // callback that the SpeechToText plugin uses to return the recognized words
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    loadPreferences();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                'Recognized words:',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
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
                          ? 'Tap the microphone to start speaking...'
                          : 'Speech recognition is not available on this device.',
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
                  setAlarmByDateTime(DateTime.now().add(Duration(seconds: 10)));
                },
                child: Text("Test Alarm DEBUG")),
            ElevatedButton(
                onPressed: () async {
                  GoodNightUseCase.instance.execute("good night");
                },
                child: Text("Test Good Night Use Case DEBUG")),
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
    );
  }
}
