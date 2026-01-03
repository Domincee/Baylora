import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final homeItemsProvider = StreamProvider.autoDispose.family<List<Map<String, dynamic>>, String>((ref, filter) {
  final supabase = Supabase.instance.client;

  // Start the query
  var query = supabase
      .from('items')
      .select('*, profiles:owner_id(username, avatar_url, rating, total_trades)');
      
  // Global filter: Hide items that have ended
  // We check that end_time is GREATER than now.
  // Note: If an item has NULL end_time (e.g., indefinite listing), this logic might hide it depending on DB schema.
  // If you want to keep indefinite items, use: .or('end_time.gt.${DateTime.now().toIso8601String()},end_time.is.null')
  // Assuming strict ending times for now as requested:
  query = query.gt('end_time', DateTime.now().toIso8601String());

  // Apply filters
  switch (filter) {
    case 'Ending':
      return query
          .not('end_time', 'is', null) // Redundant but safe
          .order('end_time', ascending: true)
          .asStream();

    case 'Hot':
      return query.order('price', ascending: false).asStream();

    case 'New':
    case 'All':
    default:
      return query.order('created_at', ascending: false).asStream();
  }
});
