import 'package:flutter/material.dart';

/// Base controller for authentication forms (login, register).
class AuthFormController {
  // Email field
  final emailCtrl = TextEditingController();

  // Password field
  final passCtrl = TextEditingController();

  // Form key for validation
  final formKey = GlobalKey<FormState>();

  /// Validates the form using the form key
  bool validate() => formKey.currentState?.validate() ?? false;

  /// Clears all form fields
  void clearForm() {
    emailCtrl.clear();
    passCtrl.clear();
  }

  /// Resets form validation state
  void resetForm() {
    formKey.currentState?.reset();
  }

  /// Returns a map of field values for convenience
  Map<String, String> getValues() {
    return {
      'email': emailCtrl.text.trim(),
      'password': passCtrl.text.trim(),
    };
  }

  /// Disposes all resources
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
  }
}

/// Extended controller for registration forms with additional fields
class RegisterFormController extends AuthFormController {
  final userNameCtrl = TextEditingController();
  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final confirmPassCtrl = TextEditingController();

  @override
  void clearForm() {
    super.clearForm();
    userNameCtrl.clear();
    firstNameCtrl.clear();
    lastNameCtrl.clear();
    confirmPassCtrl.clear();
  }

  @override
  void dispose() {
    super.dispose();
    userNameCtrl.dispose();
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    confirmPassCtrl.dispose();
  }

  /// Returns a map of all registration field values
  @override
  Map<String, String> getValues() {
    final base = super.getValues();
    base.addAll({
      'username': userNameCtrl.text.trim(),
      'firstName': firstNameCtrl.text.trim(),
      'lastName': lastNameCtrl.text.trim(),
      'confirmPassword': confirmPassCtrl.text.trim(),
    });
    return base;
  }

  /// Optional: helper to check if passwords match
  bool passwordsMatch() => passCtrl.text.trim() == confirmPassCtrl.text.trim();
}

/// Extended controller for login forms (can add more login-specific fields)
class LoginFormController extends AuthFormController {
  // Placeholder for future login-specific fields, e.g., rememberMe
  // bool rememberMe = false;
}
