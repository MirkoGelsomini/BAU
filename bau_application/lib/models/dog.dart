class Dog {
  final String id;
  final String imageUrl;
  final String name;
  final String breed;
  final bool isFemale;
  final DateTime birthDate;
  final double weight;
  final bool isFavorite;

  Dog({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.breed,
    required this.isFemale,
    required this.birthDate,
    required this.weight,
    required this.isFavorite,
  });

  factory Dog.fromJson(Map<String, dynamic> json) {
    final birthDateString = json['birthDate'] as String;
    final parts = birthDateString.split('-');
    final birthDate = DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );

    return Dog(
      id: json['id'].toString(),
      imageUrl: json['imageUrl'] ?? 'https://picsum.photos/300/200',
      name: json['name'] ?? '',
      breed: json['breed'] ?? '',
      isFemale: (json['gender']?.toString().toLowerCase() == 'female'),
      birthDate: birthDate,
      weight: (json['weight'] ?? 0).toDouble(),
      isFavorite: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'breed': breed,
      'gender': isFemale ? 'Female' : 'Male',
      'birthDate': birthDate.toIso8601String(),
      'weight': weight,
    };
  }


  Dog copyWith({
    String? name,
    String? imageUrl,
    String? breed,
    bool? isFemale,
    DateTime? birthDate,
    double? weight,
    bool? isFavorite,
    String? userId,
  }) {
    return Dog(
      id: id,
      imageUrl: imageUrl ?? this.imageUrl,
      name: name ?? this.name,
      breed: breed ?? this.breed,
      isFemale: isFemale ?? this.isFemale,
      birthDate: birthDate ?? this.birthDate,
      weight: weight ?? this.weight,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  String toString() {
    return 'Dog(id: $id, name: $name, breed: $breed, gender: ${isFemale ? 'Female' : 'Male'}, birthDate: $birthDate, weight: $weight, isFavorite: $isFavorite, url: $imageUrl)';
  }

}
