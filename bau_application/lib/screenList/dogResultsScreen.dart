import 'package:bau_application/widgets/dogInputOption.dart';
import 'package:bau_application/widgets/dogPredictionResultView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/dog_provider.dart';
import '../providers/loading_provider.dart';
import '../widgets/loadingIndicator.dart';

class DogResultsScreen extends ConsumerWidget {
  const DogResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dog = ref.watch(dogProvider).selected!;

    return Scaffold(
      body: Stack(
        children: [
          // Sfondo immagine
          Positioned.fill(
            child: Image.asset(
              'assets/images/backgroundPattern.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Immagine sempre visibile
                Stack(
                  children: [
                    Image.network(
                      dog.imageUrl,
                      height: 280,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),

                // 👇 Contenuto dinamico sotto l'immagine
                Expanded(
                  child: const DogPredictionResultsView()
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
