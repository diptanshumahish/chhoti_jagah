import 'package:chhoti_jagah/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/ui_components/common_button.dart';
import '../../widgets/form_components/language_selection_widget.dart';
import 'location_permission_screen.dart';
import '../../utils/error_handler.dart';

class LanguageSelectionScreen extends ConsumerStatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  ConsumerState<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends ConsumerState<LanguageSelectionScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
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
                  
                  Column(
                    children: [
                      Text(
                        l10n.beforeWeBegin,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.chooseLanguageTo,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.continueScrollToSeeMore,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  LanguageSelectionWidget(
                    height: 200,
                    padding: const EdgeInsets.all(16),
                    onLanguageSelected: _onLanguageSelected,
                  ),
                  
                  const SizedBox(height: 32),
                  
                  CommonButton(
                    text: l10n.continueButton,
                    onPressed: !isLoading ? _onContinuePressed : null,
                    trailingIcon: Icons.arrow_forward,
                    width: double.infinity,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Terms and conditions text
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                      children: [
                        TextSpan(text: l10n.bySigningUpYouAgree),
                        TextSpan(
                          text: l10n.termsAndConditions,
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            decoration: TextDecoration.underline,
                          ),
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
    );
  }

  void _onLanguageSelected() {
    // Language is already updated by the widget
    // This callback can be used for additional actions if needed
  }

  Future<void> _onContinuePressed() async {
    await AsyncOperationHandler.executeWithNavigation(
      context: context,
      operation: () async {
        return true;
      },
      onLoading: (loading) => setState(() => isLoading = loading),
      navigateTo: const LocationPermissionScreen(),
      replace: true,
      errorMessage: 'Failed to save language',
    );
  }
}
