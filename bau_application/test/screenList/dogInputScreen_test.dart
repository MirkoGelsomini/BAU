import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bau_application/screenList/dogInputScreen.dart';
import 'package:bau_application/widgets/loadingIndicator.dart';
import 'package:bau_application/widgets/dogInputOption.dart';
import 'package:bau_application/providers/loading_provider.dart';
import 'package:bau_application/providers/dog_provider.dart';
import 'package:bau_application/providers/prediction_provider.dart';
import 'package:bau_application/models/dog.dart';
import 'package:bau_application/controllers/dogs_controller.dart';
import 'package:bau_application/controllers/info_controller.dart';
import 'package:mocktail/mocktail.dart';

class MockDogsController extends Mock implements DogsController {}
class MockInfoController extends Mock implements InfoController {}

void main() {
  late MockDogsController mockDogsController;
  late MockInfoController mockInfoController;
  late Dog testDog;

  setUp(() {
    mockDogsController = MockDogsController();
    mockInfoController = MockInfoController();

    testDog = Dog(
      id: '1',
      imageUrl: 'assets/images/dogs/chihuahua_image.png',
      name: 'TestDog',
      breed: 'Labrador',
      isFemale: false,
      birthDate: DateTime(2020, 1, 1),
      weight: 25.0,
      isFavorite: false,
    );
  });

  testWidgets('Displays LoadingIndicator when isLoadingProvider is true', (tester) async {
    final mockDogNotifier = DogNotifier(
      controller: mockDogsController,
      infoController: mockInfoController,
    );
    mockDogNotifier.selectDog(testDog);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          isLoadingProvider.overrideWith((ref) => true),
          dogProvider.overrideWith((ref) => mockDogNotifier),
          predictionProvider.overrideWith((ref) => null),
        ],
        child: const MaterialApp(home: DogInputScreen()),
      ),
    );

    expect(find.byType(LoadingIndicator), findsOneWidget);
    expect(find.byType(DogInputOptions), findsNothing);
  });

  testWidgets('Displays DogInputOptions when isLoadingProvider is false', (tester) async {
    final mockDogNotifier = DogNotifier(
      controller: mockDogsController,
      infoController: mockInfoController,
    );
    mockDogNotifier.selectDog(testDog);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          isLoadingProvider.overrideWith((ref) => false),
          dogProvider.overrideWith((ref) => mockDogNotifier),
          predictionProvider.overrideWith((ref) => null),
        ],
        child: const MaterialApp(home: DogInputScreen()),
      ),
    );

    expect(find.byType(DogInputOptions), findsOneWidget);
    expect(find.byType(LoadingIndicator), findsNothing);
  });
}
