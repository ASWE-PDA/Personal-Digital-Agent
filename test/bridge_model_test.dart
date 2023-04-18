import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:luna/Services/SmartHome/bridge_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SharedPreferences.setMockInitialValues({});
  BridgeModel bridgeModel = BridgeModel();

  test("Test if user and ip is none if no preferences are set", () {
    expect(bridgeModel.user, "");
    expect(bridgeModel.ip, "");
  });

  test("Test if user and ip is set if preferences are set", () async {
    SharedPreferences.setMockInitialValues({
      "ip_key": "123.123.123.123",
      "user_key": "1234567890",
    });
    await bridgeModel.getBridgePreferences();

    expect(bridgeModel.user, "1234567890");
    expect(bridgeModel.ip, "123.123.123.123");
  });

  test("Test if user and ip is set correctly if preferences are updated",
      () async {
    bridgeModel.setUser = "1234567890";
    bridgeModel.setIpAddress = "123.123.123.123";

    await bridgeModel.getBridgePreferences();
    expect(bridgeModel.user, "1234567890");
    expect(bridgeModel.ip, "123.123.123.123");
  });

  test("Test if the preferences are deleted", () async {
    SharedPreferences.setMockInitialValues({
      "ip_key": "123.123.123.123",
      "user_key": "1234567890",
    });
    await bridgeModel.deleteBridgePreferences();
    expect(bridgeModel.user, "");
    expect(bridgeModel.ip, "");
  });
}
