import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:bau_application/controllers/feedback_controller.dart';

void main() {
  group('FeedbackController tests', () {
    late FeedbackController feedbackController;
    late MockClient mockClient;

    test('sendFeedback returns true on success', () async {
      mockClient = MockClient((request) async {
        return http.Response('', 200);
      });

      feedbackController = FeedbackController(
        baseUrl: 'http://fake-server.com',
        client: mockClient,
      );

      final result = await feedbackController.sendFeedback(
        transactionId: 123,
        isCorrect: true,
        correctLabel: 'Dog',
        comment: 'All good',
      );

      expect(result, true);
    });

    test('sendFeedback returns false on failure', () async {
      mockClient = MockClient((request) async {
        return http.Response('Internal Server Error', 500);
      });

      feedbackController = FeedbackController(
        baseUrl: 'http://fake-server.com',
        client: mockClient,
      );

      final result = await feedbackController.sendFeedback(
        transactionId: 123,
        isCorrect: true,
      );

      expect(result, false);
    });
  });
}
