import 'package:bau_application/controllers/info_controller.dart';
import 'package:bau_application/models/serverConfig.dart';
import 'package:bau_application/models/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/dog.dart';
import '../providers/dog_provider.dart';
import '../providers/user_provider.dart';
import '../providers/info_provider.dart';

class DogCreateScreen extends ConsumerStatefulWidget {
  const DogCreateScreen({super.key});

  @override
  ConsumerState<DogCreateScreen> createState() => _DogCreateScreenState();
}

class _DogCreateScreenState extends ConsumerState<DogCreateScreen> {
  final infoController = InfoController(baseUrl: ServerConfig.info);
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _breedCtrl = TextEditingController();
  bool? _isFemale;
  DateTime? _birthDate;
  double _weightGrams = 1000;
  bool _useGrams = false;


  @override
  void dispose() {
    _nameCtrl.dispose();
    _breedCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_nameCtrl.text.isEmpty || _breedCtrl.text.isEmpty || _isFemale == null || _birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final name = _nameCtrl.text.trim();
    final breed = _breedCtrl.text;
    final weight = _weightGrams / 1000;
    final isFemale = _isFemale;
    final birthDate = _birthDate;
    final imageUrl = await infoController.getBreedImage(_breedCtrl.text);
    final userId = ref.read(userProvider)!.id.toString();

    final newDog = Dog(
      id: '',
      name: name,
      breed: breed,
      isFemale: isFemale!,
      weight: weight,
      birthDate: birthDate!,
      imageUrl: imageUrl,
      isFavorite: false,
    );

    try {
      await ref.read(dogProvider.notifier).addDog(newDog, userId);
      await ref.read(dogProvider.notifier).reloadDogs(userId);
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
    final breedListAsync = ref.watch(breedListProvider);
    final double weightMinValue = 0;
    final double weightMaxValue = _useGrams ? 1000 : 200000;

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
                      'Register Your Dog',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.font(context, FontWeight.bold, theme.textTheme.headlineSmall?.fontSize ?? 24),
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
                  labelStyle: AppTextStyles.font(),
                  prefixIcon: const Icon(Icons.pets),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                style: AppTextStyles.font(),
              ),
              const SizedBox(height: 16),

              // Breed Dropdown
              breedListAsync.when(
                data: (breeds) {
                  return DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: _breedCtrl.text.isEmpty ? null : _breedCtrl.text,
                    items: breeds.map((breed) {
                      return DropdownMenuItem<String>(
                        value: breed,
                        child: Text(
                          breed,
                          style: TextStyle(color: theme.textTheme.bodyLarge?.color ?? Colors.black),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _breedCtrl.text = val ?? '';
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Breed',
                      labelStyle: AppTextStyles.font(),
                      prefixIcon: const Icon(Icons.info_outline),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    style: AppTextStyles.font(null, FontWeight.w500, 14, theme.textTheme.bodyLarge?.color ?? Colors.black,),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Text('Failed to load breeds: $error'),
              ),

              const Divider(height: 32),

              // Weight slider
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Weight: ${_useGrams ? '${_weightGrams.round()} g' : '${(_weightGrams / 1000).round()} kg'}',
                    style: AppTextStyles.font(context, FontWeight.w600, theme.textTheme.titleMedium?.fontSize ?? 16),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Kg', style: AppTextStyles.font()),
                      Switch(
                        value: _useGrams,
                        activeColor: AppColors.primary,
                        onChanged: (val) {
                          setState(() {
                            _useGrams = val;
                            _weightGrams = 0;
                          });
                        },
                      ),
                      Text('g', style: AppTextStyles.font()),
                    ],
                  ),
                  Builder(builder: (context) {
                    final double weightMinValue = 0;
                    final double weightMaxValue = _useGrams ? 1000 : 200000;
                    final int divisions = _useGrams ? 1000 : 200;

                    return SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: AppColors.primary,
                        inactiveTrackColor: AppColors.secondary,
                        thumbColor: AppColors.primary,
                        overlayColor: AppColors.secondary.withAlpha(32),
                      ),
                      child: Slider(
                        value: _weightGrams.clamp(weightMinValue, weightMaxValue),
                        min: weightMinValue,
                        max: weightMaxValue,
                        divisions: divisions,
                        label: _useGrams
                            ? '${_weightGrams.round()} g'
                            : '${(_weightGrams / 1000).round()} kg',
                        onChanged: (value) {
                          setState(() {
                            _weightGrams = value;
                          });
                        },
                      ),
                    );
                  }),
                ],
              ),

              const Divider(height: 32),

              // Sex
              Text(
                'Sex',
                style: AppTextStyles.font(context, FontWeight.w600, theme.textTheme.titleMedium?.fontSize ?? 16),
              ),
              Row(
                children: [
                  Radio<bool>(
                    value: true,
                    groupValue: _isFemale,
                    activeColor: AppColors.primary,
                    onChanged: (v) => setState(() => _isFemale = v!),
                  ),
                  Text('Female', style: AppTextStyles.font()),
                  const SizedBox(width: 20),
                  Radio<bool>(
                    value: false,
                    groupValue: _isFemale,
                    onChanged: (v) => setState(() => _isFemale = v!),
                    activeColor: AppColors.primary,
                  ),
                  Text('Male', style: AppTextStyles.font()),
                ],
              ),
              const Divider(height: 32),

              // Age slider
              // Birthdate picker
              Text(
                'Birth Date',
                style: AppTextStyles.font(context, FontWeight.w600, theme.textTheme.titleMedium?.fontSize ?? 16),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () async {
                  final today = DateTime.now();
                  final initialDate = _birthDate ?? DateTime(today.year - 1, today.month, today.day);
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: initialDate,
                    firstDate: DateTime(today.year - 30),
                    lastDate: today,
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _birthDate = pickedDate;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _birthDate == null
                        ? 'Select birth date'
                        : '${_birthDate!.day}/${_birthDate!.month}/${_birthDate!.year}',
                    style: AppTextStyles.font(context, null, 16, _birthDate == null ? Colors.grey : Colors.black),
                  ),
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
                  textStyle: AppTextStyles.font(context, FontWeight.bold, 18),
                ),
                child: Text(
                  'Save',
                  style: AppTextStyles.font(context, FontWeight.bold, theme.textTheme.headlineSmall?.fontSize ?? 24, Colors.black,),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
