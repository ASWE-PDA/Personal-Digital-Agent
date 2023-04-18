import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:luna/Services/SmartHome/bridge_model.dart';
import 'package:luna/UseCases/good_night_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SharedPreferences.setMockInitialValues({});
  GoodNightModel goodNightModel = GoodNightModel();

  test("Test if hours and minutes are null if no preferences are set", () {
    expect(goodNightModel.hours, null);
    expect(goodNightModel.minutes, null);
  });

  test("Test if hours and minutes are set if preferences are set", () async {
    SharedPreferences.setMockInitialValues(
        {"hours_key": 10, "minutes_key": 12});
    await goodNightModel.getGoodNightPreferences();

    expect(goodNightModel.hours, 10);
    expect(goodNightModel.minutes, 12);
  });

  test("Test if hours and mintues are set correctly if preferences are updated",
      () async {
    goodNightModel.setHours = 13;
    goodNightModel.setMinutes = 15;

    await goodNightModel.getGoodNightPreferences();
    expect(goodNightModel.hours, 13);
    expect(goodNightModel.minutes, 15);
  });

  test("Test if the preferences are deleted", () async {
    SharedPreferences.setMockInitialValues(
        {"hours_key": 12, "minutes_key": 13});
    await goodNightModel.deleteGoodNightPreferences();
    expect(goodNightModel.hours, null);
    expect(goodNightModel.minutes, null);
  });

  test("Test if the preferences string is correct", () async {
    SharedPreferences.setMockInitialValues(
        {"hours_key": 12, "minutes_key": 13});

    await goodNightModel.getGoodNightPreferences();

    String result = goodNightModel.getPreferencesAsString();
    expect(result, "12:13");
  });

  test("Test if the preferences string is correct", () async {
    SharedPreferences.setMockInitialValues({"hours_key": 2, "minutes_key": 13});

    await goodNightModel.getGoodNightPreferences();

    String result = goodNightModel.getPreferencesAsString();
    expect(result, "02:13");
  });

  test("Test if the preferences string is correct", () async {
    SharedPreferences.setMockInitialValues({"hours_key": 2, "minutes_key": 3});

    await goodNightModel.getGoodNightPreferences();

    String result = goodNightModel.getPreferencesAsString();
    expect(result, "02:03");
  });

  test("Test if the preferences string is correct", () async {
    SharedPreferences.setMockInitialValues(
        {"hours_key": 12, "minutes_key": 03});

    await goodNightModel.getGoodNightPreferences();

    String result = goodNightModel.getPreferencesAsString();
    expect(result, "12:03");
  });
}
