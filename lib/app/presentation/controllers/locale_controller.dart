import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLocaleController extends ValueNotifier<Locale?> {
  AppLocaleController({SharedPreferencesAsync? preferences})
    : _preferences = preferences ?? SharedPreferencesAsync(),
      super(null);

  static const String _languageCodeKey = 'settings.language_code';

  final SharedPreferencesAsync _preferences;

  Future<void> loadSavedLocale() async {
    final codeLanguage = await _preferences.getString(_languageCodeKey);
    if (codeLanguage == null || codeLanguage.isEmpty) return;

    value = Locale(codeLanguage);
  }

  Future<void> codeLanguageSet(String codeLanguage) async {
    value = Locale(codeLanguage);
    await _preferences.setString(_languageCodeKey, codeLanguage);
  }
}

final controllerLocaleApp = AppLocaleController();
