import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bau_application/models/theme.dart';

void main() {
  group('AppColors Tests', () {
    test('should have correct primary color', () {
      expect(AppColors.primary, const Color(0xFF7B634A));
    });

    test('should have correct secondary color', () {
      expect(AppColors.secondary, const Color(0xFFDFBC9B));
    });

    test('should have correct red color', () {
      expect(AppColors.red, const Color(0xFFCB7154));
    });

    test('should have correct light blue color', () {
      expect(AppColors.lightBlue, const Color(0xFF519FB3));
    });

    test('should have correct green color', () {
      expect(AppColors.green, const Color(0xFF99B359));
    });

    test('should have static const colors', () {
      expect(AppColors.primary, isA<Color>());
      expect(AppColors.secondary, isA<Color>());
      expect(AppColors.red, isA<Color>());
      expect(AppColors.lightBlue, isA<Color>());
      expect(AppColors.green, isA<Color>());
    });
  });

  group('AppTextStyles Tests', () {
    testWidgets('should create font style with all parameters', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final textStyle = AppTextStyles.font(
                context,
                FontWeight.bold,
                20.0,
                Colors.red,
              );
              
              return Text('Test', style: textStyle);
            },
          ),
        ),
      );

      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('should create font style with null parameters', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final textStyle = AppTextStyles.font();
              
              return Text('Test', style: textStyle);
            },
          ),
        ),
      );

      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('should create font style with context only', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final textStyle = AppTextStyles.font(context);
              
              return Text('Test', style: textStyle);
            },
          ),
        ),
      );

      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('should create font style with font weight only', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final textStyle = AppTextStyles.font(null, FontWeight.w600);
              
              return Text('Test', style: textStyle);
            },
          ),
        ),
      );

      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('should create font style with font size only', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final textStyle = AppTextStyles.font(null, null, 24.0);
              
              return Text('Test', style: textStyle);
            },
          ),
        ),
      );

      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('should create font style with color only', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final textStyle = AppTextStyles.font(null, null, null, Colors.blue);
              
              return Text('Test', style: textStyle);
            },
          ),
        ),
      );

      expect(find.byType(Text), findsOneWidget);
    });

    test('should return TextStyle', () {
      final textStyle = AppTextStyles.font();
      expect(textStyle, isA<TextStyle>());
    });

    test('should handle null context gracefully', () {
      final textStyle = AppTextStyles.font(null, FontWeight.bold, 18.0, Colors.black);
      expect(textStyle, isA<TextStyle>());
    });
  });
}
