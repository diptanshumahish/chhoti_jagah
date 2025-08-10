import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'state_management/index.dart';
import 'config/app_theme.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const ProviderScope(child: MultiFirebaseApp()));
}

class MultiFirebaseApp extends ConsumerWidget {
  const MultiFirebaseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeControllerProvider);
    final currentLocale = ref.watch(languageControllerProvider);
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chhoti Jagah',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      locale: currentLocale,
      
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('hi'), // Hindi
        Locale('kn'), // Kannada
        Locale('te'), // Telugu
        Locale('ta'), // Tamil
        Locale('mr'), // Marathi
        Locale('or'), // Odia
        Locale('bn'), // Bangla
      ],      
      home: const HomeScreen(),
    );
  }
}
