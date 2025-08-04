class PredictionResult {
  final int transactionId;
  final List<Prediction> predictions;

  PredictionResult({
    required this.transactionId,
    required this.predictions
  });

  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    return PredictionResult(
      transactionId: json['transactionId'],
      predictions: (json['prediction'] as List)
          .map((e) => Prediction.fromJson(e))
          .toList(),
    );
  }
}

class Prediction {
  final String label;
  final double confidence;
  final String description;
  final Map<String, String> labelsByLanguage;

  Prediction({
    required this.label,
    required this.confidence,
    required this.description,
    required this.labelsByLanguage,
  });

  factory Prediction.fromJson(Map<String, dynamic> json) {
    // Filtra tutte le chiavi che iniziano con "label_"
    final languageLabels = <String, String>{};
    json.forEach((key, value) {
      if (key.startsWith('label_') && value is String) {
        final lang = key.split('_')[1]; // es. 'it' da 'label_it'
        languageLabels[lang] = value;
      }
    });

    return Prediction(
      label: json['label'],
      confidence: (json['confidence'] is String)
          ? double.parse(json['confidence'])
          : (json['confidence'] as num).toDouble(),
      description: json['description'],
      labelsByLanguage: languageLabels,
    );
  }

  /// Facoltativo: accesso rapido con fallback
  String getLabel(String langCode, {String fallback = ''}) {
    return labelsByLanguage[langCode] ?? fallback;
  }
}

