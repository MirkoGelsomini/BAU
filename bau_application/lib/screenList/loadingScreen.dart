import 'package:bau_application/widgets/dogInputOption.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/dog_provider.dart';
import '../widgets/loadingIndicator.dart';

class LoadingScreen extends ConsumerWidget {

  const LoadingScreen({super.key});

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
                Stack(
                  children: [
                    Image.network(
                      dog.imageUrl,
                      height: 280,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 12,
                      left: 12,
                      child: CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                  ],
                ),

                Expanded(
                  child: LoadingIndicator(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
