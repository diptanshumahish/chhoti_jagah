import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class LanguageStorageService {
  static Future<void> saveLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.languageKey, languageCode);
    await prefs.setBool(AppConstants.hasSelectedLanguageKey, true);
  }

  static Future<String?> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.languageKey);
  }

  static Future<bool> hasSelectedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppConstants.hasSelectedLanguageKey) ?? false;
  }

  static Future<void> clearLanguageSelection() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.languageKey);
    await prefs.remove(AppConstants.hasSelectedLanguageKey);
  }
}
