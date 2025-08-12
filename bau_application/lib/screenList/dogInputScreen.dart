import 'package:bau_application/screenList/dogResultsScreen.dart';
import 'package:bau_application/widgets/dogInputOption.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/audio_controller.dart';
import '../models/predictionResult.dart';
import '../providers/dog_provider.dart';
import '../providers/loading_provider.dart';
import '../providers/prediction_provider.dart';
import '../widgets/loadingIndicator.dart';

class DogInputScreen extends ConsumerStatefulWidget {
  const DogInputScreen({super.key});

  @override
  ConsumerState<DogInputScreen> createState() => _DogInputScreenState();
}

class _DogInputScreenState extends ConsumerState<DogInputScreen> {
  final AudioController _audioController = AudioController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (ref.read(isLoadingProvider)) {
      Future.microtask(() {
        if (mounted) {
          ref.read(isLoadingProvider.notifier).state = false;
        }
      });
    }
  }


  @override
  void initState() {
    super.initState();
    _audioController.player.onPlayerComplete.listen((event) {
      _audioController.isPlaying = false;
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _audioController.dispose();
    super.dispose();
  }

  Future<void> _handleUpload() async {
    try {
      ref.read(isLoadingProvider.notifier).state = true;

      final dogBreed = ref.read(dogProvider).selected!.breed;
      final result = await _audioController.upload(dogBreed: dogBreed);

      if (!mounted) return;

      if (result != null) {
        final predictionResult = PredictionResult.fromJson(result);
        ref.read(predictionProvider.notifier).state = predictionResult;
      } else {
        ref.read(isLoadingProvider.notifier).state = false;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nessun risultato ricevuto')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ref.read(isLoadingProvider.notifier).state = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore upload: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dog = ref.watch(dogProvider).selected!;
    final isLoading = ref.watch(isLoadingProvider);

    ref.listen<PredictionResult?>(predictionProvider, (previous, next) {
      if (next != null) {
        Navigator.of(context)
            .push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
            const DogResultsScreen(),
            transitionDuration: const Duration(milliseconds: 150),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ).then((_) {
          ref.read(isLoadingProvider.notifier).state = false;
          ref.read(predictionProvider.notifier).state = null;
        });
      }
    });

    return WillPopScope(
      onWillPop: () async {
        return !isLoading;
      },
      child: Scaffold(
        body: Stack(
          children: [
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
                      Image.asset(
                        dog.imageUrl,
                        height: 280,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        top: 12,
                        left: 12,
                        child: isLoading
                            ? SizedBox.shrink() // niente widget (bottone nascosto)
                            : CircleAvatar(
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
                    child: isLoading
                        ? const LoadingIndicator()
                        : DogInputOptions(
                      audioController: _audioController,
                      onUploadPressed: _handleUpload,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
