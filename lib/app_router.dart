import 'package:flutter/material.dart';
import 'features/auth/splash_page.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'widgets/MainScaffold.dart';

Route<dynamic> onGenerateRoute(RouteSettings s) {
  switch (s.name) {
    case '/':
      return MaterialPageRoute(builder: (_) => const SplashPage());
    case '/login':
      return MaterialPageRoute(builder: (_) => const LoginScreen());

    case '/signup':
      return MaterialPageRoute(builder: (_) => const OnboardingScreen());

    case '/dashboard':
      return MaterialPageRoute(builder: (_) => const MainScaffold());

    default:
      return MaterialPageRoute(builder: (_) => const SplashPage());
  }
}

String initialRoute() => '/';
