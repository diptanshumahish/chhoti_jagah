class AppConstants {
  // App dimensions
  static const double defaultPadding = 16.0;
  static const double defaultMargin = 8.0;
  static const double defaultBorderRadius = 12.0;
  static const double defaultButtonHeight = 56.0;
  
  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Asset paths
  static const String assetsPath = 'assets/';
  static const String imagesPath = '${assetsPath}pngs/';
  static const String fontsPath = '${assetsPath}fonts/';
  
  // Shared preferences keys
  static const String languageKey = 'selected_language';
  static const String hasSelectedLanguageKey = 'has_selected_language';
  static const String locationPermissionKey = 'location_permission_granted';
  static const String userLoggedInKey = 'user_logged_in';
  static const String userEmailKey = 'user_email';
  static const String userNameKey = 'user_name';
}

enum LocationPermissionStatus {
  granted,
  denied,
  deniedForever,
  servicesDisabled,
  unableToDetermine,
}

class LocationPermissionResult {
  final LocationPermissionStatus permissionStatus;
  final bool granted;

  const LocationPermissionResult({
    required this.permissionStatus,
    required this.granted,
  });
}
