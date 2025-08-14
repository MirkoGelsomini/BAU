import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bau_application/screenList/greetingsScreen.dart';

void main() {
  group('ThankYouScreen Tests', () {
    testWidgets('should render correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ThankYouScreen(enableAutoNavigation: false)
        ),
      );

      expect(find.byType(ThankYouScreen), findsOneWidget);
    });

    testWidgets('should display thank you text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ThankYouScreen(enableAutoNavigation: false),
        ),
      );

      expect(find.text('Thank you for the feedback!'), findsOneWidget);
    });

    testWidgets('should display thank you dog gif', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ThankYouScreen(enableAutoNavigation: false),
        ),
      );

      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('should have proper layout structure', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ThankYouScreen(enableAutoNavigation: false),
        ),
      );

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(PopScope), findsOneWidget);
      expect(find.byType(Center), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
    });

    testWidgets('should have PopScope with canPop false', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ThankYouScreen(enableAutoNavigation: false),
        ),
      );

      final popScope = tester.widget<PopScope>(find.byType(PopScope));
      expect(popScope.canPop, false);
    });

    testWidgets('should have white background', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ThankYouScreen(enableAutoNavigation: false),
        ),
      );

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, Colors.white);
    });

    testWidgets('should have proper image dimensions', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ThankYouScreen(enableAutoNavigation: false),
        ),
      );

      final image = tester.widget<Image>(find.byType(Image));
      expect(image.height, 150);
      expect(image.width, 150);
    });

    testWidgets('should have proper text styling', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ThankYouScreen(enableAutoNavigation: false),
        ),
      );

      final text = tester.widget<Text>(find.text('Thank you for the feedback!'));
      expect(text.style?.fontSize, 24);
      expect(text.style?.fontWeight, FontWeight.bold);
      expect(text.style?.color, Colors.black87);
      expect(text.textAlign, TextAlign.center);
    });

    testWidgets('should have proper spacing', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ThankYouScreen(enableAutoNavigation: false),
        ),
      );

      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('should be accessible', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ThankYouScreen(enableAutoNavigation: false),
        ),
      );

      expect(find.byType(SafeArea), findsNothing);
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
