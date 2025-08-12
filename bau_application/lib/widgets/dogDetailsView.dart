import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/theme.dart';
import '../providers/dog_provider.dart';
import '../screenList/dogInputScreen.dart';
import '../widgets/infoBox.dart';

String calculateAge(DateTime birthDate) {
  final today = DateTime.now();
  int age = today.year - birthDate.year;

  if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
    age--;
  }

  if (age > 0) {
    return '$age years old';
  } else {
    int days = today.difference(birthDate).inDays;
    return '$days days old';
  }
}

class DogDetailsView extends ConsumerWidget {

  const DogDetailsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dog = ref.watch(dogProvider).selected!;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dog.name,
            style: AppTextStyles.font(context, FontWeight.w700, 48),
          ),
          const SizedBox(height: 6),
          Text(
            dog.breed,
            style: AppTextStyles.font(context, FontWeight.w500, 18, Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: InfoBox(
                    label: 'Age',
                    value: calculateAge(dog.birthDate),
                    color: AppColors.secondary,
                  ),
                ),
                Expanded(
                  child: InfoBox(
                    label: 'Gender',
                    value: dog.isFemale ? 'Female' : 'Male',
                    color: AppColors.secondary,
                  ),
                ),
                Expanded(
                  child: InfoBox(
                    label: 'Weight',
                    value: '${dog.weight.toStringAsFixed(1)} kg',
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
          ),

          // Spacer to push the button to the bottom
          const Spacer(),

          // Button to switch to Record Audio view
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => DogInputScreen(),
                transitionDuration: const Duration(milliseconds: 150),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              ));

            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: Text(
                textAlign: TextAlign.center,
                'What is ${dog.name} saying?',
                style: AppTextStyles.font(context, FontWeight.w600, 26, Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
