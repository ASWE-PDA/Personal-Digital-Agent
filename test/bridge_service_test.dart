import 'package:flutter_test/flutter_test.dart';
import 'package:luna/Services/SmartHome/bridge_service.dart';
import 'package:luna/Services/SmartHome/smart_home_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'bridge_service_test.mocks.dart';

@GenerateMocks([BridgeService])
void main() {
  final mockBridgeService = MockBridgeService();

  test("Test if no bridge is found if ip is wrong", () async {
    List<Bridge> bridges = [];

    when(mockBridgeService.getBridges())
        .thenAnswer((_) => Future.value(bridges));

    var answer = await mockBridgeService.getBridges();
    expect(answer, bridges);
  });

  test("Test if bridge is found if ip is correct", () async {
    List<Bridge> bridges = [
      Bridge(id: "1", internalipaddress: "123", port: 443)
    ];

    when(mockBridgeService.getBridges())
        .thenAnswer((_) => Future.value(bridges));

    var answer = await mockBridgeService.getBridges();
    expect(answer, bridges);
  });
}
