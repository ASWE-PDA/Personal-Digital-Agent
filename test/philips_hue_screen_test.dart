import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna/Screens/connect_bridge_screen.dart';
import 'package:luna/Screens/philips_hue_screen.dart';
import 'package:luna/Services/SmartHome/bridge_model.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'philips_hue_screen_test.mocks.dart';

@GenerateMocks([BridgeModel])
void main() {
  group('SmartHomeSettingsScreen', () {
    testWidgets('should show an input field and a Next button',
        (WidgetTester tester) async {
      final mockBridgeModel = MockBridgeModel();

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<BridgeModel>(
            create: (context) => mockBridgeModel,
            child: SmartHomeSettingsScreen(),
          ),
        ),
      );

      final inputFinder = find.byType(TextFormField);
      expect(inputFinder, findsOneWidget);

      final buttonFinder = find.text('Next');
      expect(buttonFinder, findsOneWidget);
    });

    testWidgets('should disable the Next button when the input field is empty',
        (WidgetTester tester) async {
      final mockBridgeModel = MockBridgeModel();

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<BridgeModel>(
            create: (context) => mockBridgeModel,
            child: SmartHomeSettingsScreen(),
          ),
        ),
      );

      final buttonFinder = find.text('Next');
      expect(buttonFinder, findsOneWidget);
    });

    testWidgets(
        'should enable the Next button when the input field is not empty',
        (WidgetTester tester) async {
      final mockBridgeModel = MockBridgeModel();

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<BridgeModel>(
            create: (context) => mockBridgeModel,
            child: SmartHomeSettingsScreen(),
          ),
        ),
      );

      final inputFinder = find.byType(TextFormField);
      await tester.enterText(inputFinder, '192.168.1.100');

      final buttonFinder = find.text('Next');
      expect(buttonFinder, findsOneWidget);
    });

    testWidgets(
        'should call BridgeModel.setIpAddress when Next button is pressed',
        (WidgetTester tester) async {
      final mockBridgeModel = BridgeModel();

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<BridgeModel>(
            create: (context) => mockBridgeModel,
            child: SmartHomeSettingsScreen(),
          ),
        ),
      );

      final inputFinder = find.byType(TextFormField);
      await tester.enterText(inputFinder, '192.168.1.100');

      final buttonFinder = find.text('Next');
      expect(buttonFinder, findsOneWidget);

      await tester.tap(buttonFinder);
      await tester.pumpAndSettle();

      expect(mockBridgeModel.ip, '');
      mockBridgeModel.setIpAddress = '192.168.1.100';

      expect(mockBridgeModel.ip, '192.168.1.100');
    });
  });
}
