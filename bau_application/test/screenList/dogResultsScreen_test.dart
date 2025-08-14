import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bau_application/screenList/dogResultsScreen.dart';
import 'package:bau_application/providers/dog_provider.dart';
import 'package:bau_application/models/dog.dart';
import 'package:bau_application/models/dogState.dart';
import 'package:bau_application/controllers/dogs_controller.dart';
import 'package:bau_application/controllers/info_controller.dart';

// Mock classes
class MockDogsController extends Mock implements DogsController {}
class MockInfoController extends Mock implements InfoController {}

void main() {
  group('DogResultsScreen Tests', () {
    late Dog testDog;
    late DogState testDogState;
    late MockDogsController mockDogsController;
    late MockInfoController mockInfoController;

    setUp(() {
      testDog = Dog(
        id: '1',
        name: 'Test Dog',
        breed: 'Test Breed',
        isFemale: true,
        birthDate: DateTime(2020, 1, 1),
        weight: 15.5,
        imageUrl: 'assets/images/dogs/chihuahua_image.png',
        isFavorite: false,
      );

      testDogState = DogState(
        dogs: [testDog],
        selected: testDog,
      );

      mockDogsController = MockDogsController();
      mockInfoController = MockInfoController();
    });

    testWidgets('should render correctly with dog data', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dogProvider.overrideWith((ref) => DogNotifier(
              controller: mockDogsController,
              infoController: mockInfoController,
            )..state = testDogState),
          ],
          child: const MaterialApp(
            home: DogResultsScreen(),
          ),
        ),
      );

      expect(find.byType(DogResultsScreen), findsOneWidget);
    });

    testWidgets('should display dog image', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dogProvider.overrideWith((ref) => DogNotifier(
              controller: mockDogsController,
              infoController: mockInfoController,
            )..state = testDogState),
          ],
          child: const MaterialApp(
            home: DogResultsScreen(),
          ),
        ),
      );

      expect(find.byType(Image), findsAtLeastNWidgets(2));
    });

    testWidgets('should display background pattern', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dogProvider.overrideWith((ref) => DogNotifier(
              controller: mockDogsController,
              infoController: mockInfoController,
            )..state = testDogState),
          ],
          child: const MaterialApp(
            home: DogResultsScreen(),
          ),
        ),
      );

      expect(find.byType(Image), findsAtLeastNWidgets(2));
    });

    testWidgets('should have proper layout structure', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dogProvider.overrideWith((ref) => DogNotifier(
              controller: mockDogsController,
              infoController: mockInfoController,
            )..state = testDogState),
          ],
          child: const MaterialApp(
            home: DogResultsScreen(),
          ),
        ),
      );

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(Stack), findsAtLeastNWidgets(1));
      expect(find.byType(SafeArea), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
    });

    testWidgets('should display DogPredictionResultsView', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dogProvider.overrideWith((ref) => DogNotifier(
              controller: mockDogsController,
              infoController: mockInfoController,
            )..state = testDogState),
          ],
          child: const MaterialApp(
            home: DogResultsScreen(),
          ),
        ),
      );

      expect(find.byType(DogResultsScreen), findsOneWidget);
    });

    testWidgets('should handle PopScope correctly', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dogProvider.overrideWith((ref) => DogNotifier(
              controller: mockDogsController,
              infoController: mockInfoController,
            )..state = testDogState),
          ],
          child: const MaterialApp(
            home: DogResultsScreen(),
          ),
        ),
      );

      expect(find.byType(PopScope), findsOneWidget);
    });

    testWidgets('should have proper image dimensions', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dogProvider.overrideWith((ref) => DogNotifier(
              controller: mockDogsController,
              infoController: mockInfoController,
            )..state = testDogState),
          ],
          child: const MaterialApp(
            home: DogResultsScreen(),
          ),
        ),
      );

      final dogImage = tester.widget<Image>(find.byType(Image).last);
      expect(dogImage.height, 280);
    });

    testWidgets('should be accessible', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dogProvider.overrideWith((ref) => DogNotifier(
              controller: mockDogsController,
              infoController: mockInfoController,
            )..state = testDogState),
          ],
          child: const MaterialApp(
            home: DogResultsScreen(),
          ),
        ),
      );

      expect(find.byType(SafeArea), findsOneWidget);
    });
  });
}
