import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';
import 'firebase_startup.dart';

class UserAuthService {
  static const String _authProjectName = 'user_data';
  
  // Check if Firebase is ready for auth operations
  static Future<void> _ensureFirebaseReady() async {
    if (!firebaseStartupService.isProjectInitialized(_authProjectName)) {
      // Wait for Firebase to be ready
      await firebaseStartupService.waitForReady();
      
      // If still not ready, try to initialize
      if (!firebaseStartupService.isProjectInitialized(_authProjectName)) {
        await firebaseStartupService.initializeAllProjects();
      }
    }
  }
  
  static FirebaseAuth get _auth {
    if (firebaseStartupService.isProjectInitialized(_authProjectName)) {
      return firebaseStartupService.getAuth(_authProjectName);
    }
    // Don't fall back to default instance - throw error instead
    throw Exception('Firebase project "$_authProjectName" is not initialized. Call _ensureFirebaseReady() first.');
  }

  // Sign in with Google
  static Future<UserCredential?> signInWithGoogle() async {
    try {
      // Ensure Firebase is ready
      await _ensureFirebaseReady();
      
      // Initialize Google Sign In with the correct web client ID for your user data project
      final GoogleSignIn googleSignIn = GoogleSignIn(
        // Use the web client ID from google-services.json
        clientId: '5283873903-9ku1du5q3rkrs87e6idekssk4k21gq7i.apps.googleusercontent.com',
      );
      
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      
      if (googleUser == null) {
        // User cancelled the sign-in flow
        return null;
      }
      
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      // Create a new credential for Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      // Sign in to Firebase with the Google credential
      final userCredential = await _auth.signInWithCredential(credential);
      
      if (userCredential.user != null) {
        await _saveUserDetails(userCredential.user!);
      }
      
      return userCredential;
    } catch (e) {
      print('Error signing in with Google: $e');
      // Re-throw the error so the calling code can handle it properly
      rethrow;
    }
  }

  // Sign in with email and password
  static Future<UserCredential?> signInWithEmailAndPassword(
    String email, 
    String password
  ) async {
    try {
      // Ensure Firebase is ready
      await _ensureFirebaseReady();
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (userCredential.user != null) {
        await _saveUserDetails(userCredential.user!);
      }
      
      return userCredential;
    } catch (e) {
      print('Error signing in with email: $e');
      // Re-throw the error so the calling code can handle it properly
      rethrow;
    }
  }

  // Create account with email and password
  static Future<UserCredential?> createUserWithEmailAndPassword(
    String email, 
    String password
  ) async {
    try {
      // Ensure Firebase is ready
      await _ensureFirebaseReady();
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (userCredential.user != null) {
        await _saveUserDetails(userCredential.user!);
      }
      
      return userCredential;
    } catch (e) {
      print('Error creating account: $e');
      // Re-throw the error so the calling code can handle it properly
      rethrow;
    }
  }

  // Sign out
  static Future<void> signOut() async {
    try {
      // Ensure Firebase is ready
      await _ensureFirebaseReady();
      
      // Sign out from Google Sign In
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      
      // Sign out from Firebase
      await _auth.signOut();
      await _clearUserDetails();
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  // Check if user is signed in
  static Future<bool> isUserSignedIn() async {
    try {
      await _ensureFirebaseReady();
      return _auth.currentUser != null;
    } catch (e) {
      print('Error checking if user is signed in: $e');
      return false;
    }
  }

  // Get current user
  static Future<User?> getCurrentUser() async {
    try {
      await _ensureFirebaseReady();
      return _auth.currentUser;
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  // Save user details to local storage
  static Future<void> _saveUserDetails(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.userLoggedInKey, true);
    await prefs.setString(AppConstants.userEmailKey, user.email ?? '');
    await prefs.setString(AppConstants.userNameKey, user.displayName ?? '');
  }

  // Check if user exists in Firestore
  static Future<bool> _checkIfUserExistsInFirestore(String userId) async {
    try {
      // Import the user service here to avoid circular dependency
      // We'll check this in the calling code instead
      return false;
    } catch (e) {
      print('Error checking if user exists in Firestore: $e');
      return false;
    }
  }

  // Clear user details from local storage
  static Future<void> _clearUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.userLoggedInKey);
    await prefs.remove(AppConstants.userEmailKey);
    await prefs.remove(AppConstants.userNameKey);
  }

  // Check if user is logged in from local storage
  static Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppConstants.userLoggedInKey) ?? false;
  }

  // Get user email from local storage
  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.userEmailKey);
  }

  // Get user name from local storage
  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.userNameKey);
  }
}
