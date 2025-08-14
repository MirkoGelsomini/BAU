import 'dart:convert';
import 'package:bau_application/models/serverConfig.dart';
import 'package:http/http.dart' as http;

class InfoController {
  final String baseUrl;
  final http.Client client;

  InfoController({required this.baseUrl, http.Client? client})
      : client = client ?? http.Client();

  Future<Map<String, Map<String, String>>> getLabels({required String lang}) async {
    final labelsUrl = ServerConfig.info;
    final response = await client.get(Uri.parse('$labelsUrl/labels?lang=$lang'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final Map<String, dynamic> rawLabels = data['labels'];

      final labelsMap = rawLabels.map((key, value) {
        return MapEntry(
          key,
          {
            'label': value['label'] as String,
            'status': value['status'] as String,
          },
        );
      });

      return labelsMap;
    } else {
      return {};
    }
  }

  Future<List<String>> getAllBreeds() async {
    final response = await client.get(Uri.parse('$baseUrl/breeds'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((e) => e.toString()).toList();
    } else {
      throw Exception('Failed to load breeds');
    }
  }

  Future<String> getBreedImage(String breed) async {
    final normalized = breed
        .toLowerCase()
        .replaceAll(' ', '_')
        .replaceAll(RegExp(r'[^a-z0-9_]'), '');
    final assetPath = 'assets/images/dogs/${normalized}_image.png';

    try {
      return assetPath;
    } catch (e) {
      return 'assets/images/dogs/default_image.png';
    }
  }
}
