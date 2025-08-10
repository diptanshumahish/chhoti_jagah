import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_startup.dart';
import 'firebase_status_provider.dart';

// Global Firebase status that persists across provider containers
class GlobalFirebaseStatus {
  static bool _isInitialized = false;
  static List<String> _initializedProjects = [];
  static int _totalProjects = 0;
  static bool _initializationComplete = false;
  static String? _lastError;
  static bool _isLoading = false;

  static void updateStatus({
    bool? isInitialized,
    List<String>? initializedProjects,
    int? totalProjects,
    bool? initializationComplete,
    String? lastError,
    bool? isLoading,
  }) {
    if (isInitialized != null) _isInitialized = isInitialized;
    if (initializedProjects != null) _initializedProjects = initializedProjects;
    if (totalProjects != null) _totalProjects = totalProjects;
    if (initializationComplete != null) _initializationComplete = initializationComplete;
    if (lastError != null) _lastError = lastError;
    if (isLoading != null) _isLoading = isLoading;
  }

  static Map<String, dynamic> getStatus() {
    return {
      'isInitialized': _isInitialized,
      'initializedProjects': _initializedProjects,
      'totalProjects': _totalProjects,
      'initializationComplete': _initializationComplete,
      'lastError': _lastError,
      'isLoading': _isLoading,
    };
  }

  static void reset() {
    _isInitialized = false;
    _initializedProjects.clear();
    _totalProjects = 0;
    _initializationComplete = false;
    _lastError = null;
    _isLoading = false;
  }
}

// App initialization service
class AppInitializationService {
  static final AppInitializationService _instance = AppInitializationService._internal();
  factory AppInitializationService() => _instance;
  AppInitializationService._internal();

  Future<void> initializeApp(ProviderContainer container) async {
    try {
      // Get the Firebase status controller
      final statusController = container.read(firebaseStatusControllerProvider.notifier);
      
      // Set loading state
      statusController.setLoading(true);
      statusController.clearError();
      
      // Update global status
      GlobalFirebaseStatus.updateStatus(isLoading: true);
      
      print('🚀 Starting Firebase initialization...');
      print('📱 Platform: ${_getPlatformInfo()}');
      
      // Initialize Firebase projects
      await firebaseStartupService.initializeAllProjects();
      
      // Add a small delay to ensure everything is settled
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Update status in container
      statusController.updateStatus();
      
      // Update global status
      final status = firebaseStartupService.getInitializationStatus();
      GlobalFirebaseStatus.updateStatus(
        isInitialized: status['isInitialized'],
        initializedProjects: status['initializedProjects'],
        totalProjects: status['totalProjects'],
        initializationComplete: status['initializationComplete'],
        isLoading: false,
      );
      
      print('🌍 Global status updated: ${GlobalFirebaseStatus.getStatus()}');
      print('🚀 App initialization completed successfully!');
      
    } catch (e, stackTrace) {
      print('❌ App initialization failed: $e');
      print('📚 Stack trace: $stackTrace');
      
      // Update error state in container
      final statusController = container.read(firebaseStatusControllerProvider.notifier);
      statusController.setError(e.toString());
      
      // Update global error status
      GlobalFirebaseStatus.updateStatus(
        lastError: e.toString(),
        isLoading: false,
      );
      
      if (e is FirebaseInitializationException) {
        print('🔍 Firebase Error Details: ${e.toString()}');
        if (e.originalError != null) {
          print('🔍 Original Error: ${e.originalError}');
        }
      }
      
      print('⚠️ Continuing app startup without Firebase...');
    }
  }

  Future<void> refreshFirebaseStatus(ProviderContainer container) async {
    try {
      final statusController = container.read(firebaseStatusControllerProvider.notifier);
      statusController.updateStatus();
    } catch (e) {
      print('❌ Failed to refresh Firebase status: $e');
    }
  }

  Future<void> retryFirebaseInitialization(ProviderContainer container) async {
    try {
      final statusController = container.read(firebaseStatusControllerProvider.notifier);
      statusController.setLoading(true);
      statusController.clearError();
      
      // Retry initialization
      await firebaseStartupService.initializeAllProjects();
      
      // Update status
      statusController.updateStatus();
      
      print('🔄 Firebase initialization retry completed successfully!');
      
    } catch (e) {
      print('❌ Firebase initialization retry failed: $e');
      
      final statusController = container.read(firebaseStatusControllerProvider.notifier);
      statusController.setError(e.toString());
    }
  }

  // Check if the app is ready to use Firebase services
  bool isAppReady(ProviderContainer container) {
    try {
      final statusController = container.read(firebaseStatusControllerProvider.notifier);
      return statusController.isReadyForUse;
    } catch (e) {
      print('⚠️ Failed to check app readiness: $e');
      return false;
    }
  }

  // Wait for the app to be ready
  Future<void> waitForAppReady(ProviderContainer container) async {
    try {
      final statusController = container.read(firebaseStatusControllerProvider.notifier);
      await statusController.waitForReady();
    } catch (e) {
      print('⚠️ Failed to wait for app readiness: $e');
      throw Exception('App not ready: $e');
    }
  }

  String _getPlatformInfo() {
    try {
      // This is a simple way to get platform info without importing dart:io
      return 'Flutter ${_getFlutterVersion()}';
    } catch (e) {
      return 'Unknown platform';
    }
  }

  String _getFlutterVersion() {
    try {
      // This is a placeholder - in a real app you might get this from package info
      return '3.x.x';
    } catch (e) {
      return 'Unknown version';
    }
  }
}

final appInitializationService = AppInitializationService();
