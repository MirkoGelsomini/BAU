import 'package:flutter_riverpod/flutter_riverpod.dart';

enum DogDetailView {
  dogDetailWidget,
  recordAudioWidget,
  predictionResultWidget,
  loadingScreen,
}

final dogDetailViewProvider = StateProvider<DogDetailView>((ref) {
  return DogDetailView.dogDetailWidget;
});