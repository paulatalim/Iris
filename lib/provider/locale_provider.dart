import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import '../l10n/l10n.dart';

class LocaleProvider extends ChangeNotifier {
  Locale? _locale;
  bool atualizado = false;

  Locale get locale => _locale ?? const Locale('en');

  void setLocale(Locale locale) {
    if (!L10n.all.contains(locale)) return;

    _locale = locale;
    notifyListeners();
  }

  void clearLocale() {
    _locale = null;
    notifyListeners();
  }

  void saveLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('idioma', locale.languageCode);
  }

  void getLocale() async {
    if (!atualizado) {
      final prefs = await SharedPreferences.getInstance();
      _locale = Locale(prefs.getString('idioma')??'en');
      notifyListeners();
      atualizado = true;
    }
  }
}