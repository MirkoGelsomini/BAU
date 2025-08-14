import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bau_application/providers/user_provider.dart';
import 'package:bau_application/models/user.dart';
import 'package:bau_application/models/dog.dart';

void main() {
  test('userProvider starts as null and can be updated/cleared', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(userProvider), null);

    final dog = Dog(
      id: '1',
      name: 'Fido',
      breed: 'Labrador',
      birthDate: DateTime(2020, 1, 1),
      weight: 20.0,
      isFemale: false,
      isFavorite: false,
      imageUrl: '',
    );

    final user = User(
      id: 1,
      firstName: 'John',
      lastName: 'Doe',
      age: 30,
      country: 'USA',
      email: 'john@example.com',
      dogs: [dog],
    );

    container.read(userProvider.notifier).setUser(user);

    final state = container.read(userProvider);
    expect(state, isNotNull);
    expect(state!.id, 1);
    expect(state.firstName, 'John');
    expect(state.dogs.length, 1);
    expect(state.dogs.first.name, 'Fido');

    container.read(userProvider.notifier).clearUser();
    expect(container.read(userProvider), null);
  });
}
