import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:luna/Services/SmartHome/smart_home_model.dart';

/// Service to communicate with the lights connected to a bridge.
class SmartHomeService {
  /// Constructor for the [SmartHomeService].
  SmartHomeService();

  /// Gets all lights connected to the a bridge defined by the [ip] and [user].
  ///
  /// Returns a list of lights.
  Future<List<Light>> getLights(ip, user) async {
    var url = Uri.parse('http://$ip/api/$user/lights');
    try {
      var response = await http.get(url);
      final responseMap = json.decode(response.body);
      var lights = responseToLights(responseMap);
      return lights;
    } catch (e) {
      return Future.error(e);
    }
  }

  /// Transforms the [response] from the bridge to a list of lights.
  ///
  /// Returns a list of lights.
  List<Light> responseToLights(Map<String, dynamic> response) {
    final lights = <Light>[];
    for (final id in response.keys) {
      final item = response[id] as Map<String, dynamic>;
      final light = Light.fromJson(item, int.parse(id));
      lights.add(light);
    }
    return lights;
  }

  /// Turns off a [light] that is connected to the bridge defined by the [ip] and [user].
  Future<void> turnOffLight(Light light, ip, user) async {
    if (light.on) {
      var url = Uri.parse('http://$ip/api/$user/lights/${light.id}/state');
      try {
        var response = await http.put(url, body: '{"on": false}');
      } catch (e) {
        return Future.error(e);
      }
    } else {
    }
  }
}
