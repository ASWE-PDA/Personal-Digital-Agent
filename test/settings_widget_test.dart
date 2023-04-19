import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna/Widgets/settings_widget.dart';

void main() {
  group('SettingsWidget Widget', () {
    testWidgets('should render title, icon, and action',
        (WidgetTester tester) async {
      // Arrange
      final title = 'Setting Title';
      final icon = Icon(Icons.settings);
      final action = TextButton(onPressed: () {}, child: Text('Action'));
      final widget = SettingsWidget(title: title, icon: icon, action: action);

      // Act
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

      // Assert
      expect(find.text(title), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
      expect(find.byWidget(action), findsOneWidget);
    });

    testWidgets(
        'should not prevent action overflow if preventActionOverflow is false',
        (WidgetTester tester) async {
      // Arrange
      final title = 'Setting Title';
      final icon = Icon(Icons.settings);
      final action = TextButton(onPressed: () {}, child: Text('Action'));
      final widget = SettingsWidget(
          title: title,
          icon: icon,
          action: action,
          preventActionOverflow: false);

      // Act
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

      // Assert
      expect(find.text(title), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
      expect(find.byWidget(action), findsOneWidget);
      final row = find.byType(Row).evaluate().first.widget as Row;
      expect(row.children.length, equals(3));
    });
  });

  testWidgets('should prevent action overflow if preventActionOverflow is true',
      (WidgetTester tester) async {
    // Arrange
    final title = 'Setting Title';
    final icon = Icon(Icons.settings);
    final action = TextButton(onPressed: () {}, child: Text('Action'));
    final widget = SettingsWidget(
        title: title, icon: icon, action: action, preventActionOverflow: true);

    // Act
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

    // Assert
    expect(find.text(title), findsOneWidget);
    expect(find.byIcon(Icons.settings), findsOneWidget);
    expect(find.byWidget(action), findsOneWidget);
    final row = find.byType(Row).evaluate().first.widget as Row;
    expect(row.children.length, equals(3));
  });
}
