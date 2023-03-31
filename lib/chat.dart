import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:luna/Services/SmartHome/smart_home_service.dart';
import 'package:luna/Services/SmartHome/bridge_model.dart';
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
  SmartHomeService smartHomeService = SmartHomeService(ip: "", user: "");

  BridgeModel userModel = BridgeModel();
  loadPreferences() async {
    String user = Provider.of<BridgeModel>(context, listen: false).user;
    String ip = Provider.of<BridgeModel>(context, listen: false).ip;
    smartHomeService.configurateBridge(ip, user);
    print(ip);
    print(user);
  }

  @override
  void initState() {
    super.initState();
    loadPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
              onPressed: () async {
                GoodNightUseCase goodNightUseCase = GoodNightUseCase(
                    {"ip": smartHomeService.ip, "user": smartHomeService.user});
                String text =
                    goodNightUseCase.execute("please turn off the lights");
                await flutterTts.setLanguage("en-US");
                flutterTts.speak(text);
              },
              child: Text("Test Good Night Use Case DEBUG")),
          ElevatedButton(
              onPressed: () async {
                if (smartHomeService.ip == "" || smartHomeService.user == "") {
                  await flutterTts.setLanguage("en-US");
                  flutterTts.speak(
                      "You have not connected your bridge yet. Please connect your bridge first.");
                  return;
                } else {
                  smartHomeService.turnOffAllLights(
                      smartHomeService.ip, smartHomeService.user);
                  await flutterTts.setLanguage("en-US");
                  flutterTts.speak(
                      "I turned off all the lights. Good Night. Sleep Well.");
                }
              },
              child: Text("Turn off all lights (DEBUG)")),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: FloatingActionButton(
              onPressed: () {
                print('test');
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
