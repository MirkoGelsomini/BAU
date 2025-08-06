import 'dart:convert';
import 'package:bau_application/models/serverConfig.dart';
import 'package:http/http.dart' as http;

class InfoController {
  final String baseUrl;

  InfoController({required this.baseUrl});

  Future<Map<String, String>> getLabels({required String lang}) async {
    final labelsUrl = ServerConfig.info;
    final response = await http.get(Uri.parse('$labelsUrl/labels?lang=$lang'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final labelsMap = Map<String, String>.from(data['labels']);
      return labelsMap;
    } else {
      return {};
    }
  }

  Future<List<String>> getAllBreeds() async {
    final response = await http.get(Uri.parse('$baseUrl/breeds'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((e) => e.toString()).toList();
    } else {
      throw Exception('Failed to load breeds');
    }
  }

  Future<String> getBreedImage(String breed) async {
    final response = await http.get(Uri.parse('$baseUrl/imageUrl/$breed'));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['imageUrl'] ?? '';
    } else if (response.statusCode == 404) {
      throw Exception('Breed not found');
    } else {
      throw Exception('Failed to load breed image');
    }
  }

}
