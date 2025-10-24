import 'package:flutter/material.dart';

const _seed = Color(0xFF086972);

ThemeData _base(ColorScheme scheme) => ThemeData(
  useMaterial3: true,
  colorScheme: scheme,
  scaffoldBackgroundColor: scheme.surface,
  appBarTheme: AppBarTheme(
    backgroundColor: scheme.surface,
    foregroundColor: scheme.onSurface,
    elevation: 0,
    centerTitle: false,
  ),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
  ),
  cardTheme: CardThemeData(
    color: scheme.surface,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
  snackBarTheme: SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    backgroundColor: scheme.inverseSurface,
    contentTextStyle: TextStyle(color: scheme.onInverseSurface),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  chipTheme: ChipThemeData(
    side: BorderSide(color: scheme.outlineVariant),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
);

ThemeData buildTheme() => _base(ColorScheme.fromSeed(seedColor: _seed));
ThemeData buildDarkTheme() =>
    _base(ColorScheme.fromSeed(seedColor: _seed, brightness: Brightness.dark));
