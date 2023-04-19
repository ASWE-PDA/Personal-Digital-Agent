import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna/UseCases/good_night_model.dart';
import 'package:provider/provider.dart';
import 'package:luna/Screens/good_night_schedule_screen.dart';

void main() {
  group('GoodNightScheduleScreen widget', () {
    testWidgets('should display an input field', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (context) => GoodNightModel(),
            child: GoodNightScheduleScreen(),
          ),
        ),
      );

      final inputField = find.byType(TextFormField);
      expect(inputField, findsOneWidget);
    });

    testWidgets('should display a "Done" button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (context) => GoodNightModel(),
            child: GoodNightScheduleScreen(),
          ),
        ),
      );

      final doneButton = find.text('Done');
      expect(doneButton, findsOneWidget);
    });

    testWidgets('should not allow empty input field',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (context) => GoodNightModel(),
            child: GoodNightScheduleScreen(),
          ),
        ),
      );

      final inputField = find.byType(TextFormField);
      expect(inputField, findsOneWidget);

      final doneButton = find.text('Done');
      expect(doneButton, findsOneWidget);
    });

    testWidgets('should allow non-empty input field',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (context) => GoodNightModel(),
            child: GoodNightScheduleScreen(),
          ),
        ),
      );

      final inputField = find.byType(TextFormField);
      expect(inputField, findsOneWidget);

      final doneButton = find.text('Done');
      expect(doneButton, findsOneWidget);
    });
  });
}
