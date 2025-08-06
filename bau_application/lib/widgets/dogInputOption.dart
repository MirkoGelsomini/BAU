import 'package:bau_application/models/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/audio_controller.dart';
import '../widgets/iconButtonWithLabel.dart';

class DogInputOptions extends ConsumerStatefulWidget {
  final AudioController audioController;
  final Future<void> Function() onUploadPressed;

  const DogInputOptions({
    super.key,
    required this.audioController,
    required this.onUploadPressed,
  });

  @override
  ConsumerState<DogInputOptions> createState() => _DogInputOptionsState();
}

class _DogInputOptionsState extends ConsumerState<DogInputOptions> {
  void _refreshUI() => setState(() {});

  Future<void> _pickFile() async {
    final path = await widget.audioController.pickAudioFile();
    if (path != null) {
      widget.audioController.audioPath = path;
      widget.audioController.isPlaying = false;
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
    final isRecording = widget.audioController.isRecording;
    final hasAudio = widget.audioController.audioPath.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            'Choose how to send the audio',
            textAlign: TextAlign.center,
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
                    : const Icon(Icons.mic, color: Color(0xFF7B634A)),
                label: isRecording ? 'Registrazione...' : 'Registra audio',
                iconSize: 90,
                iconColor: isRecording ? Colors.red : const Color(0xFF7B634A),
                onPressed: () async {
                  if (isRecording) {
                    await widget.audioController.stopRecording();
                    widget.audioController.isPlaying = false;
                  } else {
                    await widget.audioController.startRecording();
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
                iconColor: isRecording ? Colors.grey : const Color(0xFF907459),
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
                  icon: widget.audioController.isPlaying
                      ? const Icon(Icons.pause_circle, color: Colors.green)
                      : const Icon(Icons.play_circle, color: Colors.green),
                  label: widget.audioController.isPlaying ? 'Pausa' : 'Play',
                  iconColor: AppColors.green,
                  onPressed: () async {
                    if (widget.audioController.isPlaying) {
                      await widget.audioController.pause();
                    } else {
                      await widget.audioController.play();
                    }
                    _refreshUI();
                  },
                ),
                IconButtonWithLabel(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: 'Elimina',
                  iconColor: AppColors.red,
                  onPressed: () async {
                    await widget.audioController.delete();
                    _refreshUI();
                  },
                ),
                IconButtonWithLabel(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  label: 'Invia',
                  iconColor: AppColors.lightBlue,
                  onPressed: widget.onUploadPressed,
                ),
              ],
            ),
          const Spacer(),
        ],
      ),
    );
  }
}
