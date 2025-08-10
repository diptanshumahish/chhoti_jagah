import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/user_model.dart';
import '../../services/user_service.dart';
import '../../services/user_auth_service.dart';

class UserNotifier extends StateNotifier<UserModel?> {
  UserNotifier() : super(null);

  /// Load user data from Firestore
  Future<void> loadUser() async {
    try {
      final currentUser = await UserAuthService.getCurrentUser();
      if (currentUser != null) {
        final userData = await UserService.getUserById(currentUser.uid);
        if (userData != null) {
          state = userData;
        }
      }
    } catch (e) {
      print('Error loading user: $e');
    }
  }

  /// Create new user
  Future<UserModel> createUser({
    required String username,
    required String fullName,
    required String emailId,
    AgeGroup? ageGroup,
    String? placeOfLiving,
    String? userBio,
  }) async {
    try {
      final currentUser = await UserAuthService.getCurrentUser();
      if (currentUser == null) {
        throw Exception('No authenticated user found');
      }

      final user = await UserService.createUser(
        userId: currentUser.uid,
        username: username,
        fullName: fullName,
        emailId: emailId,
        ageGroup: ageGroup,
        placeOfLiving: placeOfLiving,
        userBio: userBio,
      );

      state = user;
      return user;
    } catch (e) {
      print('Error creating user: $e');
      rethrow;
    }
  }

  /// Update user data
  Future<void> updateUser(Map<String, dynamic> updates) async {
    try {
      if (state == null) return;

      await UserService.updateUser(state!.id, updates);
      
      // Reload user data
      await loadUser();
    } catch (e) {
      print('Error updating user: $e');
      rethrow;
    }
  }

  /// Check if user profile is complete
  Future<bool> isProfileComplete() async {
    try {
      final currentUser = await UserAuthService.getCurrentUser();
      if (currentUser == null) return false;

      return await UserService.isUserProfileComplete(currentUser.uid);
    } catch (e) {
      print('Error checking profile completeness: $e');
      return false;
    }
  }

  /// Clear user data (on logout)
  void clearUser() {
    state = null;
  }

  /// Get current user
  UserModel? get currentUser => state;

  /// Check if user is loaded
  bool get isLoaded => state != null;

  /// Check if user has premium
  bool get isPremium => state?.premium ?? false;

  /// Check if user is verified
  bool get isVerified => state?.verified ?? false;

  /// Get user points
  int get points => state?.points ?? 0;

  /// Get username
  String get username => state?.username ?? '';

  /// Get full name
  String get fullName => state?.fullName ?? '';

  /// Get email
  String get email => state?.emailId ?? '';
}

final userProvider = StateNotifierProvider<UserNotifier, UserModel?>((ref) {
  return UserNotifier();
});

final userNotifierProvider = Provider<UserNotifier>((ref) {
  return ref.read(userProvider.notifier);
});

final isProfileCompleteProvider = FutureProvider<bool>((ref) async {
  final userNotifier = ref.read(userNotifierProvider);
  return await userNotifier.isProfileComplete();
});
