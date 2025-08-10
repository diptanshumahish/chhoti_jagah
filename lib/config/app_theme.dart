import 'package:flutter/material.dart';

class AppTheme {
  // Primary color from your specification
  static const Color primaryColor = Color(0xFFFF355E);
  
  // Color palette based on primary color
  static const Color primaryLight = Color(0xFFFF6B8A);
  static const Color primaryDark = Color(0xFFD62B4A);
  static const Color primaryVariant = Color(0xFFFF1A47);
  
  // Secondary colors
  static const Color secondaryColor = Color(0xFF2D3748);
  static const Color secondaryLight = Color(0xFF4A5568);
  static const Color secondaryDark = Color(0xFF1A202C);
  
  // Neutral colors
  static const Color neutral50 = Color(0xFFF7FAFC);
  static const Color neutral100 = Color(0xFFEDF2F7);
  static const Color neutral200 = Color(0xFFE2E8F0);
  static const Color neutral300 = Color(0xFFCBD5E0);
  static const Color neutral400 = Color(0xFFA0AEC0);
  static const Color neutral500 = Color(0xFF718096);
  static const Color neutral600 = Color(0xFF4A5568);
  static const Color neutral700 = Color(0xFF2D3748);
  static const Color neutral800 = Color(0xFF1A202C);
  static const Color neutral900 = Color(0xFF171923);
  
  // Status colors
  static const Color successColor = Color(0xFF48BB78);
  static const Color warningColor = Color(0xFFED8936);
  static const Color errorColor = Color(0xFFE53E3E);
  static const Color infoColor = Color(0xFF4299E1);

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Color Scheme - Using Material 3 ColorScheme.fromSeed
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
      ).copyWith(
        primary: primaryColor,
        primaryContainer: primaryLight,
        secondary: secondaryColor,
        secondaryContainer: secondaryLight,
        surface: neutral50,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: neutral900,
        onError: Colors.white,
      ),
      
      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Louis George Cafe',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      
      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Louis George Cafe',
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: neutral900,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Louis George Cafe',
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: neutral900,
        ),
        displaySmall: TextStyle(
          fontFamily: 'Louis George Cafe',
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: neutral900,
        ),
        headlineLarge: TextStyle(
          fontFamily: 'Louis George Cafe',
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: neutral900,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Louis George Cafe',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: neutral900,
        ),
        headlineSmall: TextStyle(
          fontFamily: 'Louis George Cafe',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: neutral900,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Louis George Cafe',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: neutral900,
        ),
        titleMedium: TextStyle(
          fontFamily: 'Louis George Cafe',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: neutral900,
        ),
        titleSmall: TextStyle(
          fontFamily: 'Louis George Cafe',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: neutral900,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Louis George Cafe',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: neutral800,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Louis George Cafe',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: neutral800,
        ),
        bodySmall: TextStyle(
          fontFamily: 'Louis George Cafe',
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: neutral600,
        ),
        labelLarge: TextStyle(
          fontFamily: 'LionClub',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: neutral700,
        ),
        labelMedium: TextStyle(
          fontFamily: 'LionClub',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: neutral600,
        ),
        labelSmall: TextStyle(
          fontFamily: 'LionClub',
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: neutral500,
        ),
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Louis George Cafe',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Louis George Cafe',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: const TextStyle(
            fontFamily: 'Louis George Cafe',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: neutral100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: neutral300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: errorColor, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: errorColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        labelStyle: TextStyle(
          fontFamily: 'Louis George Cafe',
          color: neutral600,
        ),
        hintStyle: TextStyle(
          fontFamily: 'Louis George Cafe',
          color: neutral400,
        ),
      ),
      
      // Card Theme
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.white,
        shadowColor: neutral200,
      ),
      
      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: neutral100,
        selectedColor: primaryLight,
        labelStyle: const TextStyle(
          fontFamily: 'Louis George Cafe',
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      
      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: neutral200,
        thickness: 1,
        space: 1,
      ),
      
      // Icon Theme
      iconTheme: const IconThemeData(
        color: neutral700,
        size: 24,
      ),
      
      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryColor,
        unselectedItemColor: neutral500,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Color Scheme - Using Material 3 ColorScheme.fromSeed
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
      ).copyWith(
        primary: primaryColor,
        primaryContainer: primaryDark,
        secondary: secondaryLight,
        secondaryContainer: secondaryColor,
        surface: neutral800,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: neutral100,
        onError: Colors.white,
      ),
      
      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: neutral900,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Louis George Cafe',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      
      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Louis George Cafe',
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: neutral100,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Louis George Cafe',
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: neutral100,
        ),
        displaySmall: TextStyle(
          fontFamily: 'Louis George Cafe',
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: neutral100,
        ),
        headlineLarge: TextStyle(
          fontFamily: 'Louis George Cafe',
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: neutral100,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Louis George Cafe',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: neutral100,
        ),
        headlineSmall: TextStyle(
          fontFamily: 'Louis George Cafe',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: neutral100,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Louis George Cafe',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: neutral100,
        ),
        titleMedium: TextStyle(
          fontFamily: 'Louis George Cafe',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: neutral100,
        ),
        titleSmall: TextStyle(
          fontFamily: 'Louis George Cafe',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: neutral100,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Louis George Cafe',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: neutral200,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Louis George Cafe',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: neutral200,
        ),
        bodySmall: TextStyle(
          fontFamily: 'Louis George Cafe',
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: neutral400,
        ),
        labelLarge: TextStyle(
          fontFamily: 'LionClub',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: neutral300,
        ),
        labelMedium: TextStyle(
          fontFamily: 'LionClub',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: neutral400,
        ),
        labelSmall: TextStyle(
          fontFamily: 'LionClub',
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: neutral500,
        ),
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Louis George Cafe',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Louis George Cafe',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: const TextStyle(
            fontFamily: 'Louis George Cafe',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: neutral800,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: neutral600, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: errorColor, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: errorColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        labelStyle: TextStyle(
          fontFamily: 'Louis George Cafe',
          color: neutral400,
        ),
        hintStyle: TextStyle(
          fontFamily: 'Louis George Cafe',
          color: neutral500,
        ),
      ),
      
      // Card Theme
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: neutral800,
        shadowColor: Colors.black,
      ),
      
      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: neutral700,
        selectedColor: primaryDark,
        labelStyle: const TextStyle(
          fontFamily: 'Louis George Cafe',
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      
      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: neutral700,
        thickness: 1,
        space: 1,
      ),
      
      // Icon Theme
      iconTheme: const IconThemeData(
        color: neutral300,
        size: 24,
      ),
      
      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: neutral900,
        selectedItemColor: primaryColor,
        unselectedItemColor: neutral500,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }

  // Helper method to get theme based on brightness
  static ThemeData getTheme(Brightness brightness) {
    return brightness == Brightness.dark ? darkTheme : lightTheme;
  }

  // Helper method to get current theme from context
  static ThemeData of(BuildContext context) {
    return Theme.of(context);
  }

  // Helper method to check if current theme is dark
  static bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  // Helper method to get primary color with opacity
  static Color primaryWithOpacity(double opacity) {
    return primaryColor.withOpacity(opacity);
  }

  // Helper method to get text color based on background
  static Color getTextColor(Color backgroundColor) {
    return backgroundColor.computeLuminance() > 0.5 ? neutral900 : neutral100;
  }
}
