import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/audio_controller.dart';
import '../models/predictionResult.dart';
import '../providers/dog_detail_view_provider.dart';
import '../providers/dog_provider.dart';
import '../providers/loading_provider.dart';
import '../providers/prediction_provider.dart';
import 'iconButtonWithLabel.dart';

class DogInputOptions extends ConsumerStatefulWidget {
  const DogInputOptions({super.key});

  @override
  ConsumerState<DogInputOptions> createState() => _DogInputOptionsState();
}

class _DogInputOptionsState extends ConsumerState<DogInputOptions> {
  final AudioController _audioController = AudioController();

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

  void _refreshUI() => setState(() {});

  Future<void> _pickFile() async {
    final path = await _audioController.pickAudioFile();
    if (path != null) {
      _audioController.audioPath = path;
      _audioController.isPlaying = false;
      _refreshUI();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No file selected')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRecording = _audioController.isRecording;
    final hasAudio = _audioController.audioPath.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            textAlign: TextAlign.center,
            'Choose how to send the audio',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 32),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButtonWithLabel(
                icon: isRecording
                    ? const Icon(Icons.fiber_manual_record, color: Colors.red)
                    : const Icon(Icons.mic, color: Colors.black),
                label: isRecording ? 'Registrazione...' : 'Registra audio',
                iconSize: 90,
                iconColor: isRecording ? Colors.red : Colors.black,
                onPressed: () async {
                  if (isRecording) {
                    await _audioController.stopRecording();
                    _audioController.isPlaying = false;
                  } else {
                    await _audioController.startRecording();
                  }
                  _refreshUI();
                },
              ),

              IconButtonWithLabel(
                icon: Icon(
                  Icons.upload_file,
                  color: isRecording ? Colors.grey : Colors.black,
                ),
                label: 'Carica file audio',
                iconSize: 90,
                iconColor: isRecording ? Colors.grey : Colors.black,
                onPressed: isRecording ? null : _pickFile,
              ),
            ],
          ),

          const SizedBox(height: 32),

          if (hasAudio)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButtonWithLabel(
                  icon: _audioController.isPlaying
                      ? const Icon(Icons.pause_circle, color: Colors.green)
                      : const Icon(Icons.play_circle, color: Colors.green),
                  label: _audioController.isPlaying ? 'Pausa' : 'Play',
                  iconColor: Colors.green,
                  onPressed: () async {
                    if (_audioController.isPlaying) {
                      await _audioController.pause();
                    } else {
                      await _audioController.play();
                    }
                    _refreshUI();
                  },
                ),
                IconButtonWithLabel(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: 'Elimina',
                  iconColor: Colors.red,
                  onPressed: () async {
                    await _audioController.delete();
                    _refreshUI();
                  },
                ),
                IconButtonWithLabel(
                  icon: const Icon(Icons.upload_file, color: Colors.blue),
                  label: 'Invia',
                  iconColor: Colors.blue,
                  onPressed: () async {
                    try {
                      ref.read(isLoadingProvider.notifier).state = true;

                      final dogBreed = ref.read(dogProvider).selected!.breed;
                      final result = await _audioController.upload(dogBreed: dogBreed);

                      if (!mounted) return;

                      ref.read(isLoadingProvider.notifier).state = false;

                      if (result != null) {
                        final predictionResult = PredictionResult.fromJson(result);
                        ref.read(predictionProvider.notifier).state = predictionResult;
                        ref.read(dogDetailViewProvider.notifier).state = DogDetailView.predictionResultWidget;
                      } else {
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
                  },

                ),
              ],
            ),

          const Spacer(),

          SizedBox(
            width: double.infinity,
            child: GestureDetector(
              onTap: () {
                ref.read(dogDetailViewProvider.notifier).state =
                    DogDetailView.dogDetailWidget;
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFA5A5),
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Torna ai dettagli',
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
