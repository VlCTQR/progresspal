import 'package:flutter/material.dart';
import 'package:trackerstacker/configuration/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  get themeMode => _themeMode;

  toggleTheme(bool isDark) async {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    Globals.themeModeGlobal = _themeMode;
    notifyListeners();

    // Save the theme mode to SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme_mode', isDark ? 1 : 0);
  }
}
