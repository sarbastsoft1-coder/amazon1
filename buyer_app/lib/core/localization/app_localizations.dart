import 'package:flutter/material.dart';
import 'translations.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  String translate(String key) {
    final languageCode = locale.languageCode;
    // For Central Kurdish, if the locale is ckb, languageCode is ckb.
    // If it's another Kurdish, ku.
    final dict = Translations.dictionary[languageCode];
    if (dict != null) {
      if (dict.containsKey(key)) {
        return dict[key]!;
      }
    }
    // Fallback to English
    final fallbackDict = Translations.dictionary['en'];
    if (fallbackDict != null && fallbackDict.containsKey(key)) {
      return fallbackDict[key]!;
    }
    // If key not found anywhere, return the key itself
    return key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar', 'ckb', 'ku'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
