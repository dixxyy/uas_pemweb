import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightMode = ThemeData(
      colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.purple,
    brightness: Brightness.light,
    // primary: Colors.grey.shade300,
    // secondary: Colors.grey.shade200
  ));

  static ThemeData darkMode = ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.purple,
        brightness: Brightness.dark,
        // primary: Colors.grey.shade800,
        // secondary: Colors.grey.shade700
      ));

  static ThemeData getTheme(bool isDarkMode) {
    return ThemeData(
      useMaterial3: true,
      primaryColor: isDarkMode ? darkMode.primaryColor : lightMode.primaryColor,
    );
  }
}
