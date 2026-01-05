import 'package:baylora_prjct/feature/auth/constant/auth_strings.dart';

class AppValidators {
  static String? required(String? val) =>
      val == null || val.trim().isEmpty ? AuthStrings.requiredField : null;

  static String? lettersOnly(String? val) {
    if (val == null || val.trim().isEmpty) return AuthStrings.requiredField;
    if (!RegExp(r'^[a-zA-Z]+$').hasMatch(val)) return AuthStrings.lettersOnly;
    return null;
  }

  static String? email(String? val) {
    if (val == null || val.trim().isEmpty) return AuthStrings.requiredField;
    // Simple email regex for format validation
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val)) {
      return AuthStrings.invalidEmailFormat;
    }
    return null;
  }

  // Alias removed to avoid duplication
  // static String? validateEmail(String? val) => email(val);

  static String? password(String? val) {
    if (val == null || val.trim().isEmpty) return AuthStrings.requiredField;
    if (val.length < 6) return AuthStrings.passwordMinLength;
    return null;
  }

  // Alias removed to avoid duplication
  // static String? validatePassword(String? val) => password(val);

  static String? validateUsername(String? val) {
    if (val == null || val.trim().isEmpty) return AuthStrings.requiredField;
    if (val.length < 3) return "Min 3 chars";
    // Modified to allow only letters (a-z, A-Z)
    if (!RegExp(r'^[a-zA-Z]+$').hasMatch(val)) {
      return AuthStrings.lettersOnly;
    }
    return null;
  }

  static String? validateName(String? val, {String fieldName = "Name"}) {
    if (val == null || val.trim().isEmpty) return AuthStrings.requiredField;
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(val)) {
      return "$fieldName should contain letters only";
    }
    return null;
  }

  static String? confirmPassword(String? val, String password) {
    if (val == null || val.trim().isEmpty) return AuthStrings.requiredField;
    if (val != password) return AuthStrings.passwordMismatchError;
    return null;
  }
}
