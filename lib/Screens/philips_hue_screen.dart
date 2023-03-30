import 'package:flutter/material.dart';
import 'package:luna/Screens/connect_bridge_screen.dart';
import 'package:luna/Services/SmartHome/bridge_model.dart';
import 'package:provider/provider.dart';

// Screen to enter a new ip address and store the value locally.
class SmartHomeSettingsScreen extends StatefulWidget {
  const SmartHomeSettingsScreen({super.key});

  @override
  State<SmartHomeSettingsScreen> createState() => _SmartHomeSettingsScreen();
}

class _SmartHomeSettingsScreen extends State<SmartHomeSettingsScreen> {
  final TextEditingController _ipController = TextEditingController();

  /// Returns true if the ip input field is empty
  bool isEmpty() {
    if (_ipController.text == "" || _ipController.text.isEmpty) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BridgeModel>(
        builder: (context, BridgeModel userModel, child) {
      return Scaffold(
          appBar: AppBar(
            title: const Text("Connect Bridge"),
            actions: [
              // button to update the value of the ip address
              TextButton(
                onPressed: isEmpty()
                    ? null
                    : () {
                        userModel.setIpAddress = _ipController.text;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ConnectBrigdeScreen(ip: _ipController.text)),
                        );
                      },
                child: Text(
                  "Next",
                  style: TextStyle(
                      color: isEmpty()
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).primaryColor,
                      fontSize: 16.0),
                ),
              )
            ],
          ),
          // input field for the ip address
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 24.0, horizontal: 16.0),
                child: TextFormField(
                  controller: _ipController,
                  decoration: const InputDecoration(
                      hintText: 'Enter IP address of bridge'),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
            ],
          ));
    });
  }
}
