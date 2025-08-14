import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bau_application/widgets/dogInputOption.dart';
import 'package:bau_application/widgets/iconButtonWithLabel.dart';
import 'package:bau_application/controllers/audio_controller.dart';
import 'package:mocktail/mocktail.dart';

class MockAudioController extends Mock implements AudioController {}

void main() {
  group('DogInputOptions Widget Tests', () {
    late MockAudioController mockAudioController;

    setUp(() {
      mockAudioController = MockAudioController();
      when(() => mockAudioController.isRecording).thenReturn(false);
      when(() => mockAudioController.audioPath).thenReturn('');
      when(() => mockAudioController.isPlaying).thenReturn(false);
    });

    testWidgets('should render correctly with all elements', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DogInputOptions(
              audioController: mockAudioController,
              onUploadPressed: () async {},
            ),
          ),
        ),
      );

      expect(find.byType(DogInputOptions), findsOneWidget);
      expect(find.byType(Column), findsAtLeastNWidgets(1));
    });

    testWidgets('should display record button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DogInputOptions(
              audioController: mockAudioController,
              onUploadPressed: () async {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.mic), findsOneWidget);
    });

    testWidgets('should display upload button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DogInputOptions(
              audioController: mockAudioController,
              onUploadPressed: () async {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.upload_file), findsOneWidget);
    });

    testWidgets('should display correct button text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DogInputOptions(
              audioController: mockAudioController,
              onUploadPressed: () async {},
            ),
          ),
        ),
      );

      expect(find.text('Record audio'), findsOneWidget);
      expect(find.text('Upload file audio'), findsOneWidget);
    });

    testWidgets('should have proper spacing between buttons', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DogInputOptions(
              audioController: mockAudioController,
              onUploadPressed: () async {},
            ),
          ),
        ),
      );

      expect(find.byType(Padding), findsAtLeastNWidgets(1));
    });

    testWidgets('should be accessible', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DogInputOptions(
              audioController: mockAudioController,
              onUploadPressed: () async {},
            ),
          ),
        ),
      );

      expect(find.byType(IconButtonWithLabel), findsNWidgets(2));
    });

    testWidgets('should handle audio controller integration', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DogInputOptions(
              audioController: mockAudioController,
              onUploadPressed: () async {},
            ),
          ),
        ),
      );

      expect(find.byType(DogInputOptions), findsOneWidget);
    });

    testWidgets('should display title text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DogInputOptions(
              audioController: mockAudioController,
              onUploadPressed: () async {},
            ),
          ),
        ),
      );

      expect(find.text('Choose your format'), findsOneWidget);
    });
  });
}
