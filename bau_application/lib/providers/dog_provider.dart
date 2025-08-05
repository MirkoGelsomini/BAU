import 'package:bau_application/models/serverConfig.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/dogs_controller.dart';
import '../models/dog.dart';
import '../models/dogState.dart'; // importa la classe DogState

class DogNotifier extends StateNotifier<DogState> {
  final DogsController controller;

  DogNotifier({required this.controller}) : super(DogState(dogs: [], selected: null));

  Future<void> loadDogs(int userId) async {
    try {
      final dogs = await controller.fetchDogs(userId.toString());
      state = state.copyWith(dogs: dogs);
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
    final updatedDog = await controller.updateDog(dog, userId);
    _update(updatedDog);
    return updatedDog;
  }

  Future<void> addDog(Dog newDog, String userId) async {
    try {
      final addedDog = await controller.addDog(newDog, userId);
      state = state.copyWith(dogs: [...state.dogs, addedDog]);
    } catch (e) {
      print('Errore aggiunta cane: $e');
    }
  }

  Future<void> deleteDog(String dogId, String userId) async {
    try {
      await controller.deleteDog(dogId, userId);
      state = state.copyWith(
        dogs: state.dogs.where((dog) => dog.id != dogId).toList(),
        selected: state.selected?.id == dogId ? null : state.selected,
      );
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
  return DogNotifier(controller: controller);
});

