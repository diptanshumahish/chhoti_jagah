import 'package:chhoti_jagah/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'state_management/index.dart';
import 'config/app_theme.dart';
import 'screens/index.dart';

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
        Locale('en'), 
        Locale('hi'), 
        Locale('kn'), 
        Locale('te'), 
        Locale('ta'), 
        Locale('mr'), 
        Locale('or'), 
        Locale('bn'), 
      ],      
      home: const SplashScreen(),
    );
  }
}
