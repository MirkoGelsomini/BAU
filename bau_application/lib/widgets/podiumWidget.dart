import 'package:flutter/material.dart';

class PodiumWidget extends StatelessWidget {
  final List<PredictionItem> top3;

  const PodiumWidget({Key? key, required this.top3}) : super(key: key);

  String _cleanLabel(String label) {
    final regex = RegExp(r'[^\w\s]', unicode: true);
    return label.replaceAll(regex, '');
  }

  Widget _podioItem({
    required int place,
    required String label,
    required double confidence,
    required double heightFactor,
  }) {
    final colors = [Colors.amber, Colors.grey, Colors.brown];
    const baseHeight = 140.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label.isNotEmpty ? label.characters.first : '❓',
          style: const TextStyle(fontSize: 28),
        ),
        const SizedBox(height: 6),
        Container(
          width: 90,  // aumentata larghezza da 80 a 100
          height: baseHeight * heightFactor,
          decoration: BoxDecoration(
            color: colors[place - 1],
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _cleanLabel(label),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),

              Text(
                '${(confidence * 100).toStringAsFixed(1)}%',
                style: const TextStyle(
                  fontSize: 12,  // ridotto font da 14 a 12
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }



  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      // Altezza massima disponibile per il widget podio
      final maxHeight = constraints.maxHeight;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (top3.length > 1)
              _podioItem(
                place: 2,
                label: top3[1].label,
                confidence: top3[1].confidence,
                heightFactor: 0.85,
              ),
            _podioItem(
              place: 1,
              label: top3[0].label,
              confidence: top3[0].confidence,
              heightFactor: 1.0,
            ),
            if (top3.length > 2)
              _podioItem(
                place: 3,
                label: top3[2].label,
                confidence: top3[2].confidence,
                heightFactor: 0.75,
              ),
          ],
        ),
      );
    });
  }
}


class PredictionItem {
  final String label;
  final double confidence;

  PredictionItem(this.label, this.confidence);
}
