import 'package:flutter/material.dart';

class AppLocaleController extends ValueNotifier<Locale?> {
  AppLocaleController() : super(null);

  void setLanguageCode(String languageCode) {
    value = Locale(languageCode);
  }
}

final appLocaleController = AppLocaleController();
