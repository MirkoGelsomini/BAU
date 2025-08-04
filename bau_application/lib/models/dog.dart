class Dog {
  final String id;
  final String imageUrl;
  final String name;
  final String breed;
  final bool isFemale;
  final int years;
  final double weight;
  final bool isFavorite;

  Dog({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.breed,
    required this.isFemale,
    required this.years,
    required this.weight,
    required this.isFavorite,
  });

  factory Dog.fromJson(Map<String, dynamic> json) {
    return Dog(
      id: json['id'].toString(),
      imageUrl: json['imageUrl'] ?? 'https://picsum.photos/300/200',
      name: json['name'] ?? '',
      breed: json['breed'] ?? '',
      isFemale: (json['gender']?.toString().toLowerCase() == 'female'),
      years: (json['age'] ?? 0) is int ? json['age'] : int.tryParse(json['age'].toString()) ?? 0,
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
      'age': years,
      'weight': weight,
    };
  }


  Dog copyWith({
    String? name,
    String? breed,
    bool? isFemale,
    int? years,
    double? weight,
    bool? isFavorite,
    String? userId,
  }) {
    return Dog(
      id: id,
      imageUrl: imageUrl,
      name: name ?? this.name,
      breed: breed ?? this.breed,
      isFemale: isFemale ?? this.isFemale,
      years: years ?? this.years,
      weight: weight ?? this.weight,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  String toString() {
    return 'Dog(id: $id, name: $name, breed: $breed, gender: ${isFemale ? 'Female' : 'Male'}, age: $years, weight: $weight, isFavorite: $isFavorite)';
  }

}
