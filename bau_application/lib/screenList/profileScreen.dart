import 'package:bau_application/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/theme.dart';

class ProfileScreen extends ConsumerWidget {
  final VoidCallback onLogout;

  const ProfileScreen({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('No user data')),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // Sfondo
          Positioned.fill(
            child: Image.asset(
              'assets/images/backgroundPattern.png',
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pulsante back
                  Align(
                    alignment: Alignment.topLeft,
                    child: CircleAvatar(
                      backgroundColor: Colors.black54,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Immagine profilo
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: const AssetImage('assets/images/profilePicture.png'),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Nome
                  Text(
                    '${user.firstName} ${user.lastName}',
                    style: AppTextStyles.font(context, FontWeight.bold, 28),
                  ),
                  const SizedBox(height: 8),

                  // Email
                  Text(
                    'Email: ${user.email}',
                    style: AppTextStyles.font(context, null, 16),
                  ),
                  const SizedBox(height: 8),

                  // Età
                  Text(
                    'Age: ${user.age}',
                    style: AppTextStyles.font(context, null, 16),
                  ),
                  const SizedBox(height: 8),

                  // Paese
                  Text(
                    'Country: ${user.country}',
                    style: AppTextStyles.font(context, null, 16),
                  ),

                  const Spacer(),

                  // Logout button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(userProvider.notifier).clearUser();
                        onLogout();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFA5A5),
                        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Logout',
                        style: AppTextStyles.font(context, FontWeight.bold, 18, Colors.black),
                      ),
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
