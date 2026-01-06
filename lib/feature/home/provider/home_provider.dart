import 'package:baylora_prjct/feature/home/constant/home_strings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final homeItemsProvider = StreamProvider.autoDispose.family<List<Map<String, dynamic>>, String>((ref, filter) {
  final supabase = Supabase.instance.client;

  // Start the query
  var query = supabase
      .from('items')
      .select('*, profiles:owner_id(username, avatar_url, rating, total_trades, is_verified)');


  query = query.eq('status', HomeStrings.statusActive);

  // Apply specific filters
  if (filter == HomeStrings.categoryEnding) {
    return query
        .not('end_time', 'is', null) // Ensure has duration
        .gt('end_time', DateTime.now().toUtc().toIso8601String())
        .order('end_time', ascending: true)
        .asStream();
  } else if (filter == HomeStrings.categoryForSale) {
    return query
        .eq('type', HomeStrings.cash)
        .order('created_at', ascending: false)
        .asStream();
  } else if (filter == HomeStrings.categoryForTrade) {
    return query
        .eq('type', HomeStrings.trade)
        .order('created_at', ascending: false)
        .asStream();
  } else {
    // All or default
    return query
        .order('created_at', ascending: false)
        .asStream();
  }
});
