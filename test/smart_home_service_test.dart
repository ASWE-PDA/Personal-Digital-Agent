import 'package:luna/Services/SmartHome/smart_home_model.dart';
import 'package:luna/Services/SmartHome/smart_home_service.dart';
import 'package:luna/UseCases/good_night_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:collection/collection.dart';

import 'smart_home_service_test.mocks.dart';

// method that takes two list of lights end checks if they are equal
bool compareLists(List<Light> list1, List<Light> list2) {
  if (list1.length != list2.length) {
    return false;
  }

  for (int i = 0; i < list1.length; i++) {
    if (list1[i].id != list2[i].id) {
      return false;
    }
    if (list1[i].name != list2[i].name) {
      return false;
    }
    if (list1[i].on != list2[i].on) {
      return false;
    }
    if (list1[i].reachable != list2[i].reachable) {
      return false;
    }
  }

  return true;
}

@GenerateMocks([SmartHomeService])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  var mockSmartHomeService = MockSmartHomeService();
  var smartHomeService = SmartHomeService();

  test('test if the json responses are parsed correctly', () async {
    SharedPreferences.setMockInitialValues({
      "ip_key": "12",
      "user_key": "12",
    });

    List<Light> lights = [
      Light(id: 1, name: "testlicht1", on: true, reachable: true),
      Light(id: 2, name: "testlicht2", on: false, reachable: true)
    ];

    Map<String, dynamic> response = {
      "1": {
        "state": {"on": true, "reachable": true},
        "name": "testlicht1"
      },
      "2": {
        "state": {"on": false, "reachable": true},
        "name": "testlicht2"
      }
    };

    var answer = smartHomeService.responseToLights(response);
    var equal = compareLists(lights, answer);
    expect(true, equal);
  });

  test('Verify the get lights', () {
    List<Light> lights = [
      Light(id: 1, name: "testlicht", on: true, reachable: true)
    ];

    when(mockSmartHomeService.getLights("127.0.0.1", "1234567890"))
        .thenAnswer((_) => Future.value(lights));

    mockSmartHomeService.getLights("127.0.0.1", "1234567890");
    verify(mockSmartHomeService.getLights("127.0.0.1", "1234567890"));
  });
}
