import 'package:flutter/material.dart';

class L10n {
  static final all =[
    const Locale('en'),
    const Locale('pt')
  ];

  static String getLanguage(String code) {
    switch (code) {
      case 'pt':
        return "Português";
      case 'en':
      default:
        return "English";
    }
  }

}