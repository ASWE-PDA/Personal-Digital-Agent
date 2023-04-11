import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:luna/Services/SmartHome/smart_home_model.dart';
import 'package:luna/Services/SmartHome/bridge_service.dart';

// Get all lights
Future<dynamic> getLights(ip, user) async {
  var url = Uri.parse('http://$ip/api/$user/lights');
  try {
    var response = await http.get(url);
    final responseMap = json.decode(response.body);
    var lights = _responseToLights(responseMap);
    return lights;
  } catch (e) {
    print(e);
    return [];
  }
}

List<Light> _responseToLights(Map<String, dynamic> response) {
  final lights = <Light>[];
  for (final id in response.keys) {
    final item = response[id] as Map<String, dynamic>;
    final light = Light.fromJson(item, int.parse(id));
    lights.add(light);
  }
  return lights;
}

// turn off all lights
Future<dynamic> turnOffAllLights(ip, user) async {
  var lights = await getLights(ip, user);
  print(lights);
  for (Light light in lights) {
    await turnOffLight(light, ip, user);
  }
}

// turn off a light
turnOffLight(Light light, ip, user) async {
  if (light.on) {
    print("turning off light: ${light.name}");
    var url = Uri.parse('http://$ip/api/$user/lights/${light.id}/state');
    try {
      var response = await http.put(url, body: '{"on": false}');
    } catch (e) {
      print(e);
    }
  } else {
    print("light already off: ${light.name}");
  }
}
