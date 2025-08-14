import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bau_application/providers/feedback_provider.dart';
import 'package:bau_application/controllers/feedback_controller.dart';

class MockFeedbackController extends Mock implements FeedbackController {}

void main() {
  late MockFeedbackController mockController;

  setUp(() {
    mockController = MockFeedbackController();
  });

  final feedbackData = FeedbackData(
    transactionId: 123,
    isCorrect: true,
    correctLabel: 'Labrador',
    comment: 'Ottima risposta',
  );

  test('feedbackProvider returns true when controller succeeds', () async {
    when(() => mockController.sendFeedback(
      transactionId: any(named: 'transactionId'),
      isCorrect: any(named: 'isCorrect'),
      correctLabel: any(named: 'correctLabel'),
      comment: any(named: 'comment'),
    )).thenAnswer((_) async => true);

    final container = ProviderContainer(
      overrides: [
        feedbackControllerProvider.overrideWithValue(mockController),
      ],
    );

    final result = await container.read(feedbackProvider(feedbackData).future);

    expect(result, isTrue);

    verify(() => mockController.sendFeedback(
      transactionId: 123,
      isCorrect: true,
      correctLabel: 'Labrador',
      comment: 'Ottima risposta',
    )).called(1);
  });

  test('feedbackProvider returns false when controller fails', () async {
    when(() => mockController.sendFeedback(
      transactionId: any(named: 'transactionId'),
      isCorrect: any(named: 'isCorrect'),
      correctLabel: any(named: 'correctLabel'),
      comment: any(named: 'comment'),
    )).thenAnswer((_) async => false);

    final container = ProviderContainer(
      overrides: [
        feedbackControllerProvider.overrideWithValue(mockController),
      ],
    );

    final result = await container.read(feedbackProvider(feedbackData).future);

    expect(result, isFalse);
  });
}
