class AppValidators {
  static String? required(String? val) =>
      val == null || val.isEmpty ? "Required" : null;

  static String? lettersOnly(String? val) {
    if (val == null || val.isEmpty) return "Required";
    if (!RegExp(r'^[a-zA-Z]+$').hasMatch(val)) return "Letters only";
    return null;
  }

  static String? email(String? val) {
    if (val == null || val.isEmpty) return "Required";
    if (!val.contains('@') || !val.contains('.')) return "Invalid Email";
    return null;
  }

  static String? validateEmail(String? val) => email(val);

  static String? password(String? val) =>
      val != null && val.length < 6 ? "Min 6 chars" : null;

  static String? validatePassword(String? val) => password(val);

  static String? validateUsername(String? val) {
    if (val == null || val.isEmpty) return "Required";
    if (val.length < 3) return "Min 3 chars";
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(val)) {
      return "Letters, numbers, underscore only";
    }
    return null;
  }

  static String? validateName(String? val, {String fieldName = "Name"}) {
    if (val == null || val.isEmpty) return "Required";
    if (!RegExp(r'^[a-zA-Z]+$').hasMatch(val)) {
      return "$fieldName should contain letters only";
    }
    return null;
  }

  static String? confirmPassword(String? val, String password) =>
      val != password ? "Mismatch" : null;
}