import 'package:ARKidsWorld/app/pages/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  Locale _locale = const Locale('en');
  bool _isRestarting = false;

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;

  AppProvider() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    // تحميل الثيم
    final savedTheme = prefs.getString('theme_mode');
    if (savedTheme != null) {
      _themeMode = savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
    }

    // تحميل اللغة
    final savedLanguage = prefs.getString('language_code');
    if (savedLanguage != null) {
      _locale = Locale(savedLanguage);
    }

    notifyListeners();
  }

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    _saveThemePreference();
    notifyListeners();
  }

  Future<void> changeLanguage(Locale locale, BuildContext context) async {
    if (_isRestarting) return;
    _isRestarting = true;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
    await context.setLocale(locale);

    await Future.delayed(const Duration(milliseconds: 100));
    _restartApp(context);
  }

  void _restartApp(BuildContext context) {
    if (!context.mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const WelcomePage()),
              (route) => false,
        );
        _isRestarting = false;
      }
    });
  }

  void _saveThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', _themeMode == ThemeMode.dark ? 'dark' : 'light');
  }
}