import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna/Screens/news_screen.dart';

void main() {
  group('news cards widget', () {    
    testWidgets('should render',
        (WidgetTester tester) async {
      // Arrange
      final widget = MyNewsCardsWidget();
      // Act
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));
      // Assert
      expect(find.byType(MyNewsCardsWidget), findsOneWidget);
    });
  });
}