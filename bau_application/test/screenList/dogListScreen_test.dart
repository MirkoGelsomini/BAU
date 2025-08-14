import 'package:bau_application/models/user.dart';
import 'package:bau_application/widgets/addDogCard.dart';
import 'package:bau_application/widgets/dogCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bau_application/screenList/dogListScreen.dart';
import 'package:bau_application/providers/dog_provider.dart';
import 'package:bau_application/providers/user_provider.dart';
import 'package:bau_application/models/dog.dart';
import 'package:bau_application/models/dogState.dart';
import 'package:bau_application/controllers/dogs_controller.dart';
import 'package:bau_application/controllers/info_controller.dart';
import 'package:mocktail/mocktail.dart';

// Mock Controllers
class MockDogsController extends Mock implements DogsController {}
class MockInfoController extends Mock implements InfoController {}

// Mock UserNotifier
class MockUserNotifier extends StateNotifier<User?> {
  MockUserNotifier(User? initialUser) : super(initialUser);
}

void main() {
  group('DogListScreen Tests', () {
    late MockDogsController mockDogsController;
    late MockInfoController mockInfoController;
    late Dog testDog;
    late DogState testDogState;
    late User testUser;

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
        selected: null,
      );

      testUser = User(
        id: 1,
        firstName: 'Test',
        lastName: 'User',
        age: 30,
        country: 'IT',
        email: 'test@example.com',
        dogs: [testDog],
      );

      when(() => mockDogsController.fetchDogs(any()))
          .thenAnswer((_) async => [testDog]);
      when(() => mockInfoController.getBreedImage(any()))
          .thenAnswer((_) async => 'assets/images/dogs/chihuahua_image.png');
    });

    testWidgets('renders DogListScreen with user and dogs', (tester) async {
      final mockDogNotifier = DogNotifier(
        controller: mockDogsController,
        infoController: mockInfoController,
      );
      mockDogNotifier.state = testDogState;

      final testUserNotifier = UserProvider();
      testUserNotifier.setUser(testUser);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userProvider.overrideWith((ref) => testUserNotifier),
            dogProvider.overrideWith((ref) => mockDogNotifier),
          ],
          child: const MaterialApp(home: DogListScreen()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(DogListScreen), findsOneWidget);
      expect(find.text('Your pets'), findsOneWidget);
      expect(find.byType(DogCard), findsOneWidget);
      expect(find.byType(AddDogCard), findsOneWidget);
    });

    testWidgets('renders empty dog list properly', (tester) async {
      final emptyUser = User(
        id: 1,
        firstName: 'Test',
        lastName: 'User',
        age: 30,
        country: 'IT',
        email: 'test@example.com',
        dogs: [],
      );

      final testUserNotifier = UserProvider();
      testUserNotifier.setUser(emptyUser);

      final mockDogNotifier = DogNotifier(
        controller: mockDogsController,
        infoController: mockInfoController,
      );
      mockDogNotifier.state = DogState(dogs: [], selected: null);

      // IMPORTANT: forza il fetch vuoto
      when(() => mockDogsController.fetchDogs(any()))
          .thenAnswer((_) async => []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userProvider.overrideWith((ref) => testUserNotifier),
            dogProvider.overrideWith((ref) => mockDogNotifier),
          ],
          child: const MaterialApp(home: DogListScreen()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(DogListScreen), findsOneWidget);
      expect(find.byType(DogCard), findsNothing); // nessun cane
      expect(find.byType(AddDogCard), findsOneWidget); // c’è sempre AddDogCard
    });
  });
}
