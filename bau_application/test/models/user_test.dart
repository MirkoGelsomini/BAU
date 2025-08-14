import 'package:bau_application/models/dog.dart';
import 'package:bau_application/models/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('User class tests', () {
    final dog = Dog(
      id: '1',
      imageUrl: 'https://picsum.photos/300/200',
      name: 'Fido',
      breed: 'Labrador',
      isFemale: false,
      birthDate: DateTime(2020, 1, 1),
      weight: 25.0,
      isFavorite: true,
    );

    test('User constructor and fields', () {
      final user = User(
        id: 101,
        firstName: 'Mario',
        lastName: 'Rossi',
        age: 30,
        country: 'Italy',
        email: 'mario.rossi@example.com',
        dogs: [dog],
      );

      expect(user.id, 101);
      expect(user.firstName, 'Mario');
      expect(user.lastName, 'Rossi');
      expect(user.age, 30);
      expect(user.country, 'Italy');
      expect(user.email, 'mario.rossi@example.com');
      expect(user.dogs.length, 1);
      expect(user.dogs.first.name, 'Fido');
    });

    test('User copyWith updates fields', () {
      final user = User(
        id: 101,
        firstName: 'Mario',
        lastName: 'Rossi',
        age: 30,
        country: 'Italy',
        email: 'mario.rossi@example.com',
      );

      final updatedUser = user.copyWith(
        firstName: 'Luigi',
        age: 35,
      );

      expect(updatedUser.id, 101);
      expect(updatedUser.firstName, 'Luigi');
      expect(updatedUser.age, 35);
      expect(updatedUser.lastName, 'Rossi'); // unchanged
    });
  });
}
