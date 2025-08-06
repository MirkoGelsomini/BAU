import 'package:bau_application/models/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/dog_detail_view_provider.dart';
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

  Future<void> _submitFeedback(bool isCorrectPressed) async {
    final prediction = ref.read(predictionProvider);
    final transactionId = prediction?.transactionId;
    final topPredictionLabel = prediction?.predictions.first.label;

    if (!isCorrectPressed && (_selectedLabelKey == null || _selectedLabelKey!.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Per favore seleziona una label corretta')),
      );
      return;
    }

    if (transactionId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Errore: transactionId mancante')),
      );
      return;
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Feedback inviato con successo')),
      );
      _feedbackCommentController.clear();
      setState(() {
        _isCorrect = true;
        _selectedLabelKey = null;
      });
      ref.read(dogDetailViewProvider.notifier).state = DogDetailView.dogDetailWidget;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Errore durante l\'invio del feedback')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dog = ref.watch(dogProvider).selected!;
    final prediction = ref.watch(predictionProvider);
    final langCode = Localizations.localeOf(context).languageCode;
    final labelsAsync = ref.watch(labelListProvider(langCode));

    if (prediction == null || prediction.predictions.isEmpty) {
      return const Center(child: Text('Nessuna prediction disponibile'));
    }

    final topPrediction = prediction.predictions.first;
    final emojiLabel = topPrediction.getLabel(langCode).characters.first;
    final description = topPrediction.getLabel(langCode).characters.skip(1).toString().trimLeft();

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
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 28),
                    ),
                    const SizedBox(height: 40),
                    Column(
                      children: [
                        Text(
                          emojiLabel,
                          style: const TextStyle(fontSize: 100),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          description,
                          style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                      ],
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
                              underline: const SizedBox(), // rimuove la linea sotto il dropdown
                              hint: const Text('Seleziona label corretta'),
                              value: _selectedLabelKey,
                              items: labelsMap.entries.map((entry) {
                                return DropdownMenuItem<String>(
                                  value: entry.key,
                                  child: Text(entry.value),
                                );
                              }).toList(),
                              onChanged: (newValue) => setState(() => _selectedLabelKey = newValue),
                            ),
                          );
                        },
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (err, _) => const Text('Errore nel caricamento delle label'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _feedbackCommentController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Scrivi un commento...',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ],
                ),
              ),
            ),
            // Pulsanti sempre in fondo
            if (_isCorrect)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isLoading
                          ? null
                          : () async {
                        setState(() => _isCorrect = true);
                        await _submitFeedback(true);
                        Navigator.of(context)
                            .push(
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) =>
                            const ThankYouScreen(),
                            transitionDuration: const Duration(milliseconds: 150),
                            transitionsBuilder:
                                (context, animation, secondaryAnimation, child) {
                              return FadeTransition(opacity: animation, child: child);
                            },
                          ),
                        );
                      },
                      icon: const Icon(Icons.check),
                      label: const Text('È corretto'),
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
                        setState(() => _isCorrect = false);
                        Navigator.of(context)
                            .push(
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) =>
                            const ThankYouScreen(),
                            transitionDuration: const Duration(milliseconds: 150),
                            transitionsBuilder:
                                (context, animation, secondaryAnimation, child) {
                              return FadeTransition(opacity: animation, child: child);
                            },
                          ),
                        );
                      },
                      icon: const Icon(Icons.close),
                      label: const Text('Non è corretto'),
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
                onPressed: _isLoading
                    ? null
                    : () async {
                  await _submitFeedback(false);
                },
                label: _isLoading ? const Text('Invio...') : const Text('Invia'),
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
