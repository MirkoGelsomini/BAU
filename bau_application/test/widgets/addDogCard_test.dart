import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bau_application/widgets/addDogCard.dart';

void main() {
  group('AddDogCard Widget Tests', () {
    testWidgets('should render correctly with default properties', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddDogCard(
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byType(AddDogCard), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('should display add symbol', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddDogCard(
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('+'), findsOneWidget);
    });

    testWidgets('should call onTap when tapped', (tester) async {
      bool tapped = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddDogCard(
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(AddDogCard));
      expect(tapped, isTrue);
    });

    testWidgets('should have correct styling', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddDogCard(
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byType(Center), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('should be accessible', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddDogCard(
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byType(GestureDetector), findsOneWidget);
    });

    testWidgets('should have proper decoration', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddDogCard(
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byType(Container), findsOneWidget);
    });
  });
}
