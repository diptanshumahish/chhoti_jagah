import 'package:chhoti_jagah/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/ui_components/common_button.dart';
import '../../services/location_permission_service.dart';
import '../../utils/constants.dart';
import 'location_permission_denied_screen.dart';
import 'login_screen.dart';
import '../../utils/error_handler.dart';

class LocationPermissionScreen extends ConsumerStatefulWidget {
  const LocationPermissionScreen({super.key});

  @override
  ConsumerState<LocationPermissionScreen> createState() => _LocationPermissionScreenState();
}

class _LocationPermissionScreenState extends ConsumerState<LocationPermissionScreen> {
  bool isLoading = false;

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
                  
                  // Location icon
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(
                      Icons.location_on,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Title and subtitle
                  Column(
                    children: [
                      Text(
                        l10n.locationPermissionTitle,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.locationPermissionSubtitle,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Description
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      l10n.locationPermissionDescription,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 16,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Allow location button
                  CommonButton(
                    text: l10n.locationPermissionButton,
                    onPressed: !isLoading ? _requestLocationPermission : null,
                    trailingIcon: Icons.location_on,
                    width: double.infinity,
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

  Future<void> _requestLocationPermission() async {
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
        // Permission denied, handle based on status
        final permissionStatus = await LocationPermissionService.getLocationPermissionStatus();
        
        if (permissionStatus == LocationPermissionStatus.deniedForever) {
          // Permission denied forever, go to denied screen
          await LocationPermissionService.markDeniedScreenAsShown();
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const LocationPermissionDeniedScreen(),
              ),
            );
          }
        } else if (permissionStatus == LocationPermissionStatus.denied) {
          // Permission denied, stay on current screen to show error
          // The user can try again
          setState(() {
            isLoading = false;
          });
          
          // Show error message
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Location permission denied. Please try again.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        } else {
          // Other cases, go to denied screen
          await LocationPermissionService.markDeniedScreenAsShown();
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const LocationPermissionDeniedScreen(),
              ),
            );
          }
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
