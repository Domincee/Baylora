import 'package:flutter/material.dart';

/// Base controller for authentication forms (login, register).
/// Manages form state, controllers, and validation logic.
class AuthFormController {
  // Email field
  final emailCtrl = TextEditingController();

  // Password field
  final passCtrl = TextEditingController();

  // Form key for validation
  final formKey = GlobalKey<FormState>();

  /// Validates the form using the form key
  bool validate() {
    return formKey.currentState?.validate() ?? false;
  }

  /// Clears all form fields
  void clearForm() {
    emailCtrl.clear();
    passCtrl.clear();
  }

  /// Resets form validation state
  void resetForm() {
    formKey.currentState?.reset();
  }

  /// Disposes all resources
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
  }
}

/// Extended controller for registration forms with additional fields
class RegisterFormController extends AuthFormController {
  // Username field
  final userNameCtrl = TextEditingController();

  // First name field
  final firstNameCtrl = TextEditingController();

  // Last name field
  final lastNameCtrl = TextEditingController();

  // Confirm password field
  final confirmPassCtrl = TextEditingController();

  /// Clears all form fields including register-specific ones
  @override
  void clearForm() {
    super.clearForm();
    userNameCtrl.clear();
    firstNameCtrl.clear();
    lastNameCtrl.clear();
    confirmPassCtrl.clear();
  }

  /// Disposes all resources including register-specific ones
  @override
  void dispose() {
    super.dispose();
    userNameCtrl.dispose();
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    confirmPassCtrl.dispose();
  }
}

/// Extended controller for login forms (can be extended with remember-me, etc.)
class LoginFormController extends AuthFormController {
  // Add login-specific fields here in the future
  // e.g., bool rememberMe = false;
}
