import 'package:flutter/material.dart';
import '../models/theme.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/gifs/loading.gif',
                height: 120,
              ),
              const SizedBox(height: 32),
              Text(
                'Audio analysis in progress...',
                style: AppTextStyles.font(context, FontWeight.w600, 20, Colors.black87),
              ),
              const SizedBox(height: 16),
              Text(
                'Please wait a few seconds...',
                style: AppTextStyles.font(context, null, 16, Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
