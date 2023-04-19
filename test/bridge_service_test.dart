import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:luna/Services/SmartHome/bridge_service.dart';
import 'package:luna/Services/SmartHome/smart_home_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'bridge_service_test.mocks.dart';

@GenerateMocks([BridgeService, http.Client])
void main() {
  final mockBridgeService = MockBridgeService();

  group('BridgeService', () {
    BridgeService bridgeService = BridgeService();
    MockClient client = MockClient();

    setUp(() {
      bridgeService.client = client;
    });

    test('checkBridge returns true when bridge found', () async {
      when(client.get(Uri.parse('https://discovery.meethue.com'))).thenAnswer(
          (_) async => http.Response(
              '[{"internalipaddress":"192.168.1.2", "id": "1", "port":443}]',
              200));
      expect(await bridgeService.checkBridge('192.168.1.2'), true);
    });

    test('checkBridge returns false when bridge not found', () async {
      when(client.get(Uri.parse('https://discovery.meethue.com'))).thenAnswer(
          (_) async => http.Response(
              '[{"internalipaddress":"192.168.1.2", "id": "1", "port":443}]',
              200));
      expect(await bridgeService.checkBridge('192.168.1.3'), false);
    });

    test('getBridges returns list of bridges', () async {
      when(client.get(Uri.parse('https://discovery.meethue.com'))).thenAnswer(
          (_) async => http.Response(
              '[{"internalipaddress":"192.168.1.2", "id": "1", "port":443}]',
              200));
      var result = await bridgeService.getBridges();
      expect(result.length, 1);
      expect(result[0].internalipaddress, '192.168.1.2');
    });

    test('getBridges returns empty list when response is empty', () async {
      when(client.get(Uri.parse('https://discovery.meethue.com')))
          .thenAnswer((_) async => http.Response('', 200));
      var result = await bridgeService.getBridges();
      expect(result.length, 0);
    });

    test('getBridges returns empty list when response is invalid', () async {
      when(client.get(Uri.parse('https://discovery.meethue.com')))
          .thenAnswer((_) async => http.Response('invalid response', 200));
      var result = await bridgeService.getBridges();
      expect(result.length, 0);
    });

    test('createUser returns username when successful', () async {
      var ip = '192.168.1.2';
      when(client.post(Uri.parse('http://$ip/api/'),
              body: '{"devicetype":"luna"}'))
          .thenAnswer((_) async =>
              http.Response('[{"success":{"username":"newuser"}}]', 200));
      expect(await bridgeService.createUser(ip), 'newuser');
    });

    test('createUser throws exception when status code is not 200', () async {
      var ip = '192.168.1.2';
      when(client.post(Uri.parse('http://$ip/api/'),
              body: '{"devicetype":"luna"}'))
          .thenAnswer((_) async => http.Response(
              '{"error":{"description":"link button not pressed"}}', 500));
      expect(
          () => bridgeService.createUser(ip),
          throwsA(predicate((Exception e) =>
              e.toString() ==
              'Exception: error creating user with status code: 500')));
    });

    test('createUser throws exception when status code is 200 but error',
        () async {
      var ip = '192.168.1.2';
      when(client.post(Uri.parse('http://$ip/api/'),
              body: '{"devicetype":"luna"}'))
          .thenAnswer((_) async => http.Response(
              '[{"error":{"description":"link button not pressed"}}]', 200));

      expect(
          () => bridgeService.createUser(ip),
          throwsA(predicate((Exception e) =>
              e.toString() == 'Exception: link button not pressed')));
    });

    test(
        'createUser throws exception when status code is 200 but the answer is invalid',
        () async {
      var ip = '192.168.1.2';
      when(client.post(Uri.parse('http://$ip/api/'),
              body: '{"devicetype":"luna"}'))
          .thenAnswer((_) async => http.Response('invalid answer', 200));

      expect(
          () => bridgeService.createUser(ip),
          throwsA(predicate(
              (Exception e) => e.toString() == 'Exception: Unknown error')));
    });
  });
}
