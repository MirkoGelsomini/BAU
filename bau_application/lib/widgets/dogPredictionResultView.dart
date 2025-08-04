import 'package:bau_application/controllers/feedback_controller.dart';
import 'package:bau_application/widgets/podiumWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/dog_detail_view_provider.dart';
import '../providers/feedback_provider.dart';
import '../providers/prediction_provider.dart';

class DogPredictionResultsView extends ConsumerStatefulWidget {
  const DogPredictionResultsView({super.key});

  @override
  ConsumerState<DogPredictionResultsView> createState() => _DogPredictionResultsViewState();
}

class _DogPredictionResultsViewState extends ConsumerState<DogPredictionResultsView> {
  final TextEditingController _feedbackCommentController = TextEditingController();
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isCorrect = true;
  String? _selectedLabelKey;
  bool _isLoading = false; // Stato di caricamento

  @override
  void dispose() {
    _feedbackCommentController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<bool> _submitFeedback() async {
    final correctLabel = _selectedLabelKey;
    final comment = _feedbackCommentController.text.trim();

    if (!_isCorrect && (_selectedLabelKey == null || _selectedLabelKey!.isEmpty)) {
      if (!mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Per favore seleziona una label corretta')),
      );
      return false;
    }

    final prediction = ref.read(predictionProvider);
    final transactionId = prediction?.transactionId;
    final topPredictionLabel = prediction?.predictions.first.label;

    if (transactionId == null) {
      if (!mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Errore: transactionId mancante')),
      );
      return false;
    }

    setState(() => _isLoading = true);

    final feedback = FeedbackData(
      transactionId: transactionId,
      isCorrect: _isCorrect,
      correctLabel: _isCorrect ? topPredictionLabel : correctLabel,
      comment: comment.isEmpty ? null : comment,
    );

    final result = await ref.read(feedbackProvider(feedback).future);

    if (!mounted) return false;

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
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Errore durante l\'invio del feedback')),
      );
      return false;
    }
  }

  void _onPageChanged(int index) {
    FocusScope.of(context).unfocus();
    setState(() {
      _currentPage = index;
    });
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(2, (index) {
        bool isActive = _currentPage == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: isActive ? 24 : 16,
          height: 6,
          decoration: BoxDecoration(
            color: isActive ? Colors.blueAccent : Colors.grey[400],
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prediction = ref.watch(predictionProvider);
    final langCode = Localizations.localeOf(context).languageCode;
    final labelsAsync = ref.watch(labelListProvider(langCode));

    if (prediction == null || prediction.predictions.isEmpty) {
      return const Center(child: Text('Nessuna prediction disponibile'));
    }

    final top3List = prediction.predictions.length >= 3
        ? prediction.predictions.sublist(0, 3)
        : prediction.predictions;

    final top3 = top3List
        .map((p) => PredictionItem(p.getLabel(langCode), p.confidence))
        .toList();

    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Prediction Results',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 36,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 220,
                      child: PodiumWidget(top3: top3),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Text(
                          'Leave Feedback',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 36,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Radio<bool>(
                            value: true,
                            groupValue: _isCorrect,
                            onChanged: (value) {
                              setState(() {
                                _isCorrect = value!;
                                _feedbackCommentController.clear();
                              });
                            },
                          ),
                          const Text('Prediction corretta'),
                          const SizedBox(width: 20),
                          Radio<bool>(
                            value: false,
                            groupValue: _isCorrect,
                            onChanged: (value) {
                              setState(() {
                                _isCorrect = value!;
                              });
                            },
                          ),
                          const Text('Prediction errata'),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (!_isCorrect) ...[
                        labelsAsync.when(
                          data: (labelsMap) {
                            return DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: 'Label corretta',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              value: _selectedLabelKey,
                              items: labelsMap.entries.map((entry) {
                                final key = entry.key;
                                final value = entry.value;

                                return DropdownMenuItem<String>(
                                  value: key,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newKey) {
                                setState(() {
                                  _selectedLabelKey = newKey;
                                });
                              },
                            );
                          },
                          loading: () => const Center(child: CircularProgressIndicator()),
                          error: (err, stack) => const Text('Errore nel caricamento delle label'),
                        ),
                        const SizedBox(height: 12),
                      ],
                      TextField(
                        controller: _feedbackCommentController,
                        maxLines: 6,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          hintText: 'Write your feedback here...',
                          labelText: _isCorrect ? 'Commento (opzionale)' : 'Commento',
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        _buildPageIndicator(),
        const SizedBox(height: 12),

        // MOSTRA IL BOTTONE SOLO NELLA SECONDA PAGINA
        if (_currentPage == 1)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SizedBox(
              width: double.infinity,
              child: GestureDetector(
                onTap: _isLoading
                  ? null
                    : () async {
                    FocusScope.of(context).unfocus();
                    final success = await _submitFeedback();
                    if (success) {
                      ref.read(dogDetailViewProvider.notifier).state = DogDetailView.dogDetailWidget;
                    }
                    },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: _isLoading ? Colors.grey : const Color(0xFFFFA5A5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Submit feedback',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
