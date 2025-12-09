// import 'package:flutter/material.dart';
// import 'app_router.dart';
// import 'theme/app_theme.dart';

// void main() => runApp(const DevApp());

// class DevApp extends StatelessWidget {
//   const DevApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'DevSta',
//       theme: buildTheme(),
//       themeMode: ThemeMode.light,
//       initialRoute: initialRoute(),
//       onGenerateRoute: onGenerateRoute,
//       debugShowCheckedModeBanner: false, 
//     );
//   }
// }

// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_router.dart';
import 'theme/app_theme.dart';

import 'services/api_client.dart';
import 'services/auth_service.dart';
import 'repositories/auth_repository.dart';
import '../providers/auth_providers.dart';

void main() {
  // Create shared dependencies once
  final apiClient = ApiClient();
  final authService = AuthService(apiClient);
  final authRepository = AuthRepository(authService);

  runApp(DevApp(authRepository: authRepository));
}

class DevApp extends StatelessWidget {
  final AuthRepository authRepository;

  const DevApp({super.key, required this.authRepository});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authRepository)..init(),
        ),
        // later we can add more providers here (onboarding, posts, etc.)
      ],
      child: MaterialApp(
        title: 'DevSta',
        theme: buildTheme(),
        themeMode: ThemeMode.light,
        initialRoute: initialRoute(),
        onGenerateRoute: onGenerateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
