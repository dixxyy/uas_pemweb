import 'package:flutter/material.dart';
import 'theme_mode.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = AppTheme.darkMode;

  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == AppTheme.darkMode) {
      themeData = AppTheme.lightMode;
    } else {
      themeData = AppTheme.darkMode;
    }
  }
}
