import 'package:flutter/material.dart';

/// A clean, minimal typography system for consistent text styling
class AppText {
  // Font families
  static const String _primaryFont = 'Louis George Cafe';
  static const String _secondaryFont = 'LionClub';

  // Core text styles - only the essentials
  static TextStyle get displayLarge => const TextStyle(
    fontFamily: _primaryFont,
    fontSize: 32,
    fontWeight: FontWeight.w700,
  );

  static TextStyle get headlineLarge => const TextStyle(
    fontFamily: _primaryFont,
    fontSize: 22,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get headlineMedium => const TextStyle(
    fontFamily: _primaryFont,
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get titleLarge => const TextStyle(
    fontFamily: _primaryFont,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get titleMedium => const TextStyle(
    fontFamily: _primaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get bodyLarge => const TextStyle(
    fontFamily: _primaryFont,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get bodyMedium => const TextStyle(
    fontFamily: _primaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get caption => const TextStyle(
    fontFamily: _primaryFont,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get button => const TextStyle(
    fontFamily: _primaryFont,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  // Essential helper methods
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }

  static TextStyle withSize(TextStyle style, double size) {
    return style.copyWith(fontSize: size);
  }
}
