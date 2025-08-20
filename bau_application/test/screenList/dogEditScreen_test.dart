import 'package:bau_application/models/dog.dart';
import 'package:bau_application/providers/info_provider.dart';
import 'package:bau_application/screenList/dogEditScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  group('DogEditScreen Test', () {
    testWidgets('should display dog data correctly', (WidgetTester tester) async {
      final testDog = Dog(
        id: 'dog1',
        name: 'Fido',
        breed: 'Chihuahua',
        isFemale: false,
        imageUrl: 'assets/images/dogs/chihuahua_image.png',
        weight: 12.5, // kg
        birthDate: DateTime(2020, 5, 10),
        isFavorite: false
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            breedListProvider.overrideWithProvider(
              FutureProvider.autoDispose<List<String>>((ref) async {
                return ['Chihuahua', 'Labrador', 'Poodle'];
              }),
            ),
          ],
          child: MaterialApp(
            home: DogEditScreen(dog: testDog),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final nameField = tester.widget<TextField>(find.byType(TextField).first);
      expect(nameField.controller!.text, 'Fido');

      final selectedBreedText = find.text('Chihuahua');
      expect(selectedBreedText, findsOneWidget);

      final maleRadio = find.byWidgetPredicate((widget) =>
      widget is Radio<bool> && widget.value == false && widget.groupValue == false);
      expect(maleRadio, findsOneWidget);

      expect(find.text('Weight: 12.50 kg'), findsOneWidget);

      expect(find.text('10/5/2020'), findsOneWidget);
    });
  });
}
