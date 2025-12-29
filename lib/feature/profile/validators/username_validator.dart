String? validateUsername(String username) {
  final value = username.trim();

  if (value.length < 3) {
    return "must be at least 3 characters";
  }

  if (RegExp(r'[^a-zA-Z_]').hasMatch(value)) {
    return "Invalid username format (@,#,.)";
  }

  return null;
}
