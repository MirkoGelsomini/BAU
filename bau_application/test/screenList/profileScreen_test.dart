import 'package:bau_application/models/user.dart';
import 'package:bau_application/providers/user_provider.dart';
import 'package:bau_application/screenList/profileScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ProfileScreen displays user info correctly', (WidgetTester tester) async {
    final testUser = User(
      id: 1,
      firstName: 'Mario',
      lastName: 'Rossi',
      email: 'mario.rossi@example.com',
      age: 30,
      country: 'Italy',
    );

    final container = ProviderContainer(overrides: [
      userProvider.overrideWith((ref) {
        final notifier = UserProvider();
        notifier.setUser(testUser);
        return notifier;
      }),
    ]);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: ProfileScreen(onLogout: () {}),
        ),
      ),
    );

    expect(find.text('Mario Rossi'), findsOneWidget);
    expect(find.text('Email: mario.rossi@example.com'), findsOneWidget);
    expect(find.text('Age: 30'), findsOneWidget);
    expect(find.text('Country: Italy'), findsOneWidget);
    expect(find.text('Logout'), findsOneWidget);
  });
}
