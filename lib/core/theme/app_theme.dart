import 'package:flutter/material.dart';

class KGLTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.green, // Kigali's clean, green vibe
      useMaterial3: true,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      iconTheme: const IconThemeData(color: Colors.green),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
    );
  }
}