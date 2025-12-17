import 'package:flutter/material.dart';
import 'features/auth/splash_page.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'features/profile/profile_page.dart';
import 'features/resume/resume_edit_page.dart';
import 'features/resume/resume_preview_page.dart';
import 'features/profile/public_profile_page.dart';
import 'features/feed/feed_page.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/auth/login_screen.dart';
import 'widgets/MainScaffold.dart';

Route<dynamic> onGenerateRoute(RouteSettings s) {
  switch (s.name) {
    case '/':
      return MaterialPageRoute(builder: (_) => const SplashPage());
    case '/login':
      return MaterialPageRoute(builder: (_) => const LoginScreen());
    
    /// 👉 New combined signup + onboarding page
    case '/signup':
      return MaterialPageRoute(builder: (_) => const OnboardingScreen());

    case '/dashboard':
  return MaterialPageRoute(builder: (_) => const MainScaffold());

    case '/profile':
      return MaterialPageRoute(builder: (_) => const ProfilePage());
    case '/resume/edit':
      return MaterialPageRoute(builder: (_) => const ResumeEditPage());
    case '/resume/preview':
      return MaterialPageRoute(builder: (_) => const ResumePreviewPage());
    case '/profile/public':
      return MaterialPageRoute(builder: (_) => const PublicProfilePage());
      case '/feed':
  return MaterialPageRoute(builder: (_) => const FeedPage());

    default:
      return MaterialPageRoute(builder: (_) => const SplashPage());
  }
}

String initialRoute() => '/';
