import 'package:flutter/material.dart';

/// A utility class for handling async operations with error handling and loading states
class AsyncOperationHandler {
  /// Executes an async operation with automatic error handling and loading state management
  /// 
  /// [context] - The build context for showing snackbars
  /// [operation] - The async operation to execute
  /// [onLoading] - Callback to set loading state
  /// [onError] - Optional custom error handler, defaults to showing a snackbar
  /// [errorMessage] - Optional custom error message prefix
  /// [showErrorSnackbar] - Whether to show error snackbar (default: true)
  static Future<T?> execute<T>({
    required BuildContext context,
    required Future<T> Function() operation,
    required Function(bool) onLoading,
    Function(String)? onError,
    String errorMessage = 'Error',
    bool showErrorSnackbar = true,
  }) async {
    onLoading(true);
    
    try {
      if (context.mounted) {
        return await operation();
      }
      return null;
    } catch (e) {
      final errorText = '$errorMessage: $e';
      
      // Call custom error handler if provided
      onError?.call(errorText);
      
      // Show default error snackbar if enabled
      if (showErrorSnackbar && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorText),
            backgroundColor: Colors.red,
          ),
        );
      }
      
      return null;
    } finally {
      if (context.mounted) {
        onLoading(false);
      }
    }
  }

  /// Executes an async operation with navigation after success
  /// 
  /// [context] - The build context for navigation and error handling
  /// [operation] - The async operation to execute
  /// [onLoading] - Callback to set loading state
  /// [navigateTo] - The widget to navigate to after successful operation
  /// [replace] - Whether to replace the current route (default: false)
  /// [onError] - Optional custom error handler
  /// [errorMessage] - Optional custom error message prefix
  static Future<void> executeWithNavigation<T>({
    required BuildContext context,
    required Future<T> Function() operation,
    required Function(bool) onLoading,
    required Widget navigateTo,
    bool replace = false,
    Function(String)? onError,
    String errorMessage = 'Error',
  }) async {
    final result = await execute(
      context: context,
      operation: operation,
      onLoading: onLoading,
      onError: onError,
      errorMessage: errorMessage,
    );
    
    // Navigate only if operation was successful (result is not null) and context is still mounted
    if (result != null && context.mounted) {
      if (replace) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => navigateTo),
        );
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => navigateTo),
        );
      }
    }
  }
}
