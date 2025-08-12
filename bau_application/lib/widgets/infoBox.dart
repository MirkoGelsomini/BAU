import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/theme.dart';

class InfoBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const InfoBox({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        // fa occupare tutta l’altezza disponibile
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Questo Expanded fa espandere il testo centrale
          Expanded(
            child: Center(
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: AppTextStyles.font(context, FontWeight.w400, 14, Colors.grey[700]),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 3,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextStyles.font(context, FontWeight.w200, 12, Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}

