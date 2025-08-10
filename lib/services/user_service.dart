import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import '../config/firebase_config.dart';
import '../models/user_model.dart';
import 'firebase_startup.dart';
import 'username_availability_service.dart';

class UserService {
  static const String _userDataProjectName = userDataProjectName;
  
  // Check if Firebase is ready for user data operations
  static Future<void> _ensureFirebaseReady() async {
    if (!firebaseStartupService.isProjectInitialized(_userDataProjectName)) {
      // Wait for Firebase to be ready
      await firebaseStartupService.waitForReady();
      
      // If still not ready, try to initialize
      if (!firebaseStartupService.isProjectInitialized(_userDataProjectName)) {
        await firebaseStartupService.initializeAllProjects();
      }
    }
  }
  
  static FirebaseFirestore get _firestore {
    if (firebaseStartupService.isProjectInitialized(_userDataProjectName)) {
      return firebaseStartupService.getFirestore(_userDataProjectName);
    }
    // Don't fall back to default instance - throw error instead
    throw Exception('Firebase project "$_userDataProjectName" is not initialized. Call _ensureFirebaseReady() first.');
  }

  /// Create a new user in Firestore
  static Future<UserModel> createUser({
    required String userId,
    required String username,
    required String fullName,
    required String emailId,
    AgeGroup? ageGroup,
    String? placeOfLiving,
    String? userBio,
  }) async {
    try {
      await _ensureFirebaseReady();
      
      // Check if username is available
      final isUsernameAvailable = await UsernameAvailabilityService.isUsernameAvailable(username);
      if (!isUsernameAvailable) {
        throw Exception('Username is not available');
      }
      
      // Reserve the username
      final usernameReserved = await UsernameAvailabilityService.reserveUsername(username, userId);
      if (!usernameReserved) {
        throw Exception('Failed to reserve username');
      }
      
      // Get location if not provided
      String? finalPlaceOfLiving = placeOfLiving;
      if (finalPlaceOfLiving == null) {
        try {
          final position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          );
          finalPlaceOfLiving = '${position.latitude},${position.longitude}';
        } catch (e) {
          print('Could not get location: $e');
          finalPlaceOfLiving = 'Unknown';
        }
      }
      
      // Set default age group if not provided
      final finalAgeGroup = ageGroup ?? AgeGroup.lessThan13;
      
      final now = DateTime.now();
      final user = UserModel(
        id: userId,
        username: username,
        createdAt: now,
        modifiedAt: now,
        points: 0,
        ageGroup: finalAgeGroup,
        placeOfLiving: finalPlaceOfLiving,
        fullName: fullName,
        emailId: emailId,
        userBio: userBio,
        contributions: [],
        recentActivity: null,
        accountType: AccountType.normal,
        premium: false,
        verified: false,
      );
      
      // Save to Firestore
      await _firestore
          .collection('users')
          .doc(userId)
          .set(user.toFirestore());
      
      return user;
    } catch (e) {
      print('Error creating user: $e');
      rethrow;
    }
  }

  /// Get user by ID
  static Future<UserModel?> getUserById(String userId) async {
    try {
      await _ensureFirebaseReady();
      
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .get();
      
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      
      return null;
    } catch (e) {
      print('Error getting user by ID: $e');
      rethrow;
    }
  }

  /// Update user data
  static Future<void> updateUser(String userId, Map<String, dynamic> updates) async {
    try {
      await _ensureFirebaseReady();
      
      updates['modifiedAt'] = FieldValue.serverTimestamp();
      
      await _firestore
          .collection('users')
          .doc(userId)
          .update(updates);
    } catch (e) {
      print('Error updating user: $e');
      rethrow;
    }
  }

  /// Check if user exists in Firestore
  static Future<bool> userExists(String userId) async {
    try {
      await _ensureFirebaseReady();
      
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .get();
      
      return doc.exists;
    } catch (e) {
      print('Error checking if user exists: $e');
      rethrow;
    }
  }

  /// Get user by username
  static Future<UserModel?> getUserByUsername(String username) async {
    try {
      await _ensureFirebaseReady();
      
      final querySnapshot = await _firestore
          .collection('users')
          .where('username', isEqualTo: username.toLowerCase())
          .limit(1)
          .get();
      
      if (querySnapshot.docs.isNotEmpty) {
        return UserModel.fromFirestore(querySnapshot.docs.first);
      }
      
      return null;
    } catch (e) {
      print('Error getting user by username: $e');
      rethrow;
    }
  }

  /// Delete user (for cleanup purposes)
  static Future<void> deleteUser(String userId) async {
    try {
      await _ensureFirebaseReady();
      
      // Get user to release username
      final user = await getUserById(userId);
      if (user != null) {
        await UsernameAvailabilityService.releaseUsername(user.username);
      }
      
      // Delete user document
      await _firestore
          .collection('users')
          .doc(userId)
          .delete();
    } catch (e) {
      print('Error deleting user: $e');
      rethrow;
    }
  }

  /// Get location from device
  static Future<String> getCurrentLocation() async {
    try {
      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return 'Permission denied';
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        return 'Location permanently denied';
      }
      
      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      return '${position.latitude},${position.longitude}';
    } catch (e) {
      print('Error getting location: $e');
      return 'Unknown';
    }
  }

  /// Check if user profile is complete
  static Future<bool> isUserProfileComplete(String userId) async {
    try {
      final user = await getUserById(userId);
      if (user == null) return false;
      
      // Check if all required fields are filled
      return user.username.isNotEmpty &&
             user.fullName.isNotEmpty &&
             user.emailId.isNotEmpty &&
             user.ageGroup != null;
    } catch (e) {
      print('Error checking profile completeness: $e');
      return false;
    }
  }
}
