import 'package:bau_application/controllers/auth_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'dart:convert';

void main() {
  group('AuthController tests', () {
    late AuthController authController;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient((request) async {
        final path = request.url.path;
        final body = jsonDecode(request.body);

        if (path.endsWith('/login')) {
          if (body['username'] == 'test@example.com' && body['password'] == 'pass') {
            return http.Response(jsonEncode({'token': 'fake123'}), 200);
          }
          return http.Response(jsonEncode({'message': 'Invalid credentials'}), 401);
        }

        if (path.endsWith('/register')) {
          return http.Response(jsonEncode({'userId': 42}), 201);
        }

        return http.Response('Not Found', 404);
      });

      authController = AuthController(baseUrl: 'http://fake-server.com', client: mockClient);
    });

    test('login returns fake success', () async {
      final result = await authController.login('test@example.com', 'pass');
      expect(result['success'], true);
      expect(result['token'], 'fake123');
    });

    test('login fails with wrong credentials', () async {
      final result = await authController.login('wrong@example.com', 'wrong');
      expect(result['success'], false);
      expect(result['message'], 'Invalid credentials');
    });

    test('register returns fake success', () async {
      final result = await authController.register(
        email: 'newuser@example.com',
        password: 'password',
        firstName: 'John',
        lastName: 'Doe',
        age: 25,
        country: 'IT',
      );
      expect(result['success'], true);
      expect(result['userId'], 42);
    });
  });
}
