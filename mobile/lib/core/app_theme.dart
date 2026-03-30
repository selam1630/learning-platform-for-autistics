import 'package:flutter/material.dart';

ThemeData buildAppTheme() {
  const seedColor = Color(0xFF1D6F5F);

  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: const Color(0xFFF6F3EB),
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: Color(0xFF17352E),
      elevation: 0,
      centerTitle: false,
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  );
}
