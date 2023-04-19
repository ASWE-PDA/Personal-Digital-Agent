import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna/Dialogs/delete_dialog.dart';

void main() {
  testWidgets('Delete Dialog test', (WidgetTester tester) async {
    var onPressedWasCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return ElevatedButton(
              onPressed: () {
                showDeleteDialog(context, () {
                  onPressedWasCalled = true;
                });
              },
              child: const Text('Open dialog'),
            );
          },
        ),
      ),
    );

    // Tap the button to open the dialog
    await tester.tap(find.text('Open dialog'));
    await tester.pumpAndSettle();

    // Verify that the dialog is displayed
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Delete shared preferences'), findsOneWidget);
    expect(find.text('Are you sure you want to delete all shared preferences?'),
        findsOneWidget);
    expect(find.text('Yes'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);

    // Tap the "Yes" button to trigger the onPressed callback
    await tester.tap(find.text('Yes'));
    await tester.pumpAndSettle();

    // Verify that the onPressed callback was called
    expect(onPressedWasCalled, isTrue);
  });

  testWidgets('Test cancel dialog', (WidgetTester tester) async {
    var onPressedWasCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return ElevatedButton(
              onPressed: () {
                showDeleteDialog(context, () {
                  onPressedWasCalled = true;
                });
              },
              child: const Text('Open dialog'),
            );
          },
        ),
      ),
    );

    // Tap the button to open the dialog
    await tester.tap(find.text('Open dialog'));
    await tester.pumpAndSettle();

    // Verify that the dialog is displayed
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Delete shared preferences'), findsOneWidget);
    expect(find.text('Are you sure you want to delete all shared preferences?'),
        findsOneWidget);
    expect(find.text('Yes'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);

    // Tap the "Yes" button to trigger the onPressed callback
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    // Verify that the onPressed callback was called
    expect(onPressedWasCalled, isFalse);
  });
}
