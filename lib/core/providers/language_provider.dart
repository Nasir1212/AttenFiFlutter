import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _currentLocale = const Locale('bn'); // ডিফল্ট ভাষা বাংলা
  static const String _languageKey = 'selected_language';

  Locale get currentLocale => _currentLocale;

  LanguageProvider() {
    _loadLanguage(); // প্রোভাইডার তৈরি হওয়ার সময় সেভ থাকা ভাষা লোড হবে
  }

  // 🔑 ১. ডাটাবেজ থেকে ভাষা রিড করা (App open হওয়ার সময়)
  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final String? languageCode = prefs.getString(_languageKey);

    if (languageCode != null) {
      _currentLocale = Locale(languageCode);
      notifyListeners();
    }
  }

  // 🔑 ২. নতুন ভাষা সেভ করা এবং UI আপডেট করা
  Future<void> changeLanguage(Locale locale) async {
    if (_currentLocale == locale) return;

    _currentLocale = locale;
    notifyListeners();

    // SharedPreferences-এ ভাষা সেভ করে রাখা হচ্ছে
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, locale.languageCode);
  }
}
