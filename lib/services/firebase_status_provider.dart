import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_startup.dart';
import 'app_initialization_service.dart';

// Firebase status provider that uses global status
final firebaseStatusProvider = StateProvider<Map<String, dynamic>>((ref) {
  final globalStatus = GlobalFirebaseStatus.getStatus();
  print('🔍 Firebase status provider initialized with: $globalStatus');
  return globalStatus;
});

class FirebaseStatusController extends StateNotifier<Map<String, dynamic>> {
  FirebaseStatusController() : super(GlobalFirebaseStatus.getStatus()) {
    print('🔍 Firebase status controller initialized with: ${GlobalFirebaseStatus.getStatus()}');
  }

  void updateStatus() {
    try {
      final status = firebaseStartupService.getInitializationStatus();
      state = {
        ...state,
        ...status,
        'lastError': null,
      };
      GlobalFirebaseStatus.updateStatus(
        isInitialized: status['isInitialized'],
        initializedProjects: status['initializedProjects'],
        totalProjects: status['totalProjects'],
        initializationComplete: status['initializationComplete'],
      );
    } catch (e) {
      // If Firebase service is not available, use global status
      final globalStatus = GlobalFirebaseStatus.getStatus();
      state = {
        ...state,
        ...globalStatus,
        'lastError': null,
      };
    }
  }

  void setLoading(bool loading) {
    state = {
      ...state,
      'isLoading': loading,
    };
    GlobalFirebaseStatus.updateStatus(isLoading: loading);
  }

  void setError(String error) {
    state = {
      ...state,
      'lastError': error,
      'isLoading': false,
    };
    GlobalFirebaseStatus.updateStatus(lastError: error, isLoading: false);
  }

  void clearError() {
    state = {
      ...state,
      'lastError': null,
    };
    GlobalFirebaseStatus.updateStatus(lastError: null);
  }

  // Refresh status from global state
  void refreshFromGlobal() {
    final globalStatus = GlobalFirebaseStatus.getStatus();
    print('🔄 Refreshing from global status: $globalStatus');
    state = {
      ...state,
      ...globalStatus,
    };
    print('🔄 State updated to: $state');
  }

  bool get isInitialized => state['isInitialized'] ?? false;
  List<String> get initializedProjects => List<String>.from(state['initializedProjects'] ?? []);
  int get totalProjects => state['totalProjects'] ?? 0;
  bool get initializationComplete => state['initializationComplete'] ?? false;
  String? get lastError => state['lastError'];
  bool get isLoading => state['isLoading'] ?? false;
  
  // Check if Firebase is ready for use
  bool get isReadyForUse => isInitialized && initializedProjects.isNotEmpty;
  
  // Wait for Firebase to be ready
  Future<void> waitForReady() async {
    if (isReadyForUse) return;
    
    // Wait up to 10 seconds for initialization
    int attempts = 0;
    while (!isReadyForUse && attempts < 50) {
      await Future.delayed(const Duration(milliseconds: 200));
      attempts++;
    }
    
    if (!isReadyForUse) {
      throw Exception('Firebase initialization timeout after 10 seconds');
    }
  }
  
  // Get detailed status for debugging
  Map<String, dynamic> getDetailedStatus() {
    try {
      // Import the firebase startup service to get detailed status
      // This is a bit of a circular dependency, but it's only for debugging
      return {
        'status': state,
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return {
        'error': 'Failed to get detailed status: $e',
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }
}

final firebaseStatusControllerProvider = StateNotifierProvider<FirebaseStatusController, Map<String, dynamic>>((ref) {
  return FirebaseStatusController();
});

// Firebase projects provider
final firebaseProjectsProvider = Provider<List<String>>((ref) {
  final status = ref.watch(firebaseStatusProvider);
  final projects = List<String>.from(status['initializedProjects'] ?? []);
  
  // If no projects in provider, try to get from global status
  if (projects.isEmpty) {
    final globalStatus = GlobalFirebaseStatus.getStatus();
    return List<String>.from(globalStatus['initializedProjects'] ?? []);
  }
  
  return projects;
});

// Firebase initialization status provider
final firebaseInitializationStatusProvider = Provider<String>((ref) {
  final status = ref.watch(firebaseStatusProvider);
  final isInitialized = status['isInitialized'] ?? false;
  final totalProjects = status['totalProjects'] ?? 0;
  final initializedProjects = status['initializedProjects'] ?? [];
  
  // If no status in provider, try to get from global status
  if (!isInitialized && initializedProjects.isEmpty) {
    final globalStatus = GlobalFirebaseStatus.getStatus();
    final globalIsInitialized = globalStatus['isInitialized'] ?? false;
    final globalTotalProjects = globalStatus['totalProjects'] ?? 0;
    final globalInitializedProjects = globalStatus['initializedProjects'] ?? [];
    
    if (!globalIsInitialized) {
      return 'Not Initialized';
    }
    
    if (globalInitializedProjects.length == globalTotalProjects) {
      return 'Fully Initialized';
    }
    
    return 'Partially Initialized (${globalInitializedProjects.length}/$globalTotalProjects)';
  }
  
  if (!isInitialized) {
    return 'Not Initialized';
  }
  
  if (initializedProjects.length == totalProjects) {
    return 'Fully Initialized';
  }
  
  return 'Partially Initialized (${initializedProjects.length}/$totalProjects)';
});
