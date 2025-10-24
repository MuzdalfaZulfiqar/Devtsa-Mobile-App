import 'package:flutter/material.dart';
import 'app_router.dart';
import 'theme/app_theme.dart';

void main() => runApp(const DevApp());

class DevApp extends StatelessWidget {
  const DevApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DevSta',
      theme: buildTheme(),
      themeMode: ThemeMode.light,
      initialRoute: initialRoute(),
      onGenerateRoute: onGenerateRoute,
      debugShowCheckedModeBanner: false, 
    );
  }
}
