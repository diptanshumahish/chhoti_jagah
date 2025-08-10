import 'package:chhoti_jagah/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/ui_components/common_button.dart';
import '../../services/location_permission_service.dart';
import '../../utils/constants.dart';
import 'location_permission_screen.dart';
import '../../utils/error_handler.dart';
import 'login_screen.dart';

class LocationPermissionDeniedScreen extends ConsumerStatefulWidget {
  const LocationPermissionDeniedScreen({super.key});

  @override
  ConsumerState<LocationPermissionDeniedScreen> createState() => _LocationPermissionDeniedScreenState();
}

class _LocationPermissionDeniedScreenState extends ConsumerState<LocationPermissionDeniedScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/pngs/lang.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.4),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const Spacer(),
                  
                  // Warning icon
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(
                      Icons.location_off,
                      size: 60,
                      color: Colors.orange,
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Title and subtitle
                  Column(
                    children: [
                      Text(
                        l10n.locationPermissionDeniedTitle,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.locationPermissionDeniedSubtitle,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      l10n.locationPermissionDeniedDescription,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 16,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  CommonButton(
                    text: l10n.locationPermissionDeniedButton,
                    onPressed: !isLoading ? _openAppSettings : null,
                    trailingIcon: Icons.settings,
                    width: double.infinity,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Try again button
                  CommonButton(
                    text: l10n.locationPermissionDeniedFallback,
                    onPressed: !isLoading ? _tryAgain : null,
                    trailingIcon: Icons.refresh,
                    width: double.infinity,
                    isOutlined: true,
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

  Future<void> _openAppSettings() async {
    await LocationPermissionService.openAppSettings();
  }

  Future<void> _tryAgain() async {
    setState(() => isLoading = true);
    
    try {
      final result = await LocationPermissionService.requestLocationPermission();
      
      if (result.granted) {
        // Permission granted, navigate to login screen
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        }
      } else {
        // Permission still denied, stay on current screen
        setState(() => isLoading = false);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Location permission still denied. Please enable it in settings.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      print('Error requesting location permission: $e');
      setState(() => isLoading = false);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error requesting location permission: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
