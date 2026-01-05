import 'package:baylora_prjct/feature/profile/domain/user_profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  final _supabase = Supabase.instance.client;

  String get userId => _supabase.auth.currentUser!.id;

  // ✅ FIXED: Maps the List<Map> from Supabase to a single UserProfile
  Stream<UserProfile> get myProfileStream {
    return _supabase
        .from('profiles')
        .stream(primaryKey: ['id'])
        .eq('id', userId)
        .map((event) {
      if (event.isEmpty) {
        // Return empty profile if not found
        return UserProfile(id: userId, username: '', fullName: 'User');
      }
      return UserProfile.fromMap(event.first);
    });
  }

  Stream<List<Map<String, dynamic>>> get myListingsStream {
    return _supabase
        .from('items')
        .select()
        .eq('owner_id', userId)
        .order('created_at', ascending: false)
        .asStream();
  }

  Stream<List<Map<String, dynamic>>> get myBidsStream {
    return _supabase
        .from('offers')
        .select('*, items(*)')
        .eq('bidder_id', userId)
        .order('created_at', ascending: false)
        .asStream();
  }

  Future<void> updateProfile({String? bio, String? firstName, String? lastName, String? username}) async {
    final updates = <String, dynamic>{};
    if (bio != null) updates['bio'] = bio;
    if (firstName != null) updates['first_name'] = firstName;
    if (lastName != null) updates['last_name'] = lastName;
    if (username != null) updates['username'] = username;

    if (updates.isEmpty) return;
    await _supabase.from('profiles').update(updates).eq('id', userId);
  }
}
