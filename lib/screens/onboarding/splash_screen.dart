import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/language_storage_service.dart';
import '../../services/location_permission_service.dart';
import '../../services/user_auth_service.dart';
import '../../services/user_service.dart';
import '../../services/firebase_startup.dart';
import '../../state_management/providers/language_provider.dart';
import '../../utils/constants.dart';
import 'language_selection_screen.dart';
import 'location_permission_screen.dart';
import 'login_screen.dart';
import 'profile_completion_screen.dart';
import '../main/home_screen.dart';
import 'location_permission_denied_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  
  @override
  void initState() {
    super.initState();
    _checkLanguageAndNavigate();
  }

  Future<void> _checkLanguageAndNavigate() async {
    try {
      // Initialize Firebase first before calling any Firebase services
      await firebaseStartupService.initializeAllProjects();
      
      // Check if user has selected language
      final hasSelectedLanguage =
          await LanguageStorageService.hasSelectedLanguage();

      if (!hasSelectedLanguage) {
        // User hasn't selected language, go to language selection
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const LanguageSelectionScreen(),
            ),
          );
        }
        return;
      }

      // Set the saved language
      final savedLanguage = await LanguageStorageService.getLanguage();
      if (savedLanguage != null) {
        ref
            .read(languageControllerProvider.notifier)
            .setLanguageByCode(savedLanguage);
      }

      // Check if user has granted location permission
      final permissionStatus = await LocationPermissionService.getLocationPermissionStatus();
      
      if (permissionStatus == LocationPermissionStatus.denied || 
          permissionStatus == LocationPermissionStatus.deniedForever ||
          permissionStatus == LocationPermissionStatus.servicesDisabled) {
        // User hasn't granted location permission or services are disabled
        if (mounted) {
          if (permissionStatus == LocationPermissionStatus.deniedForever) {
            // Permission denied forever, go directly to denied screen
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const LocationPermissionDeniedScreen(),
              ),
            );
          } else if (permissionStatus == LocationPermissionStatus.denied) {
            // Check if user has already seen the denied screen
            final hasSeenDenied = await LocationPermissionService.hasSeenDeniedScreen();
            if (hasSeenDenied) {
              // User has seen denied screen before, go directly to denied screen
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const LocationPermissionDeniedScreen(),
                ),
              );
            } else {
              // First time denying, go to permission screen
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const LocationPermissionScreen(),
                ),
              );
            }
          } else {
            // Services disabled, go to permission screen
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const LocationPermissionScreen(),
              ),
            );
          }
        }
        return;
      }

      // Check if user is logged in
      final isLoggedIn = await UserAuthService.isUserLoggedIn();
      final isSignedIn = await UserAuthService.isUserSignedIn();
      
      if (!isLoggedIn && !isSignedIn) {
        // User isn't logged in, go to login screen
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        }
        return;
      }

      // User is signed in, check if profile is complete
      if (isSignedIn) {
        final currentUser = await UserAuthService.getCurrentUser();
        if (currentUser != null) {
          final userExists = await UserService.userExists(currentUser.uid);
          if (!userExists) {
            // User doesn't exist in Firestore, go to profile completion
            if (mounted) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => ProfileCompletionScreen(
                    fullName: currentUser.displayName,
                    emailId: currentUser.email ?? '',
                    isGoogleSignIn: currentUser.providerData.isNotEmpty && 
                                   currentUser.providerData.first.providerId == 'google.com',
                  ),
                ),
              );
            }
            return;
          }
        }
      }

      // All checks passed, go to home screen
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      print('Error in splash screen navigation: $e');
      // On error, go to language selection as fallback
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LanguageSelectionScreen(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/pngs/onb.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.3),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Image.asset(
                    'assets/logomain.png',
                    width: 80,
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                ),
                
                const SizedBox(height: 32),
                
                Text(
                  'Chhoti Jagah',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
