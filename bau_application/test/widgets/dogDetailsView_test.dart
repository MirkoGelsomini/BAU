import 'package:bau_application/widgets/dogDetailsView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bau_application/models/dog.dart';
import 'package:bau_application/models/dogState.dart';
import 'package:bau_application/providers/dog_provider.dart';
import 'package:bau_application/controllers/dogs_controller.dart';
import 'package:bau_application/controllers/info_controller.dart';
import 'package:bau_application/widgets/infoBox.dart';

// Mock controllers
class MockDogsController extends Mock implements DogsController {}
class MockInfoController extends Mock implements InfoController {}

void main() {
  group('DogDetailsView Tests', () {
    late MockDogsController mockDogsController;
    late MockInfoController mockInfoController;
    late Dog testDog;
    late DogState testDogState;

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

      testDogState = DogState(dogs: [testDog], selected: testDog);
    });

    testWidgets('renders DogDetailsView with correct widgets', (tester) async {
      final dogNotifier = DogNotifier(
        controller: mockDogsController,
        infoController: mockInfoController,
      );
      dogNotifier.state = testDogState;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dogProvider.overrideWith((ref) => dogNotifier),
          ],
          child: const MaterialApp(
            home: DogDetailsView(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text(testDog.name), findsOneWidget);
      expect(find.text(testDog.breed), findsOneWidget);

      expect(find.byType(InfoBox), findsNWidgets(3));
      expect(find.text('Age'), findsOneWidget);
      expect(find.text('Gender'), findsOneWidget);
      expect(find.text('Weight'), findsOneWidget);

      expect(find.text('What is ${testDog.name} saying?'), findsOneWidget);
      expect(find.byType(GestureDetector), findsOneWidget);
    });
  });
}
