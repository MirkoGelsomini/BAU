import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:bau_application/controllers/dogs_controller.dart';
import 'package:bau_application/models/dog.dart';

void main() {
  group('DogsController tests', () {
    late DogsController dogsController;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient((request) async {
        final path = request.url.path;
        final query = request.url.queryParameters;

        if (path.endsWith('/get') && query['userId'] == '1') {
          return http.Response(jsonEncode({
            'dogs': [
              {
                'id': 'dog1',
                'name': 'Fido',
                'breed': 'Labrador',
                'gender': 'Male',
                'birthDate': '2021-01-01',
                'weight': 10.0,
                'isFavorite': false,
                'imageUrl': ''
              }
            ]
          }), 200);
        }

        if (path.endsWith('/add')) {
          final body = jsonDecode(request.body);
          return http.Response(jsonEncode({
            'dog': {
              'id': 'newdog',
              'name': body['name'],
              'breed': body['breed'],
              'gender': body['gender'],
              'birthDate': body['birthDate'].substring(0, 10),
              'weight': body['weight'],
              'isFavorite': body['isFavorite'] ?? false,
              'imageUrl': body['imageUrl'] ?? ''
            }
          }), 201);
        }

        if (path.endsWith('/edit')) {
          final body = jsonDecode(request.body);
          return http.Response(jsonEncode({
            'dog': {
              'id': body['id'],
              'name': body['name'],
              'breed': body['breed'],
              'gender': body['gender'],
              'birthDate': body['birthDate'].substring(0, 10),
              'weight': body['weight'],
              'isFavorite': body['isFavorite'] ?? false,
              'imageUrl': body['imageUrl'] ?? ''
            }
          }), 200);
        }

        if (path.endsWith('/delete') && query['dogId'] == 'dog1') {
          return http.Response('', 200);
        }

        return http.Response('Not Found', 404);
      });

      dogsController = DogsController(
        baseUrl: 'http://fake-server.com',
        client: mockClient,
      );
    });

    test('fetchDogs returns list of dogs', () async {
      final dogs = await dogsController.fetchDogs('1');
      expect(dogs, isA<List<Dog>>());
      expect(dogs.length, 1);
      expect(dogs.first.name, 'Fido');
      expect(dogs.first.birthDate.year, 2021);
    });

    test('addDog returns added dog', () async {
      final newDog = Dog(
        id: '',
        name: 'Buddy',
        breed: 'Beagle',
        imageUrl: '',
        isFemale: false,
        birthDate: DateTime.parse('2022-01-01'),
        weight: 8.5,
        isFavorite: true,
      );
      final addedDog = await dogsController.addDog(newDog, '1');
      expect(addedDog.id, 'newdog');
      expect(addedDog.name, 'Buddy');
      expect(addedDog.birthDate.toIso8601String(), '2022-01-01T00:00:00.000');
    });

    test('updateDog returns updated dog', () async {
      final dog = Dog(
        id: 'dog1',
        name: 'Max',
        breed: 'Labrador',
        imageUrl: '',
        isFemale: false,
        birthDate: DateTime.parse('2020-05-01'),
        weight: 12.0,
        isFavorite: false,
      );
      final updatedDog = await dogsController.updateDog(dog, '1');
      expect(updatedDog.id, 'dog1');
      expect(updatedDog.name, 'Max');
      expect(updatedDog.birthDate.toIso8601String(), '2020-05-01T00:00:00.000');
    });

    test('deleteDog completes successfully', () async {
      await dogsController.deleteDog('dog1', '1');
    });
  });
}
