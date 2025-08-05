// lib/controllers/audio_controller.dart
import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:bau_application/models/serverConfig.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:http/http.dart' as http;

class AudioController {
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer player = AudioPlayer();

  AudioController() {
    player.onPlayerComplete.listen((event) {
      isPlaying = false;
    });
  }

  bool isRecording = false;
  bool isPlaying = false;
  String audioPath = "";

  Future<void> dispose() async {
    await player.dispose();
    await _recorder.dispose();
  }

  Future<void> startRecording() async {
    if (await _recorder.hasPermission()) {
      final directory = await getTemporaryDirectory();
      final path = '${directory.path}/recorded_audio.wav';

      await _recorder.start(const RecordConfig(), path: path);
      isRecording = true;
      audioPath = "";
    }
  }

  Future<void> stopRecording() async {
    final path = await _recorder.stop();
    isRecording = false;
    if (path != null) audioPath = path;
  }

  Future<void> play() async {
    if (audioPath.isEmpty) return;
    isPlaying = true;
    await player.play(DeviceFileSource(audioPath));
  }

  Future<void> pause() async {
    await player.pause();
    isPlaying = false;
  }

  Future<void> delete() async {
    if (audioPath.isEmpty) return;
    final file = File(audioPath);
    if (await file.exists()) await file.delete();
    audioPath = "";
    isRecording = false;
    isPlaying = false;
  }

  Future<Map<String, dynamic>?> upload({required String dogBreed}) async {
    if (audioPath.isEmpty) return null;
    String path = ServerConfig.audio;
    final file = File(audioPath);
    if (!await file.exists()) return null;

    final url = Uri.parse('$path/upload');
    final request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath('audio', audioPath))
      ..fields['dogBreed'] = dogBreed;

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final Map<String, dynamic> json = jsonDecode(responseData);

      await delete();
      return json;
    }

    return null;
  }


  Future<String?> pickAudioFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.audio);
      if (result != null && result.files.isNotEmpty) {
        return result.files.single.path;
      }
    } catch (e) {
      print("Errore nel pickAudioFile: $e");
    }
    return null;
  }

  Future<bool> audioExists() async {
    if (audioPath.isEmpty) return false;
    final file = File(audioPath);
    return file.exists();
  }

}
