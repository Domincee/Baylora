String? mapProfileUpdateError(Object error) {
  final message = error.toString().toLowerCase();

  if (message.contains("unique") || message.contains("already exists")) {
    return "This username is already taken";
  }

  if (message.contains("check constraint")) {
    return "Invalid username format";
  }

  return null;
}
