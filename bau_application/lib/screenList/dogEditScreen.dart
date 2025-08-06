import 'package:bau_application/models/theme.dart';
import 'package:bau_application/providers/loading_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/dog.dart';
import '../providers/dog_provider.dart';
import '../providers/user_provider.dart';

class DogEditScreen extends ConsumerStatefulWidget {
  final Dog dog;
  const DogEditScreen({super.key, required this.dog});

  @override
  ConsumerState<DogEditScreen> createState() => _DogEditScreenState();
}

class _DogEditScreenState extends ConsumerState<DogEditScreen> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _breedCtrl;
  bool? _isFemale;
  late double _weightSliderValue;
  late int _yearsSliderValue;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.dog.name);
    _breedCtrl = TextEditingController(text: widget.dog.breed);
    _isFemale = widget.dog.isFemale;
    _weightSliderValue = widget.dog.weight;
    _yearsSliderValue = widget.dog.years;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _breedCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final updated = widget.dog.copyWith(
      name: _nameCtrl.text,
      breed: _breedCtrl.text,
      weight: _weightSliderValue,
      isFemale: _isFemale ?? widget.dog.isFemale,
      years: _yearsSliderValue,
    );

    final userId = ref.read(userProvider)!.id.toString();
    try {
      await ref.read(dogProvider.notifier).updateDog(updated, userId);
      await ref.read(dogProvider.notifier).reloadDogs(userId);
      Navigator.pop(context);
    } catch (e) {
      // mostra un errore, snack bar, ecc.
      print('Errore aggiornamento cane: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Back arrow and title row
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: Text(
                      'Edit Dog',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: theme.textTheme.headlineSmall?.fontSize ?? 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),

              const SizedBox(height: 24),

              // Name
              TextField(
                controller: _nameCtrl,
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: GoogleFonts.poppins(),
                  prefixIcon: const Icon(Icons.pets),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                style: GoogleFonts.poppins(),
              ),
              const SizedBox(height: 16),

              // Breed
              TextField(
                controller: _breedCtrl,
                decoration: InputDecoration(
                  labelText: 'Breed',
                  labelStyle: GoogleFonts.poppins(),
                  prefixIcon: const Icon(Icons.info_outline),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                style: GoogleFonts.poppins(),
              ),
              const SizedBox(height: 24),

              // Weight slider
              Text(
                'Weight: ${_weightSliderValue.toStringAsFixed(1)} kg',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: theme.textTheme.titleMedium?.fontSize ?? 16,
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppColors.primary,
                  inactiveTrackColor: AppColors.secondary,
                  thumbColor: AppColors.primary,
                  overlayColor: AppColors.secondary.withAlpha(32),
                ),
                child: Slider(
                  value: _weightSliderValue,
                  min: 1,
                  max: 50,
                  divisions: 49,
                  label: '${_weightSliderValue.toStringAsFixed(1)} kg',
                  onChanged: (value) {
                    setState(() {
                      _weightSliderValue = value;
                    });
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Gender
              Text(
                'Gender',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: theme.textTheme.titleMedium?.fontSize ?? 16,
                ),
              ),
              Row(
                children: [
                  Radio<bool>(
                    value: true,
                    groupValue: _isFemale,
                    activeColor: AppColors.primary,
                    onChanged: (v) => setState(() => _isFemale = v!),
                  ),
                  Text('Female', style: GoogleFonts.poppins()),
                  const SizedBox(width: 20),
                  Radio<bool>(
                    value: false,
                    groupValue: _isFemale,
                    onChanged: (v) => setState(() => _isFemale = v!),
                    activeColor: AppColors.primary,
                  ),
                  Text('Male', style: GoogleFonts.poppins()),
                ],
              ),
              const Divider(height: 32),

              // Age slider
              Text(
                'Age: $_yearsSliderValue years old',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: theme.textTheme.titleMedium?.fontSize ?? 16,
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppColors.primary,
                  inactiveTrackColor: AppColors.secondary,
                  thumbColor: AppColors.primary,
                  overlayColor: AppColors.secondary.withAlpha(32),
                ),
                child: Slider(
                  value: _yearsSliderValue.toDouble(),
                  min: 1,
                  max: 20,
                  divisions: 19,
                  label: '$_yearsSliderValue years',
                  onChanged: (value) {
                    setState(() {
                      _yearsSliderValue = value.round();
                    });
                  },
                ),
              ),

              const SizedBox(height: 36),

              // Save button
              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  textStyle: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: Text(
                  'Save Changes',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: theme.textTheme.headlineSmall?.fontSize ?? 24,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
