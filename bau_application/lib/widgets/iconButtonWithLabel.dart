import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IconButtonWithLabel extends StatelessWidget {
  final Icon icon;
  final String label;
  final VoidCallback? onPressed;
  final double iconSize;
  final Color? iconColor;

  const IconButtonWithLabel({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.iconSize = 40,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          iconSize: iconSize,
          icon: Icon(
            icon.icon,
            color: iconColor ?? Colors.black,
            size: iconSize,
          ),
          onPressed: onPressed,
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}
