import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/infoBox.dart';
import '../models/dog.dart';
import '../providers/dog_detail_view_provider.dart';

class DogDetailsView extends ConsumerWidget {
  final Dog dog;

  const DogDetailsView({super.key, required this.dog});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    value: '${dog.years} years',
                    color: const Color(0xFFFFE3CC),
                  ),
                ),
                Expanded(
                  child: InfoBox(
                    label: 'Gender',
                    value: dog.isFemale ? 'Female' : 'Male',
                    color: const Color(0xFFFFE3CC),
                  ),
                ),
                Expanded(
                  child: InfoBox(
                    label: 'Weight',
                    value: '${dog.weight.toStringAsFixed(1)} kg',
                    color: const Color(0xFFFFE3CC),
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
              ref.read(dogDetailViewProvider.notifier).state =
                  DogDetailView.recordAudioWidget;
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFA5A5),
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
