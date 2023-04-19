import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:luna/Services/SmartHome/smart_home_model.dart';
import 'package:http/http.dart' as http;

/// Service class for the bridge.
class BridgeService {
  /// Constructor of the [BridgeService] class.
  BridgeService();

  /// Takes an [ip] and checks if the bridge is reachable in the local network.
  ///
  /// Returns true if the bridge is reachable.
  Future<bool> checkBridge(String ip) async {
    List<Bridge> bridges = await getBridges();
    for (Bridge bridge in bridges) {
      print(bridge.internalipaddress);
      if (bridge.internalipaddress == ip) {
        return true;
      }
    }
    print("Bridge not found");
    return Future.error("Bridge not found");
  }

  /// Gets all bridges in the local network.
  ///
  /// Returns a list of [Bridge] objects.
  Future<List<Bridge>> getBridges() async {
    var url = Uri.parse('https://discovery.meethue.com');
    try {
      var response = await http.get(url);
      if (response.body.isEmpty) {
        return [];
      }
      final responseMap = json.decode(response.body);
      List<Bridge> bridges = [];

      for (final json in responseMap) {
        Bridge bridge = Bridge.fromJson(json as Map<String, dynamic>);
        bridges.add(bridge);
      }
      return bridges;
    } catch (e) {
      print(e);
      return [];
    }
  }

  /// Takes an [ip] and creates a new user.
  ///
  /// Returns the user name.
  Future<String> createUser(String ip) async {
    print("creating user");
    try {
      var user = "";
      var url = Uri.parse('http://$ip/api/');
      var response = await http
          .post(url, body: json.encode({"devicetype": "luna"}))
          .timeout(Duration(seconds: 3));

      if (response.statusCode == 200) {
        final responseMap = json.decode(response.body);
        try {
          user = responseMap[0]["success"]["username"];
          print("user created: $user");
          return user;
        } catch (e) {
          String errorMessage = responseMap[0]["error"]["description"];
          print("error creating user: $errorMessage");
          return Future.error(Exception(errorMessage));
        }
      } else {
        return Future.error(Exception(
            "error creating user with status code: ${response.statusCode}"));
      }
    } catch (e) {
      return Future.error(Exception("Unknown error"));
    }
  }
}
