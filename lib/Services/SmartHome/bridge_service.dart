import "dart:async";
import "dart:convert";
import "dart:io";
import "package:luna/Services/SmartHome/smart_home_model.dart";
import "package:http/http.dart" as http;

class BridgeService {
  BridgeService();

  /// take ip address and check if bridge is available
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

  Future<List<Bridge>> getBridges() async {
    var url = Uri.parse("https://discovery.meethue.com");
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

  // debugging function
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
      var url = Uri.parse("http://$ip/api/");
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
