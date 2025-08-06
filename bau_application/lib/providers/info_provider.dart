import 'package:bau_application/controllers/info_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/serverConfig.dart';


final infoProvider = Provider<InfoController>((ref) {
  return InfoController(baseUrl: ServerConfig.info);
});

final labelListProvider = FutureProvider.family.autoDispose<Map<String, String>, String>((ref, langKey) async {
  final controller = ref.read(infoProvider);
  final langWithPrefix = 'label_$langKey';
  return await controller.getLabels(lang: langWithPrefix);
});

final breedListProvider = FutureProvider.autoDispose<List<String>>((ref) async {
  final controller = ref.read(infoProvider);
  return await controller.getAllBreeds();
});

