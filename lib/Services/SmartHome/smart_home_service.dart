import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:luna/Services/SmartHome/smart_home_model.dart';
import 'package:luna/Services/SmartHome/bridge_service.dart';

class SmartHomeService {
  String ip = "";
  String user = "";
  BridgeService bridgeService = BridgeService();

  SmartHomeService({required this.ip, required this.user});

  // set ip address and user
  Future<dynamic> configurateBridge(ip, user) async {
    this.ip = ip;
    this.user = user;
  }

  // Get all lights
  Future<dynamic> getLights() async {
    var url = Uri.parse('http://$ip/api/$user/lights');
    var response = await http.get(url);
    final responseMap = json.decode(response.body);
    var lights = _responseToLights(responseMap);
    return lights;
  }

  List<Light> _responseToLights(Map<String, dynamic> response) {
    final lights = <Light>[];
    final ids = response.keys;
    for (final id in response.keys) {
      final item = response[id] as Map<String, dynamic>;
      final light = Light.fromJson(item, int.parse(id));
      lights.add(light);
    }
    return lights;
  }

  // turn off all lights
  Future<dynamic> turnOffAllLights() async {
    var lights = await getLights();
    print(lights);
    for (Light light in lights) {
      await turnOffLight(light);
    }
  }

  // turn off a light
  Future<dynamic> turnOffLight(Light light) async {
    if (light.on) {
      print("turning off light: " + light.name);
      var url = Uri.parse('http://$ip/api/$user/lights/${light.id}/state');
      var response = await http.put(url, body: '{"on": false}');
      return response;
    } else {
      print("light already off: " + light.name);
    }
  }

  // turn on a light
  Future<dynamic> turnOnLight(int id) async {
    var url = Uri.parse('http://$ip/api/$user/lights/$id/state');
    var response = await http.put(url, body: '{"on": true}');
    return response;
  }
}
