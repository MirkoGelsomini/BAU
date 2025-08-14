import 'package:bau_application/models/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  late double _weightGrams;
  bool _useGrams = true;
  DateTime? _birthDate;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.dog.name);
    _breedCtrl = TextEditingController(text: widget.dog.breed);
    _isFemale = widget.dog.isFemale;
    _weightGrams = widget.dog.weight * 1000; // Converti kg in g
    _useGrams = _weightGrams <= 1000;
    _birthDate = widget.dog.birthDate;
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
      weight: _weightGrams / 1000,
      isFemale: _isFemale ?? widget.dog.isFemale,
      birthDate: _birthDate,
    );

    final userId = ref.read(userProvider)!.id.toString();
    try {
      await ref.read(dogProvider.notifier).updateDog(updated, userId);
      await ref.read(dogProvider.notifier).reloadDogs(userId);
      Navigator.pop(context);
    } catch (e) {
      print('Errore aggiornamento cane: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    double weightMinValue = 0;
    double weightMaxValue = _useGrams ? 1000 : 200000;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: Text(
                      'Update Dog Info',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.font(context, FontWeight.bold,
                          theme.textTheme.headlineSmall?.fontSize ?? 24, Colors.grey[600]),
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

              // Breed
              TextField(
                controller: _breedCtrl,
                decoration: InputDecoration(
                  labelText: 'Breed',
                  labelStyle: AppTextStyles.font(),
                  prefixIcon: const Icon(Icons.info_outline),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                style: AppTextStyles.font(),
              ),
              const SizedBox(height: 24),

              // Weight unit switch
              Text(
                'Weight: ${_useGrams ? '${_weightGrams.round()} g' : '${(_weightGrams / 1000).toStringAsFixed(2)} kg'}',
                style: AppTextStyles.font(context, FontWeight.w600,
                    theme.textTheme.titleMedium?.fontSize ?? 16),
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
                        _weightGrams = 0; // Reset al cambio unità
                      });
                    },
                  ),
                  Text('g', style: AppTextStyles.font()),
                ],
              ),

              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppColors.primary,
                  inactiveTrackColor: AppColors.secondary,
                  thumbColor: AppColors.primary,
                  overlayColor: AppColors.primary.withAlpha(32),
                ),
                child: Slider(
                  value: _weightGrams.clamp(weightMinValue, weightMaxValue),
                  min: weightMinValue,
                  max: weightMaxValue,
                  divisions: _useGrams ? 1000 : 200, // 1g o 1kg
                  label: _useGrams
                      ? '${_weightGrams.round()} g'
                      : '${(_weightGrams / 1000).toStringAsFixed(0)} kg',
                  onChanged: (value) {
                    setState(() {
                      _weightGrams = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Sex
              Text(
                'Sex',
                style: AppTextStyles.font(context, FontWeight.w600,
                    theme.textTheme.titleMedium?.fontSize ?? 16),
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

              // Birth date
              Text(
                'Birth Date',
                style: AppTextStyles.font(context, FontWeight.w600,
                    theme.textTheme.titleMedium?.fontSize ?? 16),
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
                    style: AppTextStyles.font(
                        context, null, 16, _birthDate == null ? Colors.grey : Colors.black),
                  ),
                ),
              ),

              const SizedBox(height: 36),

              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  textStyle: AppTextStyles.font(context, FontWeight.bold, 18),
                ),
                child: Text(
                  'Save Changes',
                  style: AppTextStyles.font(
                      context, FontWeight.bold, theme.textTheme.headlineSmall?.fontSize ?? 24, Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

