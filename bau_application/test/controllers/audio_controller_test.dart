import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:bau_application/controllers/audio_controller.dart';
import 'package:http/http.dart' as http;

class FakeHttpClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final body = utf8.encode(jsonEncode({'ok': true}));
    final stream = Stream<List<int>>.fromIterable([body]);
    return http.StreamedResponse(stream, 200);
  }
}

void main() {
  late AudioController controller;

  setUpAll(() {
    controller = AudioController.test(httpClient: FakeHttpClient());
  });

  tearDown(() async {
    await controller.delete();
    await controller.dispose();
  });

  test('audioExists returns false if audioPath is empty', () async {
    controller.audioPath = '';
    expect(await controller.audioExists(), false);
  });

  test('delete removes file and resets state', () async {
    final tempDir = Directory.systemTemp.createTempSync();
    final fakeFile = File('${tempDir.path}/fake.wav');
    fakeFile.writeAsStringSync('fake audio');
    controller.audioPath = fakeFile.path;

    expect(await controller.audioExists(), true);

    await controller.delete();

    expect(controller.audioPath, '');
    expect(controller.isRecording, false);
    expect(controller.isPlaying, false);
    expect(await controller.audioExists(), false);
  });

  test('upload returns null if audioPath is empty', () async {
    controller.audioPath = '';
    final result = await controller.upload(dogBreed: 'Labrador');
    expect(result, null);
  });

  test('upload returns null if file does not exist', () async {
    controller.audioPath = '/non/existent/file.wav';
    final result = await controller.upload(dogBreed: 'Labrador');
    expect(result, null);
  });

  test('upload returns fake success', () async {
    final tempDir = Directory.systemTemp.createTempSync();
    final fakeFile = File('${tempDir.path}/fake.wav');
    fakeFile.writeAsStringSync('fake audio');
    controller.audioPath = fakeFile.path;

    // Build the URL manually instead of relying on ServerConfig.audio
    final url = Uri.parse('http://localhost:9999/upload');

    final result = await controller.uploadWithCustomUrl(
      url: url,
      dogBreed: 'Beagle',
    );

    expect(result?['ok'], true);
    expect(controller.audioPath, ''); // upload deletes after success
  });
}
