import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna/Screens/connect_bridge_screen.dart';

void main() {
  group('connect bridge widget', () {    
    testWidgets('should render',
        (WidgetTester tester) async {
      // Arrange
      String ipAdress = '192.158.1.38';
      final widget = ConnectBrigdeScreen(ip: ipAdress);
      // Act
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));
      // Assert
      expect(find.byType(ConnectBrigdeScreen), findsOneWidget);
    });
  });
}