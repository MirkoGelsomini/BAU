import 'package:bau_application/controllers/info_controller.dart';
import 'package:bau_application/models/serverConfig.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/dogs_controller.dart';
import '../models/dog.dart';
import '../models/dogState.dart';

class DogNotifier extends StateNotifier<DogState> {
  final DogsController controller;
  final InfoController infoController;
  bool _dogsLoaded = false;

  DogNotifier({
    required this.controller,
    required this.infoController,
  })  : super(DogState(dogs: [], selected: null));

  Future<void> reloadDogs(String userId) async {
    _dogsLoaded = false;
    await loadDogs(int.parse(userId));
  }


  Future<void> loadDogs(int userId) async {
    if (_dogsLoaded) return;

    try {
      final dogs = await controller.fetchDogs(userId.toString());

      final breeds = dogs.map((d) => d.breed).toSet();

      final Map<String, String> breedImages = {};

      for (var breed in breeds) {
        final imagePath = await infoController.getBreedImage(breed);
        breedImages[breed] = imagePath;
      }

      final enrichedDogs = dogs.map((dog) {
        return dog.copyWith(imageUrl: breedImages[dog.breed] ?? 'assets/images/dogs/default_dog.png');
      }).toList();

      state = state.copyWith(dogs: enrichedDogs);
      _dogsLoaded = true;
    } catch (e) {
      print('Errore caricamento cani: $e');
    }
  }

  void selectDog(Dog dog) {
    state = state.copyWith(selected: dog);
  }

  Future<void> editDog(Dog updatedDog, String userId) async {
    try {
      final dog = await controller.updateDog(updatedDog, userId);
      _update(dog);
    } catch (e) {
      print('Errore aggiornamento cane: $e');
    }
  }

  Future<Dog> updateDog(Dog dog, String userId) async {
    try {
      final updatedDog = await controller.updateDog(dog, userId);

      String imageUrl = '';
      try {
        imageUrl = await infoController.getBreedImage(updatedDog.breed);
      } catch (e) {
        print('Errore immagine per ${updatedDog.breed}: $e');
        imageUrl = '';
      }

      final enrichedDog = updatedDog.copyWith(imageUrl: imageUrl);

      _update(enrichedDog);

      return enrichedDog;
    } catch (e) {
      print('Errore aggiornamento cane: $e');
      rethrow;
    }
  }

  Future<void> addDog(Dog newDog, String userId) async {
    try {
      await controller.addDog(newDog, userId);
    } catch (e) {
      print('Errore aggiunta cane: $e');
    }
  }

  Future<void> deleteDog(String dogId, String userId) async {
    try {
      await controller.deleteDog(dogId, userId);
    } catch (e) {
      print('Errore eliminazione cane: $e');
    }
  }

  void _update(Dog updated) {
    final updatedList = [
      for (final d in state.dogs)
        if (d.id == updated.id) updated else d
    ];
    state = state.copyWith(
      dogs: updatedList,
      selected: state.selected?.id == updated.id ? updated : state.selected,
    );
  }

  void toggleFavorite(String dogId) {
    final updatedList = state.dogs.map((dog) {
      if (dog.id == dogId) {
        return dog.copyWith(isFavorite: !dog.isFavorite);
      }
      return dog;
    }).toList();

    final updatedSelected = state.selected?.id == dogId
        ? state.selected?.copyWith(isFavorite: !state.selected!.isFavorite)
        : state.selected;

    state = state.copyWith(dogs: updatedList, selected: updatedSelected);
  }
}

final dogProvider = StateNotifierProvider<DogNotifier, DogState>((ref) {
  final controller = DogsController(baseUrl: ServerConfig.dogs);
  final infoController = InfoController(baseUrl: ServerConfig.info);
  return DogNotifier(controller: controller, infoController: infoController);
});
