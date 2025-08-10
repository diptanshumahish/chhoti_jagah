import 'package:cloud_firestore/cloud_firestore.dart';
import '../config/firebase_config.dart';
import 'firebase_startup.dart';

class UsernameAvailabilityService {
  static const String _miscDataProjectName = miscDataProjectName;
  
  // Check if Firebase is ready for misc data operations
  static Future<void> _ensureFirebaseReady() async {
    if (!firebaseStartupService.isProjectInitialized(_miscDataProjectName)) {
      // Wait for Firebase to be ready
      await firebaseStartupService.waitForReady();
      
      // If still not ready, try to initialize
      if (!firebaseStartupService.isProjectInitialized(_miscDataProjectName)) {
        await firebaseStartupService.initializeAllProjects();
      }
    }
  }
  
  static FirebaseFirestore get _firestore {
    if (firebaseStartupService.isProjectInitialized(_miscDataProjectName)) {
      return firebaseStartupService.getFirestore(_miscDataProjectName);
    }
    // Don't fall back to default instance - throw error instead
    throw Exception('Firebase project "$_miscDataProjectName" is not initialized. Call _ensureFirebaseReady() first.');
  }

  /// Check if a username is available
  static Future<bool> isUsernameAvailable(String username) async {
    try {
      await _ensureFirebaseReady();
      
      // Query the usernames collection to check if the username exists
      final querySnapshot = await _firestore
          .collection('usernames')
          .where('username', isEqualTo: username.toLowerCase())
          .limit(1)
          .get();
      
      return querySnapshot.docs.isEmpty;
    } catch (e) {
      print('Error checking username availability: $e');
      rethrow;
    }
  }

  /// Reserve a username for a user
  static Future<bool> reserveUsername(String username, String userId) async {
    try {
      await _ensureFirebaseReady();
      
      // Check if username is still available
      final isAvailable = await isUsernameAvailable(username);
      if (!isAvailable) {
        return false;
      }
      
      // Reserve the username
      await _firestore
          .collection('usernames')
          .doc(username.toLowerCase())
          .set({
        'username': username.toLowerCase(),
        'userId': userId,
        'reservedAt': FieldValue.serverTimestamp(),
        'isActive': true,
      });
      
      return true;
    } catch (e) {
      print('Error reserving username: $e');
      rethrow;
    }
  }

  /// Release a username reservation
  static Future<void> releaseUsername(String username) async {
    try {
      await _ensureFirebaseReady();
      
      await _firestore
          .collection('usernames')
          .doc(username.toLowerCase())
          .delete();
    } catch (e) {
      print('Error releasing username: $e');
      rethrow;
    }
  }

  /// Get username suggestions based on a base name
  static Future<List<String>> getUsernameSuggestions(String baseName) async {
    try {
      await _ensureFirebaseReady();
      
      // Generate suggestions
      final suggestions = <String>[];
      final base = baseName.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
      
      if (base.isNotEmpty) {
        suggestions.add(base);
        
        // Add number suffixes
        for (int i = 1; i <= 5; i++) {
          suggestions.add('${base}${i}');
        }
        
        // Add underscore variations
        suggestions.add('${base}_user');
        suggestions.add('${base}_official');
        suggestions.add('${base}_2024');
      }
      
      // Filter out unavailable usernames
      final availableSuggestions = <String>[];
      for (final suggestion in suggestions) {
        if (await isUsernameAvailable(suggestion)) {
          availableSuggestions.add(suggestion);
          if (availableSuggestions.length >= 3) break; // Limit to 3 suggestions
        }
      }
      
      return availableSuggestions;
    } catch (e) {
      print('Error getting username suggestions: $e');
      return [];
    }
  }

  /// Validate username format
  static bool isValidUsername(String username) {
    if (username.isEmpty || username.length < 3 || username.length > 20) {
      return false;
    }
    
    // Username should only contain letters, numbers, and underscores
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!usernameRegex.hasMatch(username)) {
      return false;
    }
    
    // Username should not start with a number
    if (RegExp(r'^[0-9]').hasMatch(username)) {
      return false;
    }
    
    return true;
  }
}
