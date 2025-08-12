import 'package:bau_application/screenList/dogEditScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/theme.dart';
import '../providers/dog_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/dogDetailsView.dart';
import 'dogInputScreen.dart';
import 'dogListScreen.dart';

class DogDetailsScreen extends ConsumerWidget {

  const DogDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dog = ref.watch(dogProvider).selected!;
    return Scaffold(
      body: Stack(
        children: [
          // Sfondo immagine
          Positioned.fill(
            child: Image.asset(
              'assets/images/backgroundPattern.png',
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                Stack(
                  children: [
                    Image.asset(
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
                            Navigator.of(context).pushAndRemoveUntil(
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) => const DogListScreen(),
                                transitionDuration: const Duration(milliseconds: 150),
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  return FadeTransition(opacity: animation, child: child);
                                },
                              ),
                                  (route) => false,
                            );
                          },
                        ),
                      ),
                    ),

// Edit Button
                    Positioned(
                      top: 12,
                      right: 60,
                      child: CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white),
                          onPressed: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) => DogEditScreen(dog: dog),
                                transitionDuration: const Duration(milliseconds: 150),
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  return FadeTransition(opacity: animation, child: child);
                                },
                              )
                            );
                          },
                        ),
                      ),
                    ),

// Delete Button
                    Positioned(
                      top: 12,
                      right: 12,
                      child: CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.white),
                          onPressed: () async {
                            final shouldDelete = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Remove Dog'),
                                content: const Text('Are you sure you want to remove this dog?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: const Text('Delete', style: TextStyle(color: AppColors.red)),
                                  ),
                                ],
                              ),
                            );

                            if (shouldDelete == true) {
                              final dog = ref.read(dogProvider).selected;
                              final user = ref.read(userProvider);

                              if (dog != null && user != null) {
                                try {
                                  await ref.read(dogProvider.notifier).deleteDog(dog.id, user.id.toString());
                                  await ref.read(dogProvider.notifier).reloadDogs(user.id.toString());

                                  if (context.mounted) {
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(builder: (context) => const DogListScreen()),
                                          (route) => false,
                                    );
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Failed to delete dog: $e')),
                                    );
                                  }
                                }
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                // Parte sotto la foto: DogDetailsView
                Expanded(
                  child: DogDetailsView(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
