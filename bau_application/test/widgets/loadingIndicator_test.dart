import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bau_application/widgets/loadingIndicator.dart';

void main() {
  group('LoadingIndicator Widget Tests', () {
    testWidgets('should render correctly with default properties', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoadingIndicator(),
        ),
      );

      expect(find.byType(LoadingIndicator), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should display loading text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoadingIndicator(),
        ),
      );

      expect(find.text('Audio analysis in progress...'), findsOneWidget);
      expect(find.text('Please wait a few seconds...'), findsOneWidget);
    });

    testWidgets('should have correct styling', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoadingIndicator(),
        ),
      );

      expect(find.byType(Center), findsOneWidget);

      expect(find.byType(Column), findsOneWidget);
    });

    testWidgets('should display loading image', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoadingIndicator(),
        ),
      );

      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('should have proper layout structure', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoadingIndicator(),
        ),
      );

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SafeArea), findsOneWidget);
      expect(find.byType(Center), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
    });

    testWidgets('should have proper spacing', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoadingIndicator(),
        ),
      );

      expect(find.byType(SizedBox), findsNWidgets(2));
    });
  });
}
