import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/theme.dart';
import '../providers/dog_provider.dart';
import '../screenList/dogInputScreen.dart';
import '../widgets/infoBox.dart';
import '../models/dog.dart';
import '../providers/dog_detail_view_provider.dart';

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
            style: GoogleFonts.poppins(
              fontSize: 48,
              fontWeight: FontWeight.w700,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            dog.breed,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: InfoBox(
                    label: 'Age',
                    value: '${dog.years} years old',
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
                'Talk to the Dog',
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
