import 'package:bau_application/providers/user_provider.dart';
import 'package:bau_application/screenList/profileScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/addDogCard.dart';
import '../widgets/dogCard.dart';
import '../providers/dog_provider.dart';
import 'authScreen.dart';
import 'dogDetailScreen.dart';
import 'dogCreateScreen.dart';

class DogListScreen extends ConsumerStatefulWidget {
  const DogListScreen({super.key});

  @override
  ConsumerState<DogListScreen> createState() => _DogListScreenState();
}

class _DogListScreenState extends ConsumerState<DogListScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDogs();
  }

  Future<void> _loadDogs() async {
    final userId = ref.read(userProvider)!.id;
    await ref.read(dogProvider.notifier).loadDogs(userId);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dogs = ref.watch(dogProvider).dogs;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final sortedDogs = [...dogs]..sort((a, b) {
      if (a.isFavorite == b.isFavorite) return 0;
      return a.isFavorite ? -1 : 1;
    });

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/backgroundPattern.png',
              fit: BoxFit.cover,
            ),
          ),

          // Main content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 16 : 24,
                vertical: 12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Your pets',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: isSmallScreen ? 32 : 40,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProfileScreen(
                                onLogout: () {
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(builder: (_) => const AuthScreen()),
                                        (route) => false,
                                  );
                                },
                              ),
                            ),
                          );
                        },
                        child: const CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=3'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Griglia dei cani
                  Expanded(
                    child: GridView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: sortedDogs.length + 1,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: isSmallScreen ? 200 : 250,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: isSmallScreen ? 0.7 : 0.75,
                      ),
                      itemBuilder: (context, index) {
                        if (index == sortedDogs.length) {
                          return AddDogCard(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DogCreateScreen(),
                                ),
                              );
                            },
                          );
                        }

                        final dog = sortedDogs[index];
                        return DogCard(
                          imageUrl: dog.imageUrl,
                          name: dog.name,
                          breed: dog.breed,
                          isFemale: dog.isFemale,
                          years: dog.years,
                          isFavorite: dog.isFavorite,
                          onFavoriteToggle: () {
                            ref.read(dogProvider.notifier).toggleFavorite(dog.id);
                          },
                          onTap: () {
                            ref.read(dogProvider.notifier).selectDog(dog);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DogDetailsScreen(),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
