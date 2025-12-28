import 'package:baylora_prjct/feature/profile/provider/profile_provider.dart'; // To access supabaseProvider
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. Home Items Stream Provider (Family allows passing the filter string)
// Added .autoDispose to ensure stream is closed and re-created when switching filters,
// preventing stale data when navigating back to "All".
final homeItemsProvider = StreamProvider.autoDispose.family<List<Map<String, dynamic>>, String>((ref, filter) {
  final supabase = ref.watch(supabaseProvider);
  
  // Start the query
  var query = supabase
      .from('items')
      .select('*, profiles:owner_id(username, avatar_url, rating, total_trades)');

  // Apply filters
  switch (filter) {
    case 'Ending':
      return query
          .not('end_time', 'is', null)
          .gt('end_time', DateTime.now().toIso8601String())
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
