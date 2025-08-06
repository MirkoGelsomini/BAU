import 'package:bau_application/providers/dog_detail_view_provider.dart';
import 'package:flutter/material.dart';

import 'dogDetailScreen.dart';

class ThankYouScreen extends StatefulWidget {
  const ThankYouScreen({super.key});

  @override
  State<ThankYouScreen> createState() => _ThankYouScreenState();
}

class _ThankYouScreenState extends State<ThankYouScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;
  bool _visible = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Fade-in dopo 500ms
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _visible = true;
        });
      }
    });

    // Posticipa la navigazione dopo il primo frame
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(seconds: 2));

      int count = 0;
      Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const DogDetailsScreen(),
          transitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
            (route) {
          count++;
          // lascia solo le prime 2 pagine
          return count <= 2;
        },
      );

    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedOpacity(
          opacity: _visible ? 1 : 0,
          duration: const Duration(seconds: 1),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ScaleTransition(
                scale: _pulseAnimation,
                child: const Icon(
                  Icons.favorite,
                  color: Colors.redAccent,
                  size: 100,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Grazie per il tuo feedback!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

