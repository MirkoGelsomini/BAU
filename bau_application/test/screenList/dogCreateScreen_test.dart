import 'package:bau_application/providers/info_provider.dart';
import 'package:bau_application/screenList/dogCreateScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('DogCreateScreen - complete data entry test', (tester) async {
    final testBreedProvider = FutureProvider.autoDispose<List<String>>((ref) async {
      return ['Labrador', 'Beagle', 'Poodle'];
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          breedListProvider.overrideWithProvider(testBreedProvider),
        ],
        child: const MaterialApp(home: DogCreateScreen()),
      ),
    );

    await tester.pumpAndSettle();

    // Name input
    final nameField = find.byType(TextField).first;
    await tester.enterText(nameField, 'Fido');
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TextField, 'Fido'), findsOneWidget);

    // Breed dropdown
    final dropdownFinder = find.byType(DropdownButtonFormField<String>);
    expect(dropdownFinder, findsOneWidget);
    await tester.tap(dropdownFinder);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Labrador').last);
    await tester.pumpAndSettle();
    expect(find.text('Labrador'), findsOneWidget);

    // Gender radio buttons
    final radios = find.byType(Radio<bool>);
    expect(radios, findsNWidgets(2));
    final maleRadio = radios.at(1);
    await tester.tap(maleRadio);
    await tester.pumpAndSettle();
    final maleRadioWidget = tester.widget<Radio<bool>>(maleRadio);
    expect(maleRadioWidget.groupValue, false);

    // Birth date picker
    await tester.tap(find.text('Select birth date'));
    await tester.pumpAndSettle();
    final today = DateTime.now();
    await tester.tap(find.text(today.day.toString()));
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    final dobText = find.textContaining(RegExp(r'\d{1,2}/\d{1,2}/\d{4}'));
    expect(dobText, findsOneWidget);

    // Weight slider
    final weightSlider = find.byType(Slider);
    await tester.drag(weightSlider, const Offset(300.0, 0.0));
    await tester.pumpAndSettle();
    final weightText = find.textContaining(RegExp(r'\d+ (kg|g)'));
    expect(weightText, findsOneWidget);
  });
}

