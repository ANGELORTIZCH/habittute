import 'package:flutter/material.dart';

import 'dark_mode.dart';
import 'light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  //initialy, light mode
  ThemeData _themeData = lightMode;

  // get current theme
  ThemeData get theme => _themeData;

  // is the current dark theme mode
  bool get isDarkMode => _themeData == darkMode;

  //set theme
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  // toggle theme mode
  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}
