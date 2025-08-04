import 'package:bau_application/screenList/authScreen.dart';
import 'package:bau_application/screenList/dogListScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cards App',
      theme: ThemeData(
        primaryColor: const Color(0xFFFFCCCC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFCCCC),
        ),
        useMaterial3: true,
      ),
      home: AuthScreen(),
    );
  }
}
