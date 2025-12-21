import 'package:supabase_flutter/supabase_flutter.dart';

class ItemFilterUtil {
  // 1. The list of filter categories
  static const List<String> categories = ["All", "Hot", "New", "Ending"];

  // 2. The logic to build the database query
  static Stream<List<Map<String, dynamic>>> buildQueryStream(String filter) {
    var query = Supabase.instance.client
        .from('items')
        .select('*, profiles:owner_id(username, avatar_url, rating, total_trades)');

    switch (filter) {
      case 'Ending':
        // Shows items ending soonest (ignoring ones that already ended)
        return query
            .not('end_time', 'is', null)
            .gt('end_time', DateTime.now().toIso8601String())
            .order('end_time', ascending: true)
            .asStream();
      
      case 'Hot':
        // Sort by highest price (You can change this logic later)
        return query.order('price', ascending: false).asStream();


      case 'New':
      case 'All':
      default:
        // Default: Newest items first
        return query.order('created_at', ascending: false).asStream();
    }
  }
}