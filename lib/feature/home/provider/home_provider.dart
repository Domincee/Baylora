import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final homeItemsProvider = StreamProvider.autoDispose.family<List<Map<String, dynamic>>, String>((ref, filter) {
  final supabase = Supabase.instance.client;

  // Start the query
  var query = supabase
      .from('items')
      .select('*, profiles:owner_id(username, avatar_url, rating, total_trades)');

  // Common filter for all views: Item must be active
  query = query.eq('status', 'active');

  // Apply specific filters
  switch (filter) {
    case 'Ending':
      return query
          .not('end_time', 'is', null) // Ensure has duration
          .gt('end_time', DateTime.now().toUtc().toIso8601String()) // Ensure not ended (Compare in UTC)
          .order('end_time', ascending: true)
          .asStream();

    case 'Hot':
      return query
          .order('price', ascending: false)
          .asStream();

    case 'New':
    case 'All':
    default:
      return query
          .order('created_at', ascending: false)
          .asStream();
  }
});
