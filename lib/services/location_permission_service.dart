import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class LocationPermissionService {
  static Future<LocationPermissionResult> requestLocationPermission() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled
        return LocationPermissionResult(permissionStatus: LocationPermissionStatus.servicesDisabled, granted: false);
      }

      // Check current permission status
      LocationPermission permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.denied) {
        // Request permission
        permission = await Geolocator.requestPermission();
      }
      
      if (permission == LocationPermission.deniedForever) {
        // Permission denied forever, user needs to go to settings
        await _saveLocationPermissionStatus(false);
        return LocationPermissionResult(permissionStatus: LocationPermissionStatus.deniedForever, granted: false);
      }
      
      if (permission == LocationPermission.whileInUse || 
          permission == LocationPermission.always) {
        // Permission granted
        await _saveLocationPermissionStatus(true);
        return LocationPermissionResult(permissionStatus: LocationPermissionStatus.granted, granted: true);
      }
      
      // Permission denied
      await _saveLocationPermissionStatus(false);
      return LocationPermissionResult(permissionStatus: LocationPermissionStatus.denied, granted: false);
    } catch (e) {
      print('Error requesting location permission: $e');
      return LocationPermissionResult(permissionStatus: LocationPermissionStatus.unableToDetermine, granted: false);
    }
  }

  static Future<bool> checkLocationPermission() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return false;
      }

      // Check current permission status
      LocationPermission permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.whileInUse || 
          permission == LocationPermission.always) {
        return true;
      }
      
      return false;
    } catch (e) {
      print('Error checking location permission: $e');
      return false;
    }
  }

  static Future<bool> hasLocationPermission() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return false;
      }

      // Check current permission status
      LocationPermission permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.whileInUse || 
          permission == LocationPermission.always) {
        // Permission granted, update stored status
        await _saveLocationPermissionStatus(true);
        return true;
      }
      
      // Permission denied or denied forever
      await _saveLocationPermissionStatus(false);
      return false;
    } catch (e) {
      print('Error checking location permission: $e');
      return false;
    }
  }

  static Future<LocationPermissionStatus> getLocationPermissionStatus() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return LocationPermissionStatus.servicesDisabled;
      }

      // Check current permission status
      LocationPermission permission = await Geolocator.checkPermission();
      
      switch (permission) {
        case LocationPermission.denied:
          return LocationPermissionStatus.denied;
        case LocationPermission.deniedForever:
          return LocationPermissionStatus.deniedForever;
        case LocationPermission.whileInUse:
        case LocationPermission.always:
          await _saveLocationPermissionStatus(true);
          return LocationPermissionStatus.granted;
        case LocationPermission.unableToDetermine:
          return LocationPermissionStatus.unableToDetermine;
      }
    } catch (e) {
      print('Error getting location permission status: $e');
      return LocationPermissionStatus.unableToDetermine;
    }
  }

  static Future<bool> isPermissionDeniedForever() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      return permission == LocationPermission.deniedForever;
    } catch (e) {
      print('Error checking if permission denied forever: $e');
      return false;
    }
  }

  static Future<bool> hasSeenDeniedScreen() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('${AppConstants.locationPermissionKey}_denied_shown') ?? false;
  }

  static Future<void> markDeniedScreenAsShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('${AppConstants.locationPermissionKey}_denied_shown', true);
  }

  static Future<void> _saveLocationPermissionStatus(bool granted) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.locationPermissionKey, granted);
  }

  static Future<void> clearLocationPermissionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.locationPermissionKey);
    await prefs.remove('${AppConstants.locationPermissionKey}_denied_shown');
  }

  static Future<void> openAppSettings() async {
    await openAppSettings();
  }
}
