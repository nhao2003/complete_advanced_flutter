import 'package:flutter/material.dart';

enum LanguageType { ENGLISH, VIETNAMESE }

const String VIETNAMESE = "vi";
const String ENGLISH = "en";
const String ASSETS_PATH_LOCALISATIONS = "assets/translations";
const Locale VIETNAMESE_LOCAL = Locale("vi","VN");
const Locale ENGLISH_LOCAL = Locale("en","US");

extension LanguageTypeExtension on LanguageType {
  String getValue() {
    switch (this) {
      case LanguageType.ENGLISH:
        return ENGLISH;
      case LanguageType.VIETNAMESE:
        return VIETNAMESE;
    }
  }
}
