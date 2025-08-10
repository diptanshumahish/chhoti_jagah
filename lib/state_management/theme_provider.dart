import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/app_theme.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

final fontScaleProvider = StateProvider<double>((ref) => 1.0);

final themeProvider = Provider<ThemeData>((ref) {
  final themeMode = ref.watch(themeControllerProvider);
  final fontScale = ref.watch(fontScaleProvider);

  ThemeData baseTheme;
  switch (themeMode) {
    case ThemeMode.light:
      baseTheme = AppTheme.lightTheme;
      break;
    case ThemeMode.dark:
      baseTheme = AppTheme.darkTheme;
      break;
    case ThemeMode.system:
      baseTheme = AppTheme.lightTheme;
      break;
  }

  return baseTheme.copyWith(
    textTheme: baseTheme.textTheme.apply(fontSizeFactor: fontScale),
  );
});

class ThemeController extends StateNotifier<ThemeMode> {
  ThemeController() : super(ThemeMode.system);

  void setThemeMode(ThemeMode mode) {
    state = mode;
  }

  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }

  void setSystemTheme() {
    state = ThemeMode.system;
  }
}

final themeControllerProvider =
    StateNotifierProvider<ThemeController, ThemeMode>((ref) {
      return ThemeController();
    });

class FontScaleController extends StateNotifier<double> {
  FontScaleController() : super(1.0);

  void setFontScale(double scale) {
    state = scale.clamp(0.8, 1.4);
  }

  void resetFontScale() {
    state = 1.0;
  }
}

final fontScaleControllerProvider =
    StateNotifierProvider<FontScaleController, double>((ref) {
      return FontScaleController();
    });
