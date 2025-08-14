import 'package:flutter_test/flutter_test.dart';
import 'package:bau_application/models/serverConfig.dart';

void main() {
  group('ServerConfig Tests', () {
    test('should have correct base URLs', () {
      expect(ServerConfig.baseUrl, isNotEmpty);
      expect(ServerConfig.auth, isNotEmpty);
      expect(ServerConfig.dogs, isNotEmpty);
      expect(ServerConfig.info, isNotEmpty);
      expect(ServerConfig.feedback, isNotEmpty);
    });

    test('should have valid URL format', () {
      expect(ServerConfig.baseUrl, startsWith('http'));
      expect(ServerConfig.auth, startsWith('http'));
      expect(ServerConfig.dogs, startsWith('http'));
      expect(ServerConfig.info, startsWith('http'));
      expect(ServerConfig.feedback, startsWith('http'));
    });

    test('should have consistent URL structure', () {
      expect(ServerConfig.auth, contains(ServerConfig.baseUrl));
      expect(ServerConfig.dogs, contains(ServerConfig.baseUrl));
      expect(ServerConfig.info, contains(ServerConfig.baseUrl));
      expect(ServerConfig.feedback, contains(ServerConfig.baseUrl));
    });

    test('should have specific endpoints', () {
      expect(ServerConfig.auth, endsWith('/auth'));
      expect(ServerConfig.dogs, endsWith('/dogs'));
      expect(ServerConfig.info, endsWith('/info'));
      expect(ServerConfig.feedback, endsWith('/feedback'));
    });

    test('should not be empty strings', () {
      expect(ServerConfig.baseUrl.length, greaterThan(0));
      expect(ServerConfig.auth.length, greaterThan(0));
      expect(ServerConfig.dogs.length, greaterThan(0));
      expect(ServerConfig.info.length, greaterThan(0));
      expect(ServerConfig.feedback.length, greaterThan(0));
    });

    test('should be accessible as static constants', () {
      expect(ServerConfig.baseUrl, isA<String>());
      expect(ServerConfig.auth, isA<String>());
      expect(ServerConfig.dogs, isA<String>());
      expect(ServerConfig.info, isA<String>());
      expect(ServerConfig.feedback, isA<String>());
    });

    test('should have proper URL construction', () {
      final baseUrl = ServerConfig.baseUrl;
      expect(ServerConfig.auth, equals('$baseUrl/auth'));
      expect(ServerConfig.dogs, equals('$baseUrl/dogs'));
      expect(ServerConfig.info, equals('$baseUrl/info'));
      expect(ServerConfig.feedback, equals('$baseUrl/feedback'));
    });
  });
}
