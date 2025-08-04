import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthController {
  final String baseUrl;

  AuthController({required this.baseUrl});

  Future<Map<String, dynamic>> _post(String endpoint, Map<String, String> body) async {
    final url = Uri.parse(baseUrl.endsWith('/')
        ? '$baseUrl$endpoint'
        : '$baseUrl/$endpoint');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {'success': true, ...data};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Errore'};
      }
    } catch (e) {
      print('Errore in _post: $e');
      return {'success': false, 'message': 'Errore di rete o di parsing'};
    }
  }

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required int age,
    required String country,
  }) async {
    return await _post('register', {
      'username': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'age': age.toString(),
      'country': country,
    });
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    return await _post('login', {'username': email, 'password': password});
  }
}
