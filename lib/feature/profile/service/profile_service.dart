import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  final _supabase = Supabase.instance.client;

  String get userId => _supabase.auth.currentUser!.id;

  // --- 1. PROFILE STREAM ---
  // Maps 'first_name' + 'last_name' -> 'full_name' for the UI
  Stream<Map<String, dynamic>> get myProfileStream {
    return _supabase
        .from('profiles')
        .stream(primaryKey: ['id'])
        .eq('id', userId)
        .map((event) {
          if (event.isEmpty) return {};
          final data = event.first;
          // Combine names for the UI
          final String first = data['first_name'] ?? '';
          final String last = data['last_name'] ?? '';
          data['full_name'] = '$first $last'.trim();
          return data;
        });
  }


  // Uses 'owner_id''
  Stream<List<Map<String, dynamic>>> get myListingsStream {
    return _supabase
        .from('items')
        .stream(primaryKey: ['id'])
        .eq('owner_id', userId) // 
        .order('created_at', ascending: false);
  }


  // Uses 'offers' table and joins 'items'
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
