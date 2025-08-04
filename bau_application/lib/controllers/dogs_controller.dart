import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/dog.dart';

class DogsController {
  final String baseUrl;

  DogsController({required this.baseUrl});

  Future<List<Dog>> fetchDogs(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/get?userId=$userId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body)['dogs'];
      return jsonList.map((json) => Dog.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load dogs');
    }
  }

  Future<Dog> updateDog(Dog dog, String userId) async {
    final body = dog.toJson();
    body['userId'] = userId;

    final response = await http.put(
      Uri.parse('$baseUrl/edit'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Dog.fromJson(json['dog']);
    } else {
      throw Exception('Failed to update dog: ${response.body}');
    }
  }

  Future<Dog> addDog(Dog dog, String userId) async {
    final body = dog.toJson();
    body['userId'] = userId;
    final response = await http.post(
      Uri.parse('$baseUrl/add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Dog.fromJson(json['dog'] ?? json);
    } else {
      throw Exception('Failed to add dog: ${response.body}');
    }
  }

  Future<void> deleteDog(String dogId, String userId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/delete?userId=$userId&dogId=$dogId'),
      headers: {'Content-Type': 'application/json'},
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode != 200) {
      throw Exception('Failed to delete dog');
    }
  }

}