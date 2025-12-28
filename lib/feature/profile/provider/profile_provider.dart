import 'package:baylora_prjct/feature/profile/service/profile_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// 1. Supabase Client Provider
final supabaseProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// 2. User ID Provider (Watch for auth changes)
final userIdProvider = Provider<String?>((ref) {
  final user = ref.watch(supabaseProvider).auth.currentUser;
  return user?.id;
});

// 3. Profile Service Provider
final profileServiceProvider = Provider<ProfileService>((ref) {
  return ProfileService();
});

// 4. User Profile Stream Provider
final userProfileProvider = StreamProvider<Map<String, dynamic>>((ref) {
  final supabase = ref.watch(supabaseProvider);
  final userId = ref.watch(userIdProvider);

  if (userId == null) return const Stream.empty();

  return supabase
      .from('profiles')
      .stream(primaryKey: ['id'])
      .eq('id', userId)
      .map((event) {
        if (event.isEmpty) return {};
        final data = event.first;
        final String first = data['first_name'] ?? '';
        final String last = data['last_name'] ?? '';
        data['full_name'] = '$first $last'.trim();
        return data;
      });
});

// 5. User Listings Stream Provider
final myListingsProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final supabase = ref.watch(supabaseProvider);
  final userId = ref.watch(userIdProvider);

  if (userId == null) return const Stream.empty();

  return supabase
      .from('items')
      .stream(primaryKey: ['id'])
      .eq('owner_id', userId)
      .order('created_at', ascending: false);
});

// 6. User Bids Stream Provider
final myBidsProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final supabase = ref.watch(supabaseProvider);
  final userId = ref.watch(userIdProvider);

  if (userId == null) return const Stream.empty();

  return supabase
      .from('offers')
      .select('*, items(*)')
      .eq('bidder_id', userId)
      .order('created_at', ascending: false)
      .asStream();
});
