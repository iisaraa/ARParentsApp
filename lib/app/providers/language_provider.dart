import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  LanguageProvider() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString('language_code');
      if (languageCode != null && languageCode.isNotEmpty) {
        _locale = Locale(languageCode);
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading language: $e');
    }
  }

  Future<void> changeLanguage(Locale locale, BuildContext context) async {
    if (_locale == locale) return;

    _locale = locale;

    try {
      // حفظ اللغة
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language_code', locale.languageCode);

      // تغيير اللغة في easy_localization
      await context.setLocale(locale);

      notifyListeners();
    } catch (e) {
      debugPrint('Error changing language: $e');
    }
  }
}