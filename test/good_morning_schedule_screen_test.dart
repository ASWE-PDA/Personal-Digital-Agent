import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna/Screens/good_morning_schedule_screen.dart';
import 'package:luna/UseCases/good_morning_model.dart';
import 'package:provider/provider.dart';

void main() {
  group('GoodMorningScheduleScreen widget', () {
    testWidgets('should display the title', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (context) => GoodMorningModel(),
            child: GoodMorningScheduleScreen(),
          ),
        ),
      );

      final settingsHeadline = find.text('Good Morning Settings');
      expect(settingsHeadline, findsOneWidget);
    });

    testWidgets('should display wake-up time text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (context) => GoodMorningModel(),
            child: GoodMorningScheduleScreen(),
          ),
        ),
      );

      final wakeUpText = find.text('Preferred wake-up time:');
      expect(wakeUpText, findsOneWidget);
    });

    testWidgets('should display arrival time text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (context) => GoodMorningModel(),
            child: GoodMorningScheduleScreen(),
          ),
        ),
      );

      final wakeUpText = find.text('Preferred arrival time at work:');
      expect(wakeUpText, findsOneWidget);
    });
  });
}
