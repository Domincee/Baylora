import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authProvider = Provider<AuthService>((ref) {
  return AuthService(Supabase.instance.client);
});

final userProvider = Provider.autoDispose<User?>((ref) {
  return Supabase.instance.client.auth.currentUser;
});

class AuthService {
  final SupabaseClient supabase;

  AuthService(this.supabase);

  Future<void> register({
    required String email,
    required String password,
    required String username,
    required String firstName,
    required String lastName,
  }) async {
    await supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        'username': username,
        'first_name': firstName,
        'last_name': lastName,
      },
    );
  }

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    return await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  User? get currentUser => supabase.auth.currentUser;
}
