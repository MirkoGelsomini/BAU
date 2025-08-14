import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bau_application/providers/prediction_provider.dart';
import 'package:bau_application/models/predictionResult.dart';

void main() {
  test('predictionProvider starts as null and can be updated with PredictionResult', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(predictionProvider), null);

    final prediction = Prediction(
      label: 'Dog',
      confidence: 0.95,
      description: 'A friendly dog',
      labelsByLanguage: {'en': 'Dog', 'it': 'Cane'},
    );

    final predictionResult = PredictionResult(
      transactionId: 1,
      predictions: [prediction],
    );

    container.read(predictionProvider.notifier).state = predictionResult;

    final state = container.read(predictionProvider);
    expect(state, isNotNull);
    expect(state!.transactionId, 1);
    expect(state.predictions.length, 1);
    expect(state.predictions.first.label, 'Dog');

    container.read(predictionProvider.notifier).state = null;
    expect(container.read(predictionProvider), null);
  });
}
