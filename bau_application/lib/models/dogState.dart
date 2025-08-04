import '../models/dog.dart';

class DogState {
  final List<Dog> dogs;
  final Dog? selected;

  DogState({required this.dogs, this.selected});

  DogState copyWith({List<Dog>? dogs, Dog? selected}) {
    return DogState(
      dogs: dogs ?? this.dogs,
      selected: selected ?? this.selected,
    );
  }
}
