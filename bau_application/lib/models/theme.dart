import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFF7B634A);
  static const Color secondary = Color(0xFFDFBC9B);
  static const Color red = Color(0xFFCB7154);
  static const Color lightBlue = Color(0xFF519FB3);
  static const Color green = Color(0xFF99B359);
}


class AppTextStyles {
  static TextStyle font(
      [BuildContext? context,
        FontWeight? fontWeight,
        double? fontSize,
        Color? color,
      ]) {
    return GoogleFonts.fredoka(
      fontWeight: fontWeight,
      fontSize: fontSize,
      color: color,
    );
  }
}

