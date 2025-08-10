import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/language_constants.dart';
import '../../models/language_model.dart';

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

final availableLanguagesProvider = Provider<List<LanguageInfo>>((ref) {
  return LanguageConstants.availableLanguages;
});
