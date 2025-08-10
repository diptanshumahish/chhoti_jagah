import 'package:chhoti_jagah/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../widgets/ui_components/common_button.dart';
import '../../services/user_auth_service.dart';
import '../../services/user_service.dart';
import '../main/home_screen.dart';
import '../../utils/error_handler.dart';
import 'profile_completion_screen.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool isLoading = false;
  bool isGoogleLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

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
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const Spacer(),
                  
                  
                  const SizedBox(height: 32),
                  
                  // Title and subtitle
                  Column(
                    children: [
                      Text(
                        l10n.signUpTitle,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.signUpSubtitle,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Sign up form
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
                              return 'Please enter a password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: 16),
                        
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: true,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: l10n.confirmPasswordHint,
                            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
                            filled: true,
                            fillColor: Colors.white.withValues(alpha: 0.1),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: Icon(PhosphorIcons.lockKey(PhosphorIconsStyle.regular), color: Colors.white.withValues(alpha: 0.7)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Sign up button
                  CommonButton(
                    text: l10n.signUpButton,
                    onPressed: !isLoading ? _createAccount : null,
                    trailingIcon: PhosphorIcons.userPlus(PhosphorIconsStyle.regular),
                    width: double.infinity,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Divider
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Colors.white.withValues(alpha: 0.3),
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'OR',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Colors.white.withValues(alpha: 0.3),
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Google sign up button
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: !isGoogleLoading ? _signUpWithGoogle : null,
                        borderRadius: BorderRadius.circular(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (isGoogleLoading)
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.grey[600]!,
                                  ),
                                ),
                              )
                            else ...[
                              Icon(
                                PhosphorIcons.googleLogo(PhosphorIconsStyle.regular),
                                size: 20,
                                color: Colors.black87,
                              ),
                              const SizedBox(width: 12),
                            ],
                            Text(
                              isGoogleLoading ? 'Signing up...' : 'Continue with Google',
                              style: TextStyle(
                                color: isGoogleLoading 
                                    ? Colors.grey[600]
                                    : Colors.black87,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Sign in link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.alreadyHaveAccount,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          l10n.signInButton,
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _createAccount() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final result = await AsyncOperationHandler.execute(
      context: context,
      operation: () async {
        try {
          final userCredential = await UserAuthService.createUserWithEmailAndPassword(
            _emailController.text.trim(),
            _passwordController.text,
          );
          if (userCredential == null) {
            throw Exception('Account creation failed');
          }
          return userCredential;
        } catch (e) {
          // Show specific error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Account creation failed: ${e.toString()}'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
          // Re-throw to prevent navigation
          rethrow;
        }
      },
      onLoading: (loading) => setState(() => isLoading = loading),
      errorMessage: 'Account creation failed',
      showErrorSnackbar: false, // We're handling errors manually
    );
    
    // Only navigate if account creation was successful
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

  Future<void> _signUpWithGoogle() async {
    final result = await AsyncOperationHandler.execute(
      context: context,
      operation: () async {
        try {
          final userCredential = await UserAuthService.signInWithGoogle();
          if (userCredential == null) {
            throw Exception('Google sign up was cancelled');
          }
          return userCredential;
        } catch (e) {
          // Show specific error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Google sign up failed: ${e.toString()}'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
          // Re-throw to prevent navigation
          rethrow;
        }
      },
      onLoading: (loading) => setState(() => isGoogleLoading = loading),
      errorMessage: 'Google sign up failed',
      showErrorSnackbar: false, // We're handling errors manually
    );
    
    // Only navigate if sign-up was successful
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
}
