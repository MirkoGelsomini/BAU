import 'dog.dart';

class User {
  final int id;
  final String firstName;
  final String lastName;
  final int age;
  final String country;
  final String email;
  final List<Dog> dogs;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.country,
    required this.email,
    this.dogs = const [],
  });

  User copyWith({
    int? id,
    String? firstName,
    String? lastName,
    int? age,
    String? country,
    String? email,
    List<Dog>? dogs,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      age: age ?? this.age,
      country: country ?? this.country,
      email: email ?? this.email,
      dogs: dogs ?? this.dogs,
    );
  }
}
