import 'package:flutter/material.dart';
import 'package:luna/Services/SmartHome/bridge_service.dart';
import 'package:luna/Services/SmartHome/bridge_model.dart';
import 'package:provider/provider.dart';

/// Screen that allows the user to connect to a Philips Hue bridge.
class ConnectBrigdeScreen extends StatefulWidget {
  final String ip;
  const ConnectBrigdeScreen({required this.ip});

  @override
  State<ConnectBrigdeScreen> createState() => _ConnectBrigdeScreenState();
}

class _ConnectBrigdeScreenState extends State<ConnectBrigdeScreen> {
  BridgeService bridgeService = BridgeService();
  late Future<dynamic> username;
  bool buttonPressed = false;
  bool userCreated = false;
  late Future<bool> bridgeAvailable;

  @override
  void initState() {
    super.initState();
    bridgeAvailable = bridgeService.checkBridge(widget.ip);
  }

  Widget connectBridgeSection() {
    return Consumer<BridgeModel>(
        builder: (context, BridgeModel userModel, child) {
      return buttonPressed
          ? FutureBuilder(
              future: username,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle,
                            size: 100, color: Colors.green),
                        Text("Bridge successfully connected")
                      ]);
                } else if (snapshot.hasError) {
                  return connectionError();
                }
                return CircularProgressIndicator();
              })
          : Column(children: [
              Container(
                padding: EdgeInsets.only(top: 30),
                child: Image.asset(
                  'assets/images/pushlink_bridge_v2.png',
                  width: 250,
                  height: 250,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  "Press the link button on your bridge.",
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
              ElevatedButton(
                  child: Text("Connect"),
                  onPressed: () async {
                    username = bridgeService.createUser(widget.ip);
                    username.then((value) {
                      print("Username: $value");
                      setState(() {
                        userModel.setUser = value.toString();
                        userCreated = true;
                      });
                    }).catchError((error) {});
                    setState(() {
                      buttonPressed = true;
                    });
                  }),
            ]);
    });
  }

  Widget connectionError() {
    return Column(children: [
      Padding(
          padding: EdgeInsets.only(top: 24.0),
          child: Icon(Icons.error_outline,
              size: 100, color: Theme.of(context).primaryColor)),
      Padding(
          padding: EdgeInsets.only(top: 16.0),
          child: Text("Bridge could not be connected")),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
        child: Text(
          "Make sure your phone is connected to the same network as your bridge and that you pressed the button on your bridge.",
          textAlign: TextAlign.center,
        ),
      ),
      ElevatedButton(
          child: Text("Try again"),
          onPressed: () {
            setState(() {
              buttonPressed = false;
            });
          })
    ]);
  }

  Widget content() {
    return FutureBuilder(
        future: bridgeAvailable,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print("bridge available");
            return connectBridgeSection();
          } else if (snapshot.hasError) {
            return Column(children: [
              Padding(
                  padding: EdgeInsets.only(top: 24.0),
                  child: Icon(Icons.error_outline,
                      size: 100, color: Theme.of(context).primaryColor)),
              Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Text("Bridge is not available!",
                      style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor))),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 28.0),
                child: Text(
                  "Please check if the ip address is correct and the bridge is turned on.",
                  textAlign: TextAlign.center,
                ),
              ),
            ]);
          }
          return CircularProgressIndicator();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Connect Philips Hue Bridge")),
        body: Center(
          child: content(),
        ));
  }
}
