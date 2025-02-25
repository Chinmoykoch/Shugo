import 'package:flutter/material.dart';

class STextTheme {
  STextTheme._();

  static TextTheme sTextTheme = TextTheme(
    bodyLarge: TextStyle(color: Colors.white, fontSize: 18),
    bodyMedium: TextStyle(color: Colors.white, fontSize: 16),
    bodySmall: TextStyle(color: Colors.white, fontSize: 14),
    headlineLarge: TextStyle(
        color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
    headlineMedium: TextStyle(
        color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
    headlineSmall: TextStyle(
        color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
    titleLarge: TextStyle(color: Colors.white, fontSize: 22),
    titleMedium: TextStyle(color: Colors.white, fontSize: 20),
    titleSmall: TextStyle(color: Colors.white, fontSize: 18),
    labelLarge: TextStyle(color: Colors.white, fontSize: 16),
    labelMedium: TextStyle(color: Colors.white, fontSize: 14),
    labelSmall: TextStyle(color: Colors.white, fontSize: 12),
  );
}
