import 'package:supabase_flutter/supabase_flutter.dart';

class ItemFilterUtil {
  // 1. The list of filter categories
  static const List<String> categories = ["All", "For Sale", "For Trade", "Ending"];

  // 2. The logic to build the database query
  static Stream<List<Map<String, dynamic>>> buildQueryStream(String filter) {
    var query = Supabase.instance.client
        .from('items')
        .select('*, profiles:owner_id(username, avatar_url, rating, total_trades)');
    
    // Global filter: Hide items that have ended
    query = query.gt('end_time', DateTime.now().toIso8601String());

    switch (filter) {
      case 'Ending':
        // Shows items ending soonest (ignoring ones that already ended)
        return query
            .not('end_time', 'is', null)
            // .gt check is already applied globally above
            .order('end_time', ascending: true)
            .asStream();
      
      case 'For Sale':
        // Fetch items where type is 'cash' (0) or 'mix' (2)
        // Using 'in' filter for multiple values
        return query
            .inFilter('type', ['cash', 'mix'])
            .order('created_at', ascending: false)
            .asStream();

      case 'For Trade':
        // Fetch items where type is 'trade' (1) or 'mix' (2)
        return query
            .inFilter('type', ['trade', 'mix'])
            .order('created_at', ascending: false)
            .asStream();

      case 'All':
      default:
        // Default: Newest items first
        return query.order('created_at', ascending: false).asStream();
    }
  }
}
