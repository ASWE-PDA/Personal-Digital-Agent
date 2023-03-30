import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:luna/Model/smart_home_model.dart';
import 'package:http/http.dart' as http;

class BridgeService {
  BridgeService();

  Future<List<Bridge>> getBridges() async {
    var url = Uri.parse('https://discovery.meethue.com');
    var response = await http.get(url);

    if (response.body.isEmpty) {
      return Future.error(Exception("No bridges found"));
    }

    final responseMap = json.decode(response.body);
    List<Bridge> bridges = [];

    for (final json in responseMap) {
      Bridge bridge = Bridge.fromJson(json as Map<String, dynamic>);
      bridges.add(bridge);
    }

    return bridges;
  }

  Future<List<Bridge>> getBridgesDebug() async {
    var bridges = [
      Bridge(
          id: "001788fffe2b3c3a",
          internalipaddress: "192.168.178.61",
          port: 443),
      Bridge(
          id: "001788fffe2b3c3b",
          internalipaddress: "192.168.178.40",
          port: 443),
    ];

    return Future.delayed(Duration(seconds: 2), () {
      return bridges;
    });
  }

  // discover bridges and users
  Future<Bridge> connectToBridge() async {
    // var url = Uri.parse('https://discovery.meethue.com');
    // var response = await http.get(url);
    Bridge? activeBridge;
    Future<List<Bridge>> bridges = getBridgesDebug();

    bridges.then((bridges) async {
      for (Bridge bridge in bridges) {
        print(bridge.internalipaddress);
      }
    }).catchError((error) {
      print("Exception when fetching bridges " + error.toString());
    });

    return Future.error(Exception("No active bridges found"));
  }

  // check which ip address is the correct by checking if the link button is pressed
  Future<bool> checkBridge(String ip) async {
    var url = Uri.parse('http://$ip/api/');
    var response =
        await http.post(url, body: json.encode({"devicetype": "luna"}));
    final responseMap = json.decode(response.body);
    print(responseMap);
    if (responseMap[0].containsKey("error")) {
      return false;
    } else {
      return true;
    }
  }

  // create delayed user for debugging
  Future<String> createUserDebug(String ip) async {
    return Future.delayed(Duration(seconds: 3), () {
      return "newdeveloper";
    });
  }

  // create user
  Future<dynamic> createUser(String ip) async {
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
    } on TimeoutException catch (e) {
      return Future.error(Exception("Timeout. No connection to bridge"));
    } on SocketException catch (e) {
      return Future.error(
          Exception("SocketException. No connection to bridge"));
    } on Exception catch (e) {
      return Future.error(Exception("Unknown error"));
    } catch (e) {
      return Future.error(Exception("Unknown error"));
    }
  }
}
