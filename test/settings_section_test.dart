import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna/Widgets/settings_section.dart';

void main() {
  group('SettingsSection Widget', () {
    testWidgets('should render title and children',
        (WidgetTester tester) async {
      // Arrange
      final title = 'Section Title';
      final children = [Text('Child 1'), Text('Child 2')];
      final widget = SettingsSection(title: title, children: children);

      // Act
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

      // Assert
      expect(find.text(title), findsOneWidget);
      expect(find.text('Child 1'), findsOneWidget);
      expect(find.text('Child 2'), findsOneWidget);
    });

    testWidgets('should have correct style', (WidgetTester tester) async {
      // Arrange
      final title = 'Section Title';
      final children = [Text('Child 1'), Text('Child 2')];
      final widget = SettingsSection(title: title, children: children);

      // Act
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

      // Assert
      final titleTextWidget = tester.widget<Text>(find.text(title));
      expect(titleTextWidget.style?.fontSize, equals(16.0));
      expect(titleTextWidget.style?.fontWeight, equals(FontWeight.bold));
      expect(titleTextWidget.style?.color, equals(Colors.blue));
    });
  });
}
