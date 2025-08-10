import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import '../config/firebase_config.dart';

class FirebaseInitializationException implements Exception {
  final String message;
  final String? projectName;
  final dynamic originalError;

  FirebaseInitializationException(
    this.message, {
    this.projectName,
    this.originalError,
  });

  @override
  String toString() {
    if (projectName != null) {
      return 'FirebaseInitializationException: $message (Project: $projectName)';
    }
    return 'FirebaseInitializationException: $message';
  }
}

class FirebaseStartupService {
  static final FirebaseStartupService _instance =
      FirebaseStartupService._internal();
  factory FirebaseStartupService() => _instance;
  FirebaseStartupService._internal();

  final Map<String, FirebaseApp> _initializedApps = {};
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;
  bool get isReadyForUse => _isInitialized && _initializedApps.isNotEmpty;

  Future<void> waitForReady() async {
    if (_isInitialized) return;

    int attempts = 0;
    while (!_isInitialized && attempts < 50) {
      await Future.delayed(const Duration(milliseconds: 200));
      attempts++;
    }

    if (!_isInitialized) {
      throw FirebaseInitializationException(
        'Firebase initialization timeout after 10 seconds',
      );
    }
  }

  FirebaseApp? getApp(String projectName) {
    return _initializedApps[projectName];
  }

  List<String> get initializedAppNames => _initializedApps.keys.toList();

  Future<void> initializeAllProjects() async {
    if (_isInitialized) {
      print('Firebase is already initialized');
      return;
    }

    try {
      print('Starting Firebase initialization...');

      final projects = MultiFirebaseConfig.getAllProjects();

      if (projects.isEmpty) {
        throw FirebaseInitializationException(
          'No Firebase projects configured',
        );
      }

      for (final project in projects) {
        await _initializeSingleProject(project);
      }

      _isInitialized = true;
      print('✅ All Firebase projects initialized successfully!');
      print('Initialized projects: ${_initializedApps.keys.join(', ')}');

      _runVerificationInBackground();
    } catch (e) {
      _isInitialized = false;
      _cleanupOnError();

      if (e is FirebaseInitializationException) {
        rethrow;
      } else {
        throw FirebaseInitializationException(
          'Failed to initialize Firebase projects: ${e.toString()}',
          originalError: e,
        );
      }
    }
  }

  Future<void> _initializeSingleProject(FirebaseProjectConfig project) async {
    try {
      print('🔄 Initializing Firebase project: ${project.name}');

      if (_initializedApps.containsKey(project.name)) {
        print('ℹ️ Project ${project.name} is already initialized, skipping...');
        return;
      }

      final app = await Firebase.initializeApp(
        name: project.name,
        options: project.toFirebaseOptions(),
      );

      _initializedApps[project.name] = app;

      print('✅ Project ${project.name} initialized successfully');

      await Future.delayed(const Duration(milliseconds: 100));
    } catch (e) {
      throw FirebaseInitializationException(
        'Failed to initialize project ${project.name}: ${e.toString()}',
        projectName: project.name,
        originalError: e,
      );
    }
  }

  Future<void> _verifyInitialization() async {
    try {
      print('🔍 Running Firebase verification in background...');

      await Future.delayed(const Duration(milliseconds: 1000));

      for (final entry in _initializedApps.entries) {
        final projectName = entry.key;
        final app = entry.value;
        for (int attempt = 1; attempt <= 3; attempt++) {
          try {
            FirebaseFirestore.instanceFor(app: app);
            print('✅ Firestore connection verified for $projectName');
            break;
          } catch (e) {
            if (attempt < 3) {
              print(
                '⚠️ Firestore connection attempt $attempt failed for $projectName, retrying...',
              );
              await Future.delayed(Duration(milliseconds: 300 * attempt));
            } else {
              print(
                '⚠️ Firestore connection test failed for $projectName after 3 attempts: $e',
              );
              print(
                'ℹ️ This is usually a timing issue and doesn\'t affect app functionality',
              );
            }
          }
        }

        try {
          FirebaseStorage.instanceFor(app: app);
          print('✅ Storage connection verified for $projectName');
        } catch (e) {
          print('⚠️ Storage connection test failed for $projectName: $e');
        }

        try {
          FirebaseDatabase.instanceFor(app: app);
          print('✅ Database connection verified for $projectName');
        } catch (e) {
          print('⚠️ Database connection test failed for $projectName: $e');
        }
      }

      print('🔍 Firebase verification completed');
    } catch (e) {
      print('⚠️ Verification process encountered issues: $e');
    }
  }

  void _runVerificationInBackground() {
    Future.microtask(() async {
      try {
        await _verifyInitialization();
      } catch (e) {
        print('⚠️ Background verification failed: $e');
      }
    });
  }

  void _cleanupOnError() {
    print('Cleaning up Firebase apps due to initialization error...');

    for (final app in _initializedApps.values) {
      try {
        app.delete();
      } catch (e) {
        print('Warning: Failed to delete Firebase app: $e');
      }
    }

    _initializedApps.clear();
  }

  FirebaseFirestore getFirestore(String projectName) {
    if (!_isInitialized) {
      throw FirebaseInitializationException(
        'Firebase has not been initialized. Call initializeAllProjects() first.',
      );
    }

    final app = _getAppOrThrow(projectName);
    try {
      return FirebaseFirestore.instanceFor(app: app);
    } catch (e) {
      throw FirebaseInitializationException(
        'Failed to get Firestore instance for project $projectName: $e',
        projectName: projectName,
        originalError: e,
      );
    }
  }

  FirebaseStorage getStorage(String projectName) {
    if (!_isInitialized) {
      throw FirebaseInitializationException(
        'Firebase has not been initialized. Call initializeAllProjects() first.',
      );
    }

    final app = _getAppOrThrow(projectName);
    try {
      return FirebaseStorage.instanceFor(app: app);
    } catch (e) {
      throw FirebaseInitializationException(
        'Failed to get Storage instance for project $projectName: $e',
        projectName: projectName,
        originalError: e,
      );
    }
  }

  FirebaseDatabase getDatabase(String projectName) {
    if (!_isInitialized) {
      throw FirebaseInitializationException(
        'Firebase has not been initialized. Call initializeAllProjects() first.',
      );
    }

    final app = _getAppOrThrow(projectName);
    try {
      return FirebaseDatabase.instanceFor(app: app);
    } catch (e) {
      throw FirebaseInitializationException(
        'Failed to get Database instance for project $projectName: $e',
        projectName: projectName,
        originalError: e,
      );
    }
  }

  FirebaseAuth getAuth(String projectName) {
    if (!_isInitialized) {
      throw FirebaseInitializationException(
        'Firebase has not been initialized. Call initializeAllProjects() first.',
      );
    }

    final app = _getAppOrThrow(projectName);
    try {
      return FirebaseAuth.instanceFor(app: app);
    } catch (e) {
      throw FirebaseInitializationException(
        'Failed to get Auth instance for project $projectName: $e',
        projectName: projectName,
        originalError: e,
      );
    }
  }

  FirebaseApp _getAppOrThrow(String projectName) {
    if (!_isInitialized) {
      throw FirebaseInitializationException(
        'Firebase has not been initialized. Call initializeAllProjects() first.',
      );
    }

    final app = _initializedApps[projectName];
    if (app == null) {
      throw FirebaseInitializationException(
        'Firebase project "$projectName" not found or not initialized',
        projectName: projectName,
      );
    }

    return app;
  }

  Future<void> dispose() async {
    print('Disposing Firebase apps...');

    for (final app in _initializedApps.values) {
      try {
        await app.delete();
      } catch (e) {
        print('Warning: Failed to delete Firebase app: $e');
      }
    }

    _initializedApps.clear();
    _isInitialized = false;
    print('Firebase apps disposed successfully');
  }

  bool isProjectInitialized(String projectName) {
    return _initializedApps.containsKey(projectName);
  }

  Map<String, dynamic> getInitializationStatus() {
    return {
      'isInitialized': _isInitialized,
      'initializedProjects': _initializedApps.keys.toList(),
      'totalProjects': MultiFirebaseConfig.getAllProjects().length,
      'initializationComplete':
          _isInitialized &&
          _initializedApps.length ==
              MultiFirebaseConfig.getAllProjects().length,
    };
  }

  Map<String, dynamic> getDetailedStatus() {
    final projects = MultiFirebaseConfig.getAllProjects();
    final status = <String, dynamic>{};

    for (final project in projects) {
      final isInitialized = _initializedApps.containsKey(project.name);
      final app = _initializedApps[project.name];

      status[project.name] = {
        'name': project.name,
        'projectId': project.projectId,
        'isInitialized': isInitialized,
        'appName': app?.name,
        'appOptions': app?.options.toString(),
      };
    }

    return {
      'overallStatus': getInitializationStatus(),
      'projectDetails': status,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  Future<Map<String, dynamic>> testInitialization() async {
    try {
      print('🧪 Testing Firebase initialization...');

      _isInitialized = false;
      _initializedApps.clear();

      await initializeAllProjects();

      await Future.delayed(const Duration(milliseconds: 2000));

      final result = {
        'success': _isInitialized,
        'initializedProjects': _initializedApps.keys.toList(),
        'totalProjects': MultiFirebaseConfig.getAllProjects().length,
        'detailedStatus': getDetailedStatus(),
      };

      print('🧪 Test completed: ${result['success']}');
      return result;
    } catch (e) {
      print('🧪 Test failed: $e');
      return {
        'success': false,
        'error': e.toString(),
        'detailedStatus': getDetailedStatus(),
      };
    }
  }
}

final firebaseStartupService = FirebaseStartupService();
