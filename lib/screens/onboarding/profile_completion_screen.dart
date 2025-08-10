import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';
import '../../models/user_model.dart';
import '../../services/username_availability_service.dart';
import '../../state_management/providers/user_provider.dart';
import '../../utils/error_handler.dart';
import '../../widgets/ui_components/common_button.dart';
import '../../widgets/ui_components/floating_language_selector.dart';
import '../../widgets/form_components/index.dart';
import '../main/home_screen.dart';
import 'dart:async';

class ProfileCompletionScreen extends ConsumerStatefulWidget {
  final String? fullName;
  final String emailId;
  final bool isGoogleSignIn;

  const ProfileCompletionScreen({
    super.key,
    this.fullName,
    required this.emailId,
    this.isGoogleSignIn = false,
  });

  @override
  ConsumerState<ProfileCompletionScreen> createState() =>
      _ProfileCompletionScreenState();
}

class _ProfileCompletionScreenState
    extends ConsumerState<ProfileCompletionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _userBioController = TextEditingController();
  AgeGroup? _selectedAgeGroup;
  bool _isLoading = false;
  bool _isCheckingUsername = false;
  bool _isUsernameAvailable = false;
  String? _usernameError;
  List<String> _usernameSuggestions = [];

  // Debounce function for username checking
  late final Function(String) _debouncedCheckUsername;

  @override
  void initState() {
    super.initState();
    _fullNameController.text = widget.fullName ?? '';
    _debouncedCheckUsername = debounce(
      _checkUsernameAvailability,
      const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _fullNameController.dispose();
    _userBioController.dispose();
    super.dispose();
  }

  Function(String) debounce(Function(String) func, Duration wait) {
    Timer? timer;
    return (String username) {
      timer?.cancel();
      timer = Timer(wait, () => func(username));
    };
  }

  Future<void> _checkUsernameAvailability(String username) async {
    if (username.length < 3) {
      setState(() {
        _isUsernameAvailable = false;
        _usernameError = null;
      });
      return;
    }

    if (!UsernameAvailabilityService.isValidUsername(username)) {
      setState(() {
        _isUsernameAvailable = false;
        _usernameError =
            'Username can only contain letters, numbers, and underscores, and must start with a letter';
      });
      return;
    }

    setState(() {
      _isCheckingUsername = true;
      _usernameError = null;
    });

    try {
      final isAvailable = await UsernameAvailabilityService.isUsernameAvailable(
        username,
      );
      setState(() {
        _isUsernameAvailable = isAvailable;
        _isCheckingUsername = false;
        if (isAvailable) {
          _usernameError = null;
        } else {
          _usernameError = 'Username is already taken';
        }
      });
    } catch (e) {
      setState(() {
        _isUsernameAvailable = false;
        _isCheckingUsername = false;
        _usernameError = 'Error checking username availability';
      });
    }
  }

  Future<void> _getUsernameSuggestions() async {
    if (_fullNameController.text.isEmpty) return;

    try {
      final suggestions =
          await UsernameAvailabilityService.getUsernameSuggestions(
            _fullNameController.text,
          );
      setState(() {
        _usernameSuggestions = suggestions;
      });
    } catch (e) {
      print('Error getting username suggestions: $e');
    }
  }

  void _selectUsernameSuggestion(String username) {
    setState(() {
      _usernameController.text = username;
      _usernameSuggestions.clear();
    });
    _checkUsernameAvailability(username);
  }

  Future<void> _completeProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedAgeGroup == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an age group'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!_isUsernameAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please choose an available username'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final result = await AsyncOperationHandler.execute(
      context: context,
      operation: () async {
        try {
          final user = await ref
              .read(userNotifierProvider)
              .createUser(
                username: _usernameController.text.trim(),
                fullName: _fullNameController.text.trim(),
                emailId: widget.emailId,
                ageGroup: _selectedAgeGroup,
                userBio:
                    _userBioController.text.trim().isEmpty
                        ? null
                        : _userBioController.text.trim(),
              );
          return user;
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Profile creation failed: ${e.toString()}'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
          rethrow;
        }
      },
      onLoading: (loading) => setState(() => _isLoading = loading),
      errorMessage: 'Profile creation failed',
      showErrorSnackbar: false,
    );

    if (result != null && context.mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/pngs/storage.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.2)),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight:
                            MediaQuery.of(context).size.height -
                            MediaQuery.of(context).padding.top -
                            MediaQuery.of(context).padding.bottom -
                            48,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 60),

                          const SizedBox(height: 32),

                          ProfileHeader(
                            title: l10n.completeProfileTitle,
                            subtitle: l10n.completeProfileSubtitle,
                          ),

                          const SizedBox(height: 32),

                          if (!widget.isGoogleSignIn) ...[
                            ProfileFormField(
                              label: l10n.fullNameLabel,
                              hint: l10n.fullNameHint,
                              controller: _fullNameController,
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return l10n.fullNameValidationError;
                                }
                                return null;
                              },
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  _getUsernameSuggestions();
                                }
                              },
                            ),
                            const SizedBox(height: 16),
                          ],

                          // Username field
                          ProfileFormField(
                            label: l10n.usernameLabel,
                            hint: l10n.usernameHint,
                            controller: _usernameController,
                            prefixIcon: Icon(
                              Icons.alternate_email,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                            suffixIcon: _isCheckingUsername
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : _isUsernameAvailable
                                    ? const Icon(Icons.check_circle, color: Colors.green)
                                    : _usernameController.text.isNotEmpty
                                        ? const Icon(Icons.cancel, color: Colors.red)
                                        : null,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return l10n.usernameValidationError;
                              }
                              if (value.length < 3) {
                                return l10n.usernameLengthError;
                              }
                              if (!UsernameAvailabilityService.isValidUsername(value)) {
                                return l10n.usernameFormatError;
                              }
                              if (!_isUsernameAvailable) {
                                return l10n.usernameNotAvailableError;
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _debouncedCheckUsername(value);
                            },
                          ),

                          // Username error
                          if (_usernameError != null) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  _usernameError!,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],

                          // Username suggestions
                          UsernameSuggestions(
                            suggestions: _usernameSuggestions,
                            onSuggestionSelected: _selectUsernameSuggestion,
                          ),

                          const SizedBox(height: 16),

                          AgeGroupSelector(
                            selectedAgeGroup: _selectedAgeGroup,
                            onAgeGroupSelected: (ageGroup) {
                              setState(() {
                                _selectedAgeGroup = ageGroup;
                              });
                            },
                            label: l10n.selectAgeGroupLabel,
                            validationError: l10n.ageGroupValidationError,
                          ),

                          const SizedBox(height: 24),

                          // User Bio field
                          ProfileFormField(
                            label: l10n.bioLabel,
                            hint: l10n.bioHint,
                            controller: _userBioController,
                            maxLines: 3,
                            prefixIcon: Icon(
                              Icons.info_outline,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Complete Profile button
                          CommonButton(
                            text: l10n.completeProfileButton,
                            onPressed: !_isLoading ? _completeProfile : null,
                            trailingIcon: Icons.check_circle,
                            width: double.infinity,
                          ),

                          const SizedBox(height: 60),
                        ],
                      ),
                    ),
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
}
