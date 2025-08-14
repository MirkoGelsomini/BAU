import 'package:bau_application/models/predictionResult.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Prediction and PredictionResult', () {
    final jsonPrediction = {
      'label': 'Dog',
      'confidence': 0.95,
      'description': 'A domestic dog',
      'label_en': 'Dog',
      'label_it': 'Cane',
    };

    final jsonPredictionResult = {
      'transactionId': 123,
      'prediction': [jsonPrediction]
    };

    test('Prediction.fromJson parses correctly', () {
      final prediction = Prediction.fromJson(jsonPrediction);

      expect(prediction.label, 'Dog');
      expect(prediction.confidence, 0.95);
      expect(prediction.description, 'A domestic dog');
      expect(prediction.labelsByLanguage['en'], 'Dog');
      expect(prediction.labelsByLanguage['it'], 'Cane');
    });

    test('Prediction.getLabel returns correct label or fallback', () {
      final prediction = Prediction.fromJson(jsonPrediction);

      expect(prediction.getLabel('en'), 'Dog');
      expect(prediction.getLabel('it'), 'Cane');
      expect(prediction.getLabel('fr', fallback: 'Unknown'), 'Unknown');
    });

    test('PredictionResult.fromJson parses correctly', () {
      final result = PredictionResult.fromJson(jsonPredictionResult);

      expect(result.transactionId, 123);
      expect(result.predictions.length, 1);
      expect(result.predictions.first.label, 'Dog');
    });
  });
}
