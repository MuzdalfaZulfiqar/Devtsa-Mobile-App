import 'package:flutter/material.dart';
import 'features/auth/splash_page.dart';
import 'features/auth/login_page.dart';
import 'features/auth/signup_step1_page.dart'; 
import 'features/auth/signup_step2_page.dart';
import 'features/home/home_page.dart';
import 'features/profile/profile_page.dart';
import 'features/resume/resume_edit_page.dart';
import 'features/resume/resume_preview_page.dart';

Route<dynamic> onGenerateRoute(RouteSettings s) {
  switch (s.name) {
    case '/': return MaterialPageRoute(builder: (_) => const SplashPage());
    case '/login': return MaterialPageRoute(builder: (_) => const LoginPage());
    case '/signup/step1': return MaterialPageRoute(builder: (_) => const SignUpStep1Page()); 
    case '/signup/step2': return MaterialPageRoute(builder: (_) => const SignUpStep2Page()); 
    case '/home': return MaterialPageRoute(builder: (_) => const HomePage());
    case '/profile': return MaterialPageRoute(builder: (_) => const ProfilePage());
    case '/resume/edit': return MaterialPageRoute(builder: (_) => const ResumeEditPage());
    case '/resume/preview': return MaterialPageRoute(builder: (_) => const ResumePreviewPage());
    default: return MaterialPageRoute(builder: (_) => const SplashPage());
  }
}

String initialRoute() => '/';
