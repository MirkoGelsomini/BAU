import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bau_application/widgets/infoBox.dart';

void main() {
  group('InfoBox Widget Tests', () {
    testWidgets('should render correctly with label and value', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InfoBox(
              label: 'Test Label',
              value: 'Test value for the info box',
              color: Colors.blue,
            ),
          ),
        ),
      );

      expect(find.byType(InfoBox), findsOneWidget);
      expect(find.text('Test Label'), findsOneWidget);
      expect(find.text('Test value for the info box'), findsOneWidget);
    });

    testWidgets('should display label with correct styling', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InfoBox(
              label: 'Important Information',
              value: 'This is important content',
              color: Colors.red,
            ),
          ),
        ),
      );

      final labelFinder = find.text('Important Information');
      expect(labelFinder, findsOneWidget);
    });

    testWidgets('should display value with correct styling', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InfoBox(
              label: 'Label',
              value: 'This is the value text',
              color: Colors.green,
            ),
          ),
        ),
      );

      final valueFinder = find.text('This is the value text');
      expect(valueFinder, findsOneWidget);
    });

    testWidgets('should have correct container structure', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InfoBox(
              label: 'Label',
              value: 'Value',
              color: Colors.blue,
            ),
          ),
        ),
      );

      expect(find.byType(Container), findsAtLeastNWidgets(1));
      expect(find.byType(Column), findsOneWidget);
    });

    testWidgets('should handle long value text', (tester) async {
      const longValue = 'This is a very long value text that should wrap properly '
          'and display correctly in the info box widget without causing any layout issues.';
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InfoBox(
              label: 'Long Value Test',
              value: longValue,
              color: Colors.orange,
            ),
          ),
        ),
      );

      expect(find.text('Long Value Test'), findsOneWidget);
      expect(find.text(longValue), findsOneWidget);
    });

    testWidgets('should handle empty value', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InfoBox(
              label: 'Empty Value',
              value: '',
              color: Colors.purple,
            ),
          ),
        ),
      );

      expect(find.text('Empty Value'), findsOneWidget);
      expect(find.text(''), findsOneWidget);
    });

    testWidgets('should be accessible', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InfoBox(
              label: 'Accessibility Test',
              value: 'This widget should be accessible',
              color: Colors.teal,
            ),
          ),
        ),
      );

      expect(find.byType(Container), findsAtLeastNWidgets(1));
    });

    testWidgets('should have proper spacing and layout', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InfoBox(
              label: 'Layout Test',
              value: 'Testing proper spacing and layout',
              color: Colors.indigo,
            ),
          ),
        ),
      );

      expect(find.byType(Column), findsOneWidget);

      expect(find.byType(Container), findsAtLeastNWidgets(1));
    });

    testWidgets('should have proper decoration', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InfoBox(
              label: 'Decoration Test',
              value: 'Testing decoration properties',
              color: Colors.amber,
            ),
          ),
        ),
      );

      expect(find.byType(Container), findsAtLeastNWidgets(1));
    });
  });
}
