import 'package:bau_application/screenList/authScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('AuthScreen Widget Tests', () {
    testWidgets('Initial login form shows email and password', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: AuthScreen()));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text("Don't have an account? Sign up"), findsOneWidget);
    });

    testWidgets('Toggle to registration shows additional fields', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: AuthScreen()));
      await tester.pumpAndSettle();

      await tester.tap(find.text("Don't have an account? Sign up"));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsNWidgets(6));
      expect(find.text('First Name'), findsOneWidget);
      expect(find.text('Last Name'), findsOneWidget);
      expect(find.text('Age'), findsOneWidget);
      expect(find.text('Country'), findsOneWidget);
      expect(find.text('Sign Up'), findsOneWidget);
      expect(find.text("Already have an account? Login"), findsOneWidget);
    });

    testWidgets('Toggle back to login works', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: AuthScreen()));
      await tester.pumpAndSettle();

      await tester.tap(find.text("Don't have an account? Sign up"));
      await tester.pumpAndSettle();

      final loginText = find.text("Already have an account? Login");
      await tester.ensureVisible(loginText);
      await tester.tap(loginText);
      await tester.pumpAndSettle();

      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('First Name'), findsNothing);
      expect(find.text('Last Name'), findsNothing);
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('Submit button disabled during loading', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: AuthScreen()));
      await tester.pumpAndSettle();

      final loginButton = find.widgetWithText(ElevatedButton, 'Login');
      expect(loginButton, findsOneWidget);

      await tester.runAsync(() async {
        final authScreenState = tester.state(find.byType(AuthScreen)) as dynamic;
        authScreenState.setState(() {
          authScreenState.isLoading = true;
        });
      });

      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      final buttonWidget = tester.widget<ElevatedButton>(loginButton);
      expect(buttonWidget.onPressed, isNull);
    });
  });
}
