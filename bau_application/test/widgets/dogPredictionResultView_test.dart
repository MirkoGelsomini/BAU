import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bau_application/widgets/dogPredictionResultView.dart';
import 'package:bau_application/providers/dog_provider.dart';
import 'package:bau_application/providers/prediction_provider.dart';
import 'package:bau_application/models/dog.dart';
import 'package:bau_application/models/dogState.dart';
import 'package:bau_application/models/predictionResult.dart';
import 'package:bau_application/controllers/dogs_controller.dart';
import 'package:bau_application/controllers/info_controller.dart';
import 'package:mocktail/mocktail.dart';

class MockDogsController extends Mock implements DogsController {}
class MockInfoController extends Mock implements InfoController {}

void main() {
  group('DogPredictionResultsView Widget Tests', () {
    late MockDogsController mockDogsController;
    late MockInfoController mockInfoController;
    late Dog testDog;
    late DogState testDogState;
    late PredictionResult testResult;

    setUp(() {
      mockDogsController = MockDogsController();
      mockInfoController = MockInfoController();
      
      testDog = Dog(
        id: '1',
        imageUrl: 'assets/images/dogs/chihuahua_image.png',
        name: 'Buddy',
        breed: 'Labrador',
        isFemale: false,
        birthDate: DateTime(2020, 1, 1),
        weight: 25.0,
        isFavorite: false,
      );
      
      testDogState = DogState(
        dogs: [testDog],
        selected: testDog,
      );

      testResult = PredictionResult(
        transactionId: 123,
        predictions: [
          Prediction(
            label: 'Happy',
            confidence: 0.85,
            description: 'A happy dog',
            labelsByLanguage: {'en': 'Happy', 'it': 'Felice'},
          ),
        ],
      );
    });

    testWidgets('should render correctly', (tester) async {
      final mockDogNotifier = DogNotifier(
        controller: mockDogsController,
        infoController: mockInfoController,
      );
      mockDogNotifier.state = testDogState;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dogProvider.overrideWith((ref) => mockDogNotifier),
            predictionProvider.overrideWith((ref) => testResult),
          ],
          child: const MaterialApp(
            home: DogPredictionResultsView(),
          ),
        ),
      );

      expect(find.byType(DogPredictionResultsView), findsOneWidget);
    });

    testWidgets('should display prediction result', (tester) async {
      final mockDogNotifier = DogNotifier(
        controller: mockDogsController,
        infoController: mockInfoController,
      );
      mockDogNotifier.state = testDogState;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dogProvider.overrideWith((ref) => mockDogNotifier),
            predictionProvider.overrideWith((ref) => testResult),
          ],
          child: const MaterialApp(
            home: DogPredictionResultsView(),
          ),
        ),
      );

      expect(find.byType(DogPredictionResultsView), findsOneWidget);
    });

    testWidgets('should have proper layout structure', (tester) async {
      final mockDogNotifier = DogNotifier(
        controller: mockDogsController,
        infoController: mockInfoController,
      );
      mockDogNotifier.state = testDogState;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dogProvider.overrideWith((ref) => mockDogNotifier),
            predictionProvider.overrideWith((ref) => testResult),
          ],
          child: const MaterialApp(
            home: DogPredictionResultsView(),
          ),
        ),
      );

      expect(find.byType(Column), findsAtLeastNWidgets(1));

      expect(find.byType(Padding), findsAtLeastNWidgets(1));
    });

    testWidgets('should handle null prediction result', (tester) async {
      final mockDogNotifier = DogNotifier(
        controller: mockDogsController,
        infoController: mockInfoController,
      );
      mockDogNotifier.state = testDogState;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dogProvider.overrideWith((ref) => mockDogNotifier),
            predictionProvider.overrideWith((ref) => null),
          ],
          child: const MaterialApp(
            home: DogPredictionResultsView(),
          ),
        ),
      );

      expect(find.byType(DogPredictionResultsView), findsOneWidget);
    });

    testWidgets('should be accessible', (tester) async {
      final mockDogNotifier = DogNotifier(
        controller: mockDogsController,
        infoController: mockInfoController,
      );
      mockDogNotifier.state = testDogState;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dogProvider.overrideWith((ref) => mockDogNotifier),
            predictionProvider.overrideWith((ref) => testResult),
          ],
          child: const MaterialApp(
            home: DogPredictionResultsView(),
          ),
        ),
      );

      expect(find.byType(SafeArea), findsOneWidget);
    });

    testWidgets('should display feedback form', (tester) async {
      final mockDogNotifier = DogNotifier(
        controller: mockDogsController,
        infoController: mockInfoController,
      );
      mockDogNotifier.state = testDogState;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dogProvider.overrideWith((ref) => mockDogNotifier),
            predictionProvider.overrideWith((ref) => testResult),
          ],
          child: const MaterialApp(
            home: DogPredictionResultsView(),
          ),
        ),
      );

      expect(find.byType(DogPredictionResultsView), findsOneWidget);
    });
  });
}
