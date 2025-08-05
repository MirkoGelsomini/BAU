import 'package:bau_application/models/serverConfig.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/feedback_controller.dart';

final feedbackControllerProvider = Provider<FeedbackController>((ref) {
  return FeedbackController(baseUrl: ServerConfig.audio);
});

final feedbackProvider = FutureProvider.family.autoDispose<bool, FeedbackData>((ref, feedback) async {
  final controller = ref.read(feedbackControllerProvider);
  return await controller.sendFeedback(
    transactionId: feedback.transactionId,
    isCorrect: feedback.isCorrect,
    correctLabel: feedback.correctLabel,
    comment: feedback.comment,
  );
});

final labelListProvider = FutureProvider.family.autoDispose<Map<String, String>, String>((ref, langKey) async {
  final controller = ref.read(feedbackControllerProvider);
  final langWithPrefix = 'label_$langKey';
  return await controller.getLabels(lang: langWithPrefix);
});



class FeedbackData {
  final int transactionId;
  final bool isCorrect;
  final String? correctLabel;
  final String? comment;

  FeedbackData({
    required this.transactionId,
    required this.isCorrect,
    this.correctLabel,
    this.comment,
  });
}
