import 'dart:async';
import 'package:flutter/material.dart';
import '../../state/app_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late final AnimationController _fade = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  );

  @override
  void initState() {
    super.initState();
    _fade.forward();
    // Keep splash short and sweet
    Timer(const Duration(milliseconds: 1400), () {
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
      backgroundColor: cs.primary, // #086972 derived tones
      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: _fade,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Use assets/logo.png (see pubspec note below)
                Image.asset(
                  'assets/logo.png',
                  height: 150,
                  width: 150,
                  errorBuilder: (_, __, ___) => Icon(Icons.description, size: 96, color: cs.onPrimary),
                ),
                const SizedBox(height: 12),
                Text(
                  'Empowering Developers.\nConnecting Innovation.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: cs.onPrimary,
                        height: 1.25,
                      ),
                ),
                const SizedBox(height: 16),
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(cs.onPrimary),
                  strokeWidth: 2.8,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
