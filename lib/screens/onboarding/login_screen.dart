import 'package:chhoti_jagah/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../widgets/ui_components/common_button.dart';
import '../../widgets/ui_components/floating_language_selector.dart';
import '../../services/user_auth_service.dart';
import '../../services/user_service.dart';
import '../main/home_screen.dart';
import '../../utils/error_handler.dart';
import 'signup_screen.dart';
import 'profile_completion_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;
  bool isSignUp = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/pngs/alley.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const Spacer(),
                      
                      // Logo
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Image.asset(
                          'assets/logomain.png',
                          width: 60,
                          height: 60,
                          fit: BoxFit.contain,
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Title and subtitle
                      Column(
                        children: [
                          Text(
                            l10n.loginTitle,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.loginSubtitle,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Google sign in button
                      CommonButton(
                        text: l10n.googleSignInButton,
                        onPressed: !isLoading ? _signInWithGoogle : null,
                        trailingIcon: PhosphorIcons.googleLogo(PhosphorIconsStyle.regular),
                        width: double.infinity,
                        backgroundColor: Colors.white,
                        textColor: Colors.black87,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Divider
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 1,
                              color: Colors.white.withValues(alpha: 0.3),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              l10n.orDivider,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 1,
                              color: Colors.white.withValues(alpha: 0.3),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Email sign in form
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _emailController,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: l10n.emailHint,
                                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
                                filled: true,
                                fillColor: Colors.white.withValues(alpha: 0.1),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon: Icon(PhosphorIcons.envelope(PhosphorIconsStyle.regular), color: Colors.white.withValues(alpha: 0.7)),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!value.contains('@')) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            
                            const SizedBox(height: 16),
                            
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: l10n.passwordHint,
                                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
                                filled: true,
                                fillColor: Colors.white.withValues(alpha: 0.1),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon: Icon(PhosphorIcons.lock(PhosphorIconsStyle.regular), color: Colors.white.withValues(alpha: 0.7)),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Sign in button
                            CommonButton(
                              text: l10n.signInButton,
                              onPressed: !isLoading ? _signInWithEmail : null,
                              trailingIcon: PhosphorIcons.signIn(PhosphorIconsStyle.regular),
                              width: double.infinity,
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Sign up link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  l10n.dontHaveAccount,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.7),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => const SignupScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    l10n.signUpButton,
                                    style: TextStyle(
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Floating language selector
          const FloatingLanguageSelector(
            backgroundColor: Colors.white,
            iconColor: Colors.black87,
            margin: EdgeInsets.only(top: 60, right: 16),
          ),
        ],
      ),
    );
  }

  Future<void> _signInWithGoogle() async {
    final result = await AsyncOperationHandler.execute(
      context: context,
      operation: () async {
        try {
          final userCredential = await UserAuthService.signInWithGoogle();
          if (userCredential == null) {
            throw Exception('Google sign in was cancelled');
          }
          return userCredential;
        } catch (e) {
          // Show specific error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Google sign in failed: ${e.toString()}'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
          // Re-throw to prevent navigation
          rethrow;
        }
      },
      onLoading: (loading) => setState(() => isLoading = loading),
      errorMessage: 'Google sign in failed',
      showErrorSnackbar: false, // We're handling errors manually
    );
    
    // Only navigate if sign-in was successful
    if (result != null && context.mounted) {
      // Check if user profile is complete
      final userExists = await UserService.userExists(result.user!.uid);
      if (!userExists) {
        // User doesn't exist in Firestore, redirect to profile completion
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ProfileCompletionScreen(
              fullName: result.user!.displayName,
              emailId: result.user!.email ?? '',
              isGoogleSignIn: true,
            ),
          ),
        );
      } else {
        // User exists, redirect to home
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    }
  }

  Future<void> _signInWithEmail() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final result = await AsyncOperationHandler.execute(
      context: context,
      operation: () async {
        try {
          final userCredential = await UserAuthService.signInWithEmailAndPassword(
            _emailController.text.trim(),
            _passwordController.text,
          );
          if (userCredential == null) {
            throw Exception('Email sign in failed');
          }
          return userCredential;
        } catch (e) {
          // Show specific error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Email sign in failed: ${e.toString()}'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
          // Re-throw to prevent navigation
          rethrow;
        }
      },
      onLoading: (loading) => setState(() => isLoading = loading),
      errorMessage: 'Email sign in failed',
      showErrorSnackbar: false, // We're handling errors manually
    );
    
    // Only navigate if sign-in was successful
    if (result != null && context.mounted) {
      // Check if user profile is complete
      final userExists = await UserService.userExists(result.user!.uid);
      if (!userExists) {
        // User doesn't exist in Firestore, redirect to profile completion
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ProfileCompletionScreen(
              fullName: null, // Will be asked in profile completion
              emailId: result.user!.email ?? '',
              isGoogleSignIn: false,
            ),
          ),
        );
      } else {
        // User exists, redirect to home
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    }
  }
}
