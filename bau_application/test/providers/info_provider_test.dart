import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bau_application/providers/info_provider.dart';
import 'package:bau_application/controllers/info_controller.dart';

class MockInfoController extends Mock implements InfoController {}

void main() {
  late MockInfoController mockController;

  setUp(() {
    mockController = MockInfoController();
  });

  test('labelListProvider returns labels map', () async {
    final labels = {
      'greeting': {'en': 'Hello', 'it': 'Ciao'}
    };

    when(() => mockController.getLabels(lang: any(named: 'lang')))
        .thenAnswer((_) async => labels);

    final container = ProviderContainer(
      overrides: [
        infoProvider.overrideWithValue(mockController),
      ],
    );

    final result = await container.read(labelListProvider('en').future);

    expect(result, labels);
    verify(() => mockController.getLabels(lang: 'label_en')).called(1);
  });

  test('breedListProvider returns list of breeds', () async {
    final breeds = ['Labrador', 'Beagle', 'Poodle'];

    when(() => mockController.getAllBreeds()).thenAnswer((_) async => breeds);

    final container = ProviderContainer(
      overrides: [
        infoProvider.overrideWithValue(mockController),
      ],
    );

    final result = await container.read(breedListProvider.future);

    expect(result, breeds);
    verify(() => mockController.getAllBreeds()).called(1);
  });
}
