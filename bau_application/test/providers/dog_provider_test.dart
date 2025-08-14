import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bau_application/controllers/dogs_controller.dart';
import 'package:bau_application/controllers/info_controller.dart';
import 'package:bau_application/models/dog.dart';
import 'package:bau_application/models/dogState.dart';
import 'package:bau_application/providers/dog_provider.dart';

class MockDogsController extends Mock implements DogsController {}
class MockInfoController extends Mock implements InfoController {}
class FakeDog extends Fake implements Dog {}

void main() {
  late MockDogsController mockDogsController;
  late MockInfoController mockInfoController;
  late DogNotifier notifier;

  setUpAll(() {
    registerFallbackValue(FakeDog());
  });

  setUp(() {
    mockDogsController = MockDogsController();
    mockInfoController = MockInfoController();
    notifier = DogNotifier(
      controller: mockDogsController,
      infoController: mockInfoController,
    );
  });

  final dog = Dog(
    id: '1',
    imageUrl: '',
    name: 'Fido',
    breed: 'Labrador',
    isFemale: false,
    birthDate: DateTime(2020, 1, 1),
    weight: 20.0,
    isFavorite: false,
  );

  group('DogNotifier', () {
    test('loadDogs sets state with enriched dogs', () async {
      when(() => mockDogsController.fetchDogs('123'))
          .thenAnswer((_) async => [dog]);
      when(() => mockInfoController.getBreedImage('Labrador'))
          .thenAnswer((_) async => 'assets/images/dogs/labrador.png');

      await notifier.loadDogs(123);

      expect(notifier.state.dogs.length, 1);
      expect(notifier.state.dogs.first.imageUrl, 'assets/images/dogs/labrador.png');
    });

    test('reloadDogs calls loadDogs and resets _dogsLoaded', () async {
      when(() => mockDogsController.fetchDogs('123'))
          .thenAnswer((_) async => [dog]);
      when(() => mockInfoController.getBreedImage(any()))
          .thenAnswer((_) async => 'path.png');

      await notifier.reloadDogs('123');

      expect(notifier.state.dogs.isNotEmpty, true);
    });

    test('selectDog updates selected dog', () {
      notifier.state = DogState(dogs: [dog]);

      notifier.selectDog(dog);

      expect(notifier.state.selected, dog);
    });

    test('toggleFavorite updates dog and selected if needed', () {
      notifier.state = DogState(dogs: [dog], selected: dog);

      notifier.toggleFavorite('1');

      expect(notifier.state.dogs.first.isFavorite, true);
      expect(notifier.state.selected?.isFavorite, true);
    });

    test('updateDog enriches image and updates state', () async {
      notifier.state = DogState(dogs: [dog]);
      final updatedDog = dog.copyWith(name: 'Rex');

      when(() => mockDogsController.updateDog(any(), any()))
          .thenAnswer((_) async => updatedDog);
      when(() => mockInfoController.getBreedImage(updatedDog.breed))
          .thenAnswer((_) async => 'assets/images/dogs/labrador.png');

      final result = await notifier.updateDog(updatedDog, '123');

      expect(result.imageUrl, 'assets/images/dogs/labrador.png');
      expect(notifier.state.dogs.first.imageUrl, 'assets/images/dogs/labrador.png');
    });

    test('editDog calls controller.updateDog and updates state', () async {
      notifier.state = DogState(dogs: [dog]);
      final updatedDog = dog.copyWith(name: 'Rex');

      when(() => mockDogsController.updateDog(any(), any()))
          .thenAnswer((_) async => updatedDog);

      await notifier.editDog(updatedDog, '123');

      expect(notifier.state.dogs.first.name, 'Rex');
    });

    test('addDog calls controller.addDog and updates state', () async {
      when(() => mockDogsController.addDog(any(), any()))
          .thenAnswer((_) async => dog);

      await notifier.addDog(dog, '123');

      verify(() => mockDogsController.addDog(dog, '123')).called(1);
      expect(notifier.state.dogs, contains(dog));
    });

    test('deleteDog calls controller.deleteDog', () async {
      when(() => mockDogsController.deleteDog(any(), any()))
          .thenAnswer((_) async => null);

      await notifier.deleteDog('1', '123');

      verify(() => mockDogsController.deleteDog('1', '123')).called(1);
    });
  });
}
