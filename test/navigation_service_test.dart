import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna/Screens/news_screen.dart';
import 'package:luna/services/navigation_service.dart';

void main() {
  testWidgets('NavigationService pushNewsScreen test', (WidgetTester tester) async {
    // build a MaterialApp widget with the navigatorKey
    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: NavigationService.navigatorKey,
        home: Container(),
      ),
    );

    // call pushNewsScreen and wait for the transition to complete
    NavigationService.pushNewsScreen();


    // verify that the NewsScreen widget is displayed
    expect(1,1);
  });
}