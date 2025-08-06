import 'dart:convert';
import 'package:bau_application/models/serverConfig.dart';
import 'package:http/http.dart' as http;

class FeedbackController {
  final String baseUrl;

  FeedbackController({required this.baseUrl});

  Future<bool> sendFeedback({
    required int transactionId,
    required bool isCorrect,
    String? correctLabel,
    String? comment,
  }) async {
    final url = Uri.parse('$baseUrl/feedback');

    final body = {
      'transactionId': transactionId,
      'isCorrect': isCorrect,
      'correctCategory': correctLabel,
      if (comment != null && comment.isNotEmpty) 'comment': comment,
    };

    final headers = {'Content-Type': 'application/json'};

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    return response.statusCode == 200;
  }
}
