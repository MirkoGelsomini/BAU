import 'dart:convert';
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

  Future<Map<String, String>> getLabels({required String lang}) async {
    final response = await http.get(Uri.parse('$baseUrl/labels?lang=$lang'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final labelsMap = Map<String, String>.from(data['labels']);
      return labelsMap;
    } else {
      return {};
    }
  }

}
