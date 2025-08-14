import 'package:bau_application/main.dart'; // importa il file con MyApp
import 'package:bau_application/screenList/authScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('MyApp shows AuthScreen as home', (WidgetTester tester) async {

    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(AuthScreen), findsOneWidget);

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
