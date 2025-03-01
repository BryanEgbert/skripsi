// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:frontend/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Login should not return error on success',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ProviderScope(
        child: PetDaycareApp(),
      ),
    );

    // Verify that our counter starts at 0.
    expect(find.byKey(Key("email-input")), findsOneWidget);
    expect(find.byKey(Key("password-input")), findsOneWidget);

    // Tap the '+' icon and trigger a frame.
    await tester.enterText(find.byKey(Key("email-input")), "jane@example.com");
    await tester.enterText(find.byKey(Key("password-input")), "test");
    await tester.tap(find.byKey(Key("submit-btn")));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text("Invalid email or password"), findsNothing);
  });

  testWidgets('Login should return error on success',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ProviderScope(
        child: PetDaycareApp(),
      ),
    );

    // Verify that our counter starts at 0.
    expect(find.byKey(Key("email-input")), findsOneWidget);
    expect(find.byKey(Key("password-input")), findsOneWidget);

    // Tap the '+' icon and trigger a frame.
    await tester.enterText(
        find.byKey(Key("email-input")), "invalid@example.com");
    await tester.enterText(find.byKey(Key("password-input")), "test");
    await tester.tap(find.byKey(Key("submit-btn")));
    await tester.pump(Duration(seconds: 3));

    // Verify that our counter has incremented.
    expect(find.text("Invalid email or password"), findsOneWidget);
  });
}
