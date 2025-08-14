import 'package:flutter_test/flutter_test.dart';
import 'package:bau_application/models/dog.dart';

void main() {
  group('Dog model', () {
    test('fromJson should parse correctly', () {
      final json = {
        'id': '123',
        'imageUrl': 'https://example.com/dog.png',
        'name': 'Buddy',
        'breed': 'Beagle',
        'gender': 'female',
        'birthDate': '2020-05-10',
        'weight': 12.5
      };

      final dog = Dog.fromJson(json);

      expect(dog.id, '123');
      expect(dog.imageUrl, 'https://example.com/dog.png');
      expect(dog.name, 'Buddy');
      expect(dog.breed, 'Beagle');
      expect(dog.isFemale, isTrue);
      expect(dog.birthDate, DateTime(2020, 5, 10));
      expect(dog.weight, 12.5);
      expect(dog.isFavorite, isFalse); // di default false
    });

    test('fromJson should use default image if imageUrl is null', () {
      final json = {
        'id': '456',
        'name': 'Max',
        'breed': 'Labrador',
        'gender': 'male',
        'birthDate': '2019-03-15',
        'weight': 30
      };

      final dog = Dog.fromJson(json);

      expect(dog.imageUrl, 'https://picsum.photos/300/200');
    });

    test('toJson should convert correctly', () {
      final dog = Dog(
        id: '789',
        imageUrl: 'https://example.com/dog2.png',
        name: 'Charlie',
        breed: 'Poodle',
        isFemale: false,
        birthDate: DateTime(2021, 7, 20),
        weight: 8.2,
        isFavorite: true,
      );

      final json = dog.toJson();

      expect(json['id'], '789');
      expect(json['name'], 'Charlie');
      expect(json['breed'], 'Poodle');
      expect(json['gender'], 'Male');
      expect(json['birthDate'], '2021-07-20T00:00:00.000');
      expect(json['weight'], 8.2);
    });

    test('copyWith should update only provided fields', () {
      final dog = Dog(
        id: '111',
        imageUrl: 'url1',
        name: 'Luna',
        breed: 'Husky',
        isFemale: true,
        birthDate: DateTime(2018, 1, 1),
        weight: 20,
        isFavorite: false,
      );

      final updatedDog = dog.copyWith(name: 'Bella', weight: 22);

      expect(updatedDog.id, '111');
      expect(updatedDog.name, 'Bella');
      expect(updatedDog.weight, 22);
      expect(updatedDog.breed, 'Husky');
    });
  });
}
