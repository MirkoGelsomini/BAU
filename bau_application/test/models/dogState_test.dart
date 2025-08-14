import 'package:bau_application/models/dog.dart';
import 'package:bau_application/models/dogState.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DogState', () {
    final dog1 = Dog(
      id: '1',
      imageUrl: 'url1',
      name: 'Buddy',
      breed: 'Beagle',
      isFemale: true,
      birthDate: DateTime(2020, 1, 1),
      weight: 10,
      isFavorite: false,
    );

    final dog2 = Dog(
      id: '2',
      imageUrl: 'url2',
      name: 'Max',
      breed: 'Labrador',
      isFemale: false,
      birthDate: DateTime(2019, 5, 10),
      weight: 20,
      isFavorite: true,
    );

    test('should create initial state correctly', () {
      final state = DogState(dogs: [dog1, dog2], selected: dog1);

      expect(state.dogs.length, 2);
      expect(state.selected, dog1);
    });

    test('copyWith should update dogs list', () {
      final state = DogState(dogs: [dog1], selected: dog1);
      final newState = state.copyWith(dogs: [dog2]);

      expect(newState.dogs.length, 1);
      expect(newState.dogs.first, dog2);
      expect(newState.selected, dog1);
    });

    test('copyWith should update selected dog', () {
      final state = DogState(dogs: [dog1, dog2], selected: dog1);
      final newState = state.copyWith(selected: dog2);

      expect(newState.selected, dog2);
      expect(newState.dogs, state.dogs);
    });

    test('copyWith should not change anything if no arguments', () {
      final state = DogState(dogs: [dog1], selected: dog1);
      final newState = state.copyWith();

      expect(newState.dogs, state.dogs);
      expect(newState.selected, state.selected);
    });
  });
}
