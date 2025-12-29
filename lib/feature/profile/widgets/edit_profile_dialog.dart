import 'package:flutter/material.dart';

class EditProfileDialog extends StatefulWidget {
  final String username;
  final String bio;
  final Future<void> Function({required String username, required String bio}) onSave;

  const EditProfileDialog({
    super.key,
    required this.username,
    required this.bio,
    required this.onSave,
  });

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  late TextEditingController _usernameController;
  late TextEditingController _bioController;
  bool _isLoading = false;
  String? _usernameError;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.username);
    _bioController = TextEditingController(text: widget.bio);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    // 1. Validate Username locally
    final username = _usernameController.text.trim();
    if (username.length < 3) {
      setState(() => _usernameError = "must be at least 3 characters");
      return;
    }
    // VALIDATION: Only letters (a-z, A-Z) and underscores allowed. No numbers.
    if (RegExp(r'[^a-zA-Z_]').hasMatch(username)) {
      setState(() => _usernameError = "Invalid username format (@,#,.)");
      return;
    }
    // Reset error
    setState(() {
      _usernameError = null;
      _isLoading = true;
    });

    try {
      await widget.onSave(
        username: username,
        bio: _bioController.text.trim(),
      );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        // 2. Parse Supabase/Server errors into user-friendly messages
        String errorMessage = "Failed to update profile";
        final errorString = e.toString().toLowerCase();

        if (errorString.contains("unique") || errorString.contains("already exists")) {
          setState(() => _usernameError = "This username is already taken");
        } else if (errorString.contains("check constraint")) {
           setState(() => _usernameError = "Invalid username format");
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text(errorMessage)),
          );
        }
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit Profile"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: "Username",
              errorText: _usernameError, // Show error text here
            ),
            onChanged: (_) {
              if (_usernameError != null) setState(() => _usernameError = null);
            },
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _bioController,
            decoration: const InputDecoration(labelText: "Bio / Tagline"),
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _handleSave,
          child: _isLoading 
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text("Save"),
        ),
      ],
    );
  }
}
