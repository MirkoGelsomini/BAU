import 'package:bau_application/widgets/dogPredictionResultView.dart';
import 'package:bau_application/widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/dog.dart';
import '../providers/dog_detail_view_provider.dart';
import '../providers/dog_provider.dart';

import '../providers/user_provider.dart';
import '../providers/loading_provider.dart'; // import nuovo provider
import '../widgets/dogDetailsView.dart';
import '../widgets/dogInputOption.dart';
import 'dogEditScreen.dart';

class DogDetailScreen extends ConsumerWidget {
  const DogDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dog = ref.watch(dogProvider).selected!;
    final currentView = ref.watch(dogDetailViewProvider);
    final isLoading = ref.watch(isLoadingProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                Image.network(
                  dog.imageUrl,
                  height: 280,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        ref.read(dogDetailViewProvider.notifier).state = DogDetailView.dogDetailWidget;
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                if (currentView == DogDetailView.dogDetailWidget) ...[
                  Positioned(
                    top: 12,
                    right: 56,
                    child: CircleAvatar(
                      backgroundColor: Colors.black54,
                      child: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DogEditScreen(dog: dog),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: CircleAvatar(
                      backgroundColor: Colors.black54,
                      child: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.white),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Dog'),
                              content: const Text('Are you sure you want to delete this dog?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            final userId = ref.read(userProvider)!.id.toString();
                            await ref.read(dogProvider.notifier).deleteDog(dog.id, userId);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ],
            ),

            Expanded(
              child: Stack(
                children: [
                  _viewFor(currentView, dog),
                  if (isLoading)
                    Center(child: AnalyzingAudioScreen()),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _viewFor(DogDetailView view, dog) {
    final views = {
      DogDetailView.dogDetailWidget: DogDetailsView(dog: dog),
      DogDetailView.recordAudioWidget: const DogInputOptions(),
      DogDetailView.predictionResultWidget: DogPredictionResultsView(),
    };
    return views[view] ?? const SizedBox.shrink();
  }
}
