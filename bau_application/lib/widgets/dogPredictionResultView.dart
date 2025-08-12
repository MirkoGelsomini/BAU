import 'package:bau_application/models/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/dog_provider.dart';
import '../providers/feedback_provider.dart';
import '../providers/info_provider.dart';
import '../providers/prediction_provider.dart';
import '../screenList/greetingsScreen.dart';

class DogPredictionResultsView extends ConsumerStatefulWidget {
  const DogPredictionResultsView({super.key});

  @override
  ConsumerState<DogPredictionResultsView> createState() => _DogPredictionResultsViewState();
}

class _DogPredictionResultsViewState extends ConsumerState<DogPredictionResultsView> {
  final TextEditingController _feedbackCommentController = TextEditingController();
  bool _isCorrect = true;
  String? _selectedLabelKey;
  bool _isLoading = false;

  @override
  void dispose() {
    _feedbackCommentController.dispose();
    super.dispose();
  }

  Future<bool> _submitFeedback(bool isCorrectPressed) async {
    final prediction = ref.read(predictionProvider);
    final transactionId = prediction?.transactionId;
    final topPredictionLabel = prediction?.predictions.first.label;

    if (!isCorrectPressed && (_selectedLabelKey == null || _selectedLabelKey!.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a label')),
      );
      return false;
    }

    if (transactionId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: transactionId missing')),
      );
      return false;
    }

    setState(() => _isLoading = true);

    final feedback = FeedbackData(
      transactionId: transactionId,
      isCorrect: isCorrectPressed,
      correctLabel: isCorrectPressed ? topPredictionLabel : _selectedLabelKey,
      comment: _feedbackCommentController.text.trim().isEmpty
          ? null
          : _feedbackCommentController.text.trim(),
    );

    final result = await ref.read(feedbackProvider(feedback).future);

    setState(() => _isLoading = false);

    if (result) {
      _feedbackCommentController.clear();
      setState(() {
        _isCorrect = true;
        _selectedLabelKey = null;
      });
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error while sending feedback')),
      );
      return false;
    }
  }


  @override
  Widget build(BuildContext context) {
    final dog = ref.watch(dogProvider).selected!;
    final prediction = ref.watch(predictionProvider);
    final langCode = Localizations.localeOf(context).languageCode;
    final labelsAsync = ref.watch(labelListProvider(langCode));

    if (prediction == null || prediction.predictions.isEmpty) {
      return const Center(child: Text('No predictions available'));
    }

    final topPrediction = prediction.predictions.first;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Seems that ${dog.name} is saying that...',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.font(context, FontWeight.w600, 28),
                    ),
                    const SizedBox(height: 40),

                    labelsAsync.when(
                      data: (labelsMap) {
                        final status = labelsMap[topPrediction.label]?['status'] ?? 'neutral';
                        final description = labelsMap[topPrediction.label]?['label']?.trimRight() ?? '';
                        final cleanDescription = description.replaceAll(RegExp(r'[^\x00-\x7F]+'), '');

                        return Column(
                          children: [
                            Image.asset(
                              'assets/images/label_images/$status.png',
                              height: 150,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              cleanDescription,
                              style: AppTextStyles.font(context, FontWeight.w600, 22),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (err, _) => const Icon(Icons.error),
                    ),

                    const SizedBox(height: 24),
                    if (!_isCorrect) ...[
                      labelsAsync.when(
                        data: (labelsMap) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: DropdownButton<String>(
                              isExpanded: true,
                              underline: const SizedBox(),
                              hint: const Text('Select correct label'),
                              value: _selectedLabelKey,
                              items: labelsMap.entries.map((entry) {
                                return DropdownMenuItem<String>(
                                  value: entry.key,
                                  child: Text(entry.value['label'] ?? ''),
                                );
                              }).toList(),
                              onChanged: (newValue) => setState(() => _selectedLabelKey = newValue),
                            ),
                          );
                        },
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (err, _) => const Text('Error loading labels'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _feedbackCommentController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Write a feedback...',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ],
                ),
              ),
            ),
            if (_isCorrect)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : () async {
                        final success = await _submitFeedback(true);
                        if (success) {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => const ThankYouScreen(),
                              transitionDuration: const Duration(milliseconds: 150),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                return FadeTransition(opacity: animation, child: child);
                              },
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.check),
                      label: const Text('Is correct'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.green,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: const TextStyle(fontSize: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isLoading
                          ? null
                          : () {
                        setState(() {
                          _isCorrect = false;
                        });
                      },
                      icon: const Icon(Icons.close),
                      label: const Text('Is not correct'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: const TextStyle(fontSize: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ),
                ],
              )
            else
              ElevatedButton.icon(
                onPressed: _isLoading ? null : () async {
                  final success = await _submitFeedback(false);
                  if (success) {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => const ThankYouScreen(),
                        transitionDuration: const Duration(milliseconds: 150),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return FadeTransition(opacity: animation, child: child);
                        },
                      ),
                    );
                  }
                },
                label: _isLoading ? const Text('Sending...') : const Text('Send'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
