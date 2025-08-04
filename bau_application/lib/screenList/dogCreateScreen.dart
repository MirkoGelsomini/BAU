import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/dog.dart';
import '../providers/dog_provider.dart';
import '../providers/user_provider.dart';

class DogCreateScreen extends ConsumerStatefulWidget {
  const DogCreateScreen({super.key});

  @override
  ConsumerState<DogCreateScreen> createState() => _DogCreateScreenState();
}

class _DogCreateScreenState extends ConsumerState<DogCreateScreen> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _breedCtrl = TextEditingController();
  bool? _isFemale;
  double _weightSliderValue = 10.0;
  int _yearsSliderValue = 1;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _breedCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_nameCtrl.text.isEmpty || _breedCtrl.text.isEmpty || _isFemale == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final userId = ref.read(userProvider)!.id.toString();

    final newDog = Dog(
      id: '',
      name: _nameCtrl.text,
      breed: _breedCtrl.text,
      isFemale: _isFemale!,
      weight: _weightSliderValue,
      years: _yearsSliderValue,
      imageUrl: 'https://picsum.photos/300/200', // placeholder o campo da aggiungere
      isFavorite: false,
    );

    try {
      await ref.read(dogProvider.notifier).addDog(newDog, userId);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      print('Errore creazione cane: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore durante la creazione: $e')),
      );
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
                      'Add New Dog',
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
                  activeTrackColor: const Color(0xFFFFA5A5),
                  inactiveTrackColor: const Color(0xFFFFE3CC),
                  thumbColor: const Color(0xFFFFA5A5),
                  overlayColor: const Color(0xFFFFA5A5).withAlpha(32),
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
                    activeColor: const Color(0xFFFFA5A5),
                    onChanged: (v) => setState(() => _isFemale = v!),
                  ),
                  Text('Female', style: GoogleFonts.poppins()),
                  const SizedBox(width: 20),
                  Radio<bool>(
                    value: false,
                    groupValue: _isFemale,
                    onChanged: (v) => setState(() => _isFemale = v!),
                    activeColor: const Color(0xFFFFA5A5),
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
                  activeTrackColor: const Color(0xFFFFA5A5),
                  inactiveTrackColor: const Color(0xFFFFE3CC),
                  thumbColor: const Color(0xFFFFA5A5),
                  overlayColor: const Color(0xFFFFA5A5).withAlpha(32),
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
                  backgroundColor: const Color(0xFFFFE3CC),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  textStyle: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: Text(
                  'Save',
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
