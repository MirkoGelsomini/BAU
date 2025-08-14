import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:bau_application/models/serverConfig.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:http/http.dart' as http;

class AudioController {
  final AudioRecorder _recorder;
  final AudioPlayer? _player;
  final http.Client _httpClient;

  bool isRecording = false;
  bool isPlaying = false;
  String audioPath = "";

  /// Normal constructor for production
  AudioController({
    AudioRecorder? recorder,
    AudioPlayer? player,
    http.Client? httpClient,
  })  : _recorder = recorder ?? AudioRecorder(),
        _player = player ?? AudioPlayer(),
        _httpClient = httpClient ?? http.Client() {
    _player?.onPlayerComplete.listen((event) {
      isPlaying = false;
    });
  }

  /// Test mode constructor (no AudioPlayer to avoid platform calls)
  AudioController.test({
    http.Client? httpClient,
  })  : _recorder = AudioRecorder(),
        _player = null,
        _httpClient = httpClient ?? http.Client();

  Future<void> dispose() async {
    await _player?.dispose();
    await _recorder.dispose();
    _httpClient.close();
  }

  Future<void> startRecording() async {
    if (await _recorder.hasPermission()) {
      final directory = await getTemporaryDirectory();
      final path = '${directory.path}/recorded_audio.wav';

      await _recorder.start(
        RecordConfig(
          encoder: AudioEncoder.wav,
          bitRate: 128000,
        ),
        path: path,
      );
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
    if (_player == null) return; // Skip if in test mode
    if (audioPath.isEmpty) return;
    isPlaying = true;
    await _player!.play(DeviceFileSource(audioPath));
  }

  Future<void> pause() async {
    if (_player == null) return;
    await _player!.pause();
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
    final file = File(audioPath);
    if (!await file.exists()) return null;

    final url = Uri.parse('${ServerConfig.audio}/upload');
    final request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath('audio', audioPath))
      ..fields['dogBreed'] = dogBreed;

    final streamedResponse = await _httpClient.send(request);

    if (streamedResponse.statusCode == 200) {
      final responseData = await streamedResponse.stream.bytesToString();
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
      print("Error in pickAudioFile: $e");
    }
    return null;
  }

  Future<bool> audioExists() async {
    if (audioPath.isEmpty) return false;
    final file = File(audioPath);
    return file.exists();
  }

  Future<Map<String, dynamic>?> uploadWithCustomUrl({
    required Uri url,
    required String dogBreed,
  }) async {
    if (audioPath.isEmpty) return null;
    final file = File(audioPath);
    if (!await file.exists()) return null;

    final request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath('audio', audioPath))
      ..fields['dogBreed'] = dogBreed;

    final streamedResponse = await _httpClient.send(request);

    if (streamedResponse.statusCode == 200) {
      final responseData = await streamedResponse.stream.bytesToString();
      final Map<String, dynamic> json = jsonDecode(responseData);
      await delete();
      return json;
    }
    return null;
  }

  AudioPlayer? get player => _player;
}
