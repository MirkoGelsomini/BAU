import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:bau_application/controllers/info_controller.dart';
import 'package:http/http.dart' as http;

void main() {
  group('InfoController tests', () {
    late InfoController infoController;
    late MockClient mockClient;

    test('getAllBreeds returns list of breeds', () async {
      mockClient = MockClient((request) async {
        return http.Response(jsonEncode(['Beagle', 'Labrador']), 200);
      });

      infoController = InfoController(baseUrl: 'http://fake-server.com', client: mockClient);

      final breeds = await infoController.getAllBreeds();
      expect(breeds, ['Beagle', 'Labrador']);
    });

    test('getAllBreeds throws on failure', () async {
      mockClient = MockClient((request) async {
        return http.Response('Not Found', 404);
      });

      infoController = InfoController(baseUrl: 'http://fake-server.com', client: mockClient);

      expect(infoController.getAllBreeds(), throwsException);
    });

    test('getLabels returns map of labels', () async {
      mockClient = MockClient((request) async {
        return http.Response(jsonEncode({
          'labels': {
            'dog': {'label': 'Dog', 'status': 'active'},
            'cat': {'label': 'Cat', 'status': 'inactive'}
          }
        }), 200);
      });

      infoController = InfoController(baseUrl: 'http://fake-server.com', client: mockClient);

      final labels = await infoController.getLabels(lang: 'en');
      expect(labels['dog']!['label'], 'Dog');
      expect(labels['cat']!['status'], 'inactive');
    });
  });
}
