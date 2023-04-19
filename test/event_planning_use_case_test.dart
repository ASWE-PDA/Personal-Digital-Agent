import 'dart:math';

import 'package:flutter/material.dart';
import 'package:luna/Services/Alarm/alarm_service.dart';
import 'package:luna/Services/SmartHome/smart_home_model.dart';
import 'package:luna/Services/SmartHome/smart_home_service.dart';
import 'package:luna/Services/spotify_service.dart';
import 'package:luna/UseCases/EventPlanning/event_planning_use_case.dart';
import 'package:luna/UseCases/good_night_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'good_night_use_case_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  test("parser pm", () {
    var datetime = EventPlanningUseCase.instance.parseSpokenTime("8:00 pm");
    expect(
        datetime,
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
            20, 0));
  });
}
