import 'dart:async';
import 'package:flutter/material.dart';
import '../../state/app_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fade = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  );

  @override
  void initState() {
    super.initState();
    _fade.forward();

    // Keep splash visible for 2.5 seconds
    Timer(const Duration(milliseconds: 2500), () {
      final route = AppState().isSignedIn ? '/home' : '/login';
      if (mounted) Navigator.pushReplacementNamed(context, route);
    });
  }

  @override
  void dispose() {
    _fade.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.primary, // Use primary color
      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: _fade,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo
                Container(
                  decoration: BoxDecoration(
                    color: cs.onPrimary.withOpacity(0.1),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: cs.onPrimary.withOpacity(0.2),
                        blurRadius: 12,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Icon(Icons.description, size: 96, color: cs.onPrimary),
                ),
                const SizedBox(height: 24),
                Text(
                  'Empowering Developers\nConnecting Innovation',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: cs.onPrimary,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                ),
                const SizedBox(height: 16),
                // Optional tagline / progress indicator
                SizedBox(
                  height: 4,
                  width: 120,
                  child: LinearProgressIndicator(
                    color: cs.onPrimary,
                    backgroundColor: cs.onPrimary.withOpacity(0.3),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
