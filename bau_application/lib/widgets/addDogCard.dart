import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/theme.dart';

class AddDogCard extends StatelessWidget {
  final VoidCallback onTap;

  const AddDogCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            '+',
            style: AppTextStyles.font(context, FontWeight.bold, 48, Colors.grey[600]),
          ),
        ),
      ),
    );
  }
}
