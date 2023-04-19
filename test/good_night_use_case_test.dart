import 'package:flutter/material.dart';
import 'package:luna/Services/Alarm/alarm_service.dart';
import 'package:luna/Services/SmartHome/smart_home_model.dart';
import 'package:luna/Services/SmartHome/smart_home_service.dart';
import 'package:luna/Services/spotify_service.dart';
import 'package:luna/UseCases/good_night_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'good_night_use_case_test.mocks.dart';

@GenerateMocks([SmartHomeService, SpotifySdkService])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  var smartHomeService = MockSmartHomeService();
  var spotifySdkService = MockSpotifySdkService();
  GoodNightUseCase.instance.smartHomeService = smartHomeService;
  GoodNightUseCase.instance.spotifySdkService = spotifySdkService;

  test('test light execution if no lights are connected', () async {
    SharedPreferences.setMockInitialValues({
      "ip_key": "127.0.0.1",
      "user_key": "1234567890",
    });

    List<Light> lights = [];

    when(smartHomeService.getLights("127.0.0.1", "1234567890"))
        .thenAnswer((_) => Future.value(lights));

    var answer = await GoodNightUseCase.instance.turnOffAllLights();
    expect(answer, "Sorry, you don't have any lights connected.");
  });

  test('test light execution if one light is connected', () async {
    SharedPreferences.setMockInitialValues({
      "ip_key": "127.0.0.1",
      "user_key": "1234567890",
    });

    List<Light> lights = [
      Light(id: 1, name: "testlicht", on: true, reachable: true)
    ];

    when(smartHomeService.getLights("127.0.0.1", "1234567890"))
        .thenAnswer((_) => Future.value(lights));

    when(smartHomeService.turnOffLight(lights[0], "127.0.0.1", "1234567890"))
        .thenAnswer((_) => Future.value());

    var answer = await GoodNightUseCase.instance.turnOffAllLights();
    verify(smartHomeService.getLights("127.0.0.1", "1234567890"));
    verify(smartHomeService.turnOffLight(lights[0], "127.0.0.1", "1234567890"));
    expect(answer, "Your lights are turned off. ");
  });

  test('test light execution if there are connection errors', () async {
    SharedPreferences.setMockInitialValues({
      "ip_key": "127.0.0.1",
      "user_key": "1234567890",
    });

    List<Light> lights = [
      Light(id: 1, name: "testlicht", on: true, reachable: true)
    ];

    when(smartHomeService.getLights("127.0.0.1", "1234567890"))
        .thenAnswer((_) => Future.error("Error"));

    when(smartHomeService.turnOffLight(lights[0], "127.0.0.1", "1234567890"))
        .thenAnswer((_) => Future.value());

    var answer = await GoodNightUseCase.instance.turnOffAllLights();
    verify(smartHomeService.getLights("127.0.0.1", "1234567890"));
    verifyNever(
        smartHomeService.turnOffLight(lights[0], "127.0.0.1", "1234567890"));
    expect(answer, "Sorry, I couldn't turn off your lights.");
  });

  test('test light execution if there are connection errors for one light',
      () async {
    SharedPreferences.setMockInitialValues({
      "ip_key": "127.0.0.1",
      "user_key": "1234567890",
    });

    List<Light> lights = [
      Light(id: 1, name: "testlicht1", on: true, reachable: true),
      Light(id: 2, name: "testlicht2", on: true, reachable: true)
    ];

    when(smartHomeService.getLights("127.0.0.1", "1234567890"))
        .thenAnswer((_) => Future.value(lights));

    when(smartHomeService.turnOffLight(lights[0], "127.0.0.1", "1234567890"))
        .thenAnswer((_) => Future.value());
    when(smartHomeService.turnOffLight(lights[1], "127.0.0.1", "1234567890"))
        .thenAnswer((_) => Future.error("Error"));

    var answer = await GoodNightUseCase.instance.turnOffAllLights();

    verify(smartHomeService.getLights("127.0.0.1", "1234567890"));
    verify(smartHomeService.turnOffLight(lights[0], "127.0.0.1", "1234567890"));
    verify(smartHomeService.turnOffLight(lights[1], "127.0.0.1", "1234567890"));

    expect(answer,
        "Sorry, I couldn't turn off your light testlicht2. Your lights are turned off. ");
  });

  test(
      "Check the if the light execution works correctly if no user and no ip is set",
      () async {
    SharedPreferences.setMockInitialValues({
      "ip_key": "",
      "user_key": "",
    });
    String response = await GoodNightUseCase.instance.turnOffAllLights();
    verifyNever(smartHomeService.getLights("", ""));
    verifyNever(smartHomeService.turnOffLight(any, "", ""));
    expect(response,
        "I don't know your ip address or user. Sorry I can't turn off your lights.");
  });

  test("Check if the preferences are set correctly", () async {
    expect(GoodNightUseCase.instance.bridgeModel.ip, "");
    expect(GoodNightUseCase.instance.bridgeModel.user, "");

    SharedPreferences.setMockInitialValues({
      "ip_key": "123.123.123.123",
      "user_key": "1234567890",
    });

    await GoodNightUseCase.instance.loadPreferences();

    expect(GoodNightUseCase.instance.bridgeModel.ip, "123.123.123.123");
    expect(GoodNightUseCase.instance.bridgeModel.user, "1234567890");
  });

  test(
      "Check if no playlist is started if the spoitfy remote connection does not work",
      () async {
    when(spotifySdkService.connect()).thenAnswer((_) => Future.value(false));
    await GoodNightUseCase.instance.startSleepPlayList();
    verify(spotifySdkService.connect());
    verifyNever(spotifySdkService.playPlaylist(any));
    verifyNever(spotifySdkService.setRepeatMode(any));
  });

  test(
      "Check if no playlist is started if the spoitfy remote connection does not work",
      () async {
    when(spotifySdkService.connect()).thenAnswer((_) => Future.error("error"));
    await GoodNightUseCase.instance.startSleepPlayList();
    verify(spotifySdkService.connect());
    verifyNever(spotifySdkService.playPlaylist(any));
    verifyNever(spotifySdkService.setRepeatMode(any));
  });

  test(
      "Check if playlist is started if the spoitfy remote connection does work",
      () async {
    when(spotifySdkService.connect()).thenAnswer((_) => Future.value(true));
    when(spotifySdkService.playPlaylist("6X7wz4cCUBR6p68mzM7mZ4"))
        .thenAnswer((_) => Future.value());

    await GoodNightUseCase.instance.startSleepPlayList();
    verify(spotifySdkService.connect());
    verify(spotifySdkService.playPlaylist("6X7wz4cCUBR6p68mzM7mZ4"));
  });

  test("Check if answer is in yes trigger words", () {
    bool check = GoodNightUseCase.instance.checkIfAnswerIsYes("yes please");
    expect(check, true);
  });

  test("Check if answer is not in yes trigger words", () {
    bool check = GoodNightUseCase.instance.checkIfAnswerIsYes("no");
    expect(check, false);
  });

  test("Get all trigger words", () {
    var words = GoodNightUseCase.instance.getAllTriggerWords();
    expect(words.length, 11);
  });
}
