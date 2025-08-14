import 'package:bau_application/controllers/dogs_controller.dart';
import 'package:bau_application/controllers/info_controller.dart';
import 'package:bau_application/screenList/dogDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bau_application/providers/user_provider.dart';
import 'package:bau_application/providers/dog_provider.dart';
import 'package:bau_application/models/user.dart';
import 'package:bau_application/models/dog.dart';
import 'package:bau_application/models/dogState.dart';

class TestDogNotifier extends DogNotifier {
  TestDogNotifier() : super(controller: DummyController(), infoController: DummyInfoController()) {
    final dog = Dog(
      id: 'd1',
      name: 'Fido',
      breed: 'chihuahua',
      isFemale: false,
      birthDate: DateTime(2020, 5, 20),
      weight: 15.0,
      isFavorite: false,
      imageUrl: 'assets/images/dogs/chihuahua_image.png',
    );

    state = DogState(
      dogs: [dog],
      selected: dog,
    );
  }
}

class TestUserProvider extends UserProvider {
  TestUserProvider() {
    setUser(User(
      id: 1,
      firstName: 'John',
      lastName: 'Doe',
      age: 30,
      country: 'Italy',
      email: 'john@example.com',
      dogs: [],
    ));
  }
}

class DummyController extends DogsController {
  DummyController() : super(baseUrl: '');
}
class DummyInfoController extends InfoController {
  DummyInfoController() : super(baseUrl: '');
}

void main() {
  testWidgets('DogDetailsScreen displays dog info and action buttons', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userProvider.overrideWith((ref) => TestUserProvider()),
          dogProvider.overrideWith((ref) => TestDogNotifier()),
        ],
        child: const MaterialApp(home: DogDetailsScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(Image), findsWidgets);

    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.byIcon(Icons.edit), findsOneWidget);
    expect(find.byIcon(Icons.delete), findsOneWidget);
  });
}

