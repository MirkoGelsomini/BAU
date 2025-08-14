import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bau_application/widgets/iconButtonWithLabel.dart';

void main() {
  group('IconButtonWithLabel Widget Tests', () {
    testWidgets('should render correctly with all properties', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IconButtonWithLabel(
              icon: const Icon(Icons.play_arrow),
              label: 'Play',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byType(IconButtonWithLabel), findsOneWidget);
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
      expect(find.text('Play'), findsOneWidget);
    });

    testWidgets('should call onPressed when button is tapped', (tester) async {
      bool pressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IconButtonWithLabel(
              icon: const Icon(Icons.stop),
              label: 'Stop',
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(IconButton));
      expect(pressed, isTrue);
    });

    testWidgets('should display correct icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IconButtonWithLabel(
              icon: const Icon(Icons.pause),
              label: 'Pause',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.pause), findsOneWidget);
    });

    testWidgets('should display correct label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IconButtonWithLabel(
              icon: const Icon(Icons.record_voice_over),
              label: 'Record',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Record'), findsOneWidget);
    });

    testWidgets('should have correct styling structure', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IconButtonWithLabel(
              icon: const Icon(Icons.mic),
              label: 'Microphone',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byType(Column), findsOneWidget);

      expect(find.byType(IconButton), findsOneWidget);
    });

    testWidgets('should be accessible', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IconButtonWithLabel(
              icon: const Icon(Icons.volume_up),
              label: 'Volume',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byType(IconButton), findsOneWidget);
    });

    testWidgets('should handle null onPressed', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IconButtonWithLabel(
              icon: const Icon(Icons.info),
              label: 'Info',
              onPressed: null,
            ),
          ),
        ),
      );

      expect(find.byType(IconButtonWithLabel), findsOneWidget);
      final iconButton = tester.widget<IconButton>(find.byType(IconButton));
      expect(iconButton.onPressed, isNull);
    });

    testWidgets('should have proper spacing', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IconButtonWithLabel(
              icon: const Icon(Icons.add),
              label: 'Add',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byType(SizedBox), findsAtLeastNWidgets(1));
    });
  });
}
