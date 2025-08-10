import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final languageProvider = StateProvider<Locale>((ref) => const Locale('en'));

class LanguageController extends StateNotifier<Locale> {
  LanguageController() : super(const Locale('en'));

  void setLanguage(Locale locale) {
    state = locale;
  }

  void setLanguageByCode(String languageCode) {
    state = Locale(languageCode);
  }

  String getCurrentLanguageCode() {
    return state.languageCode;
  }

  bool isCurrentLanguage(String languageCode) {
    return state.languageCode == languageCode;
  }
}

final languageControllerProvider = StateNotifierProvider<LanguageController, Locale>((ref) {
  return LanguageController();
});

class LanguageInfo {
  final String code;
  final String name;
  final String nativeName;
  final String flag;

  const LanguageInfo({
    required this.code,
    required this.name,
    required this.nativeName,
    this.flag = '🌐',
  });
}

final availableLanguagesProvider = Provider<List<LanguageInfo>>((ref) {
  return [
    const LanguageInfo(
      code: 'en',
      name: 'English',
      nativeName: 'English',
      flag: '🇺🇸',
    ),
    const LanguageInfo(
      code: 'hi',
      name: 'Hindi',
      nativeName: 'हिंदी',
      flag: '🇮🇳',
    ),
    const LanguageInfo(
      code: 'kn',
      name: 'Kannada',
      nativeName: 'ಕನ್ನಡ',
      flag: '🇮🇳',
    ),
    const LanguageInfo(
      code: 'te',
      name: 'Telugu',
      nativeName: 'తెలుగు',
      flag: '🇮🇳',
    ),
    const LanguageInfo(
      code: 'ta',
      name: 'Tamil',
      nativeName: 'தமிழ்',
      flag: '🇮🇳',
    ),
    const LanguageInfo(
      code: 'mr',
      name: 'Marathi',
      nativeName: 'मराठी',
      flag: '🇮🇳',
    ),
    const LanguageInfo(
      code: 'or',
      name: 'Odia',
      nativeName: 'ଓଡ଼ିଆ',
      flag: '🇮🇳',
    ),
    const LanguageInfo(
      code: 'bn',
      name: 'Bangla',
      nativeName: 'বাংলা',
      flag: '🇮🇳',
    ),
  ];
});
