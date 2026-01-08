import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:baylora_prjct/feature/home/constant/home_strings.dart';
import 'package:baylora_prjct/core/models/item_model.dart';

class HomeRepository {
  final SupabaseClient _client;

  HomeRepository(this._client);

  Future<List<ItemModel>> fetchItems(String filter) async {
    // Start the query
    dynamic query = _client
        .from('items')
        .select('*, profiles:owner_id(username, avatar_url, rating, total_trades, is_verified)');

    query = query.eq('status', HomeStrings.statusActive);

    // Apply specific filters
    if (filter == HomeStrings.categoryEnding) {
      query = query
          .not('end_time', 'is', null) // Ensure has duration
          .gt('end_time', DateTime.now().toUtc().toIso8601String())
          .order('end_time', ascending: true);
    } else if (filter == HomeStrings.categoryForSale) {
      query = query
          .or('type.eq.${HomeStrings.cash},type.eq.${HomeStrings.mix}')
          .order('created_at', ascending: false);
    } else if (filter == HomeStrings.categoryForTrade) {
      query = query
          .or('type.eq.${HomeStrings.trade},type.eq.${HomeStrings.mix}')
          .order('created_at', ascending: false);
    } else {
      // All or default
      query = query
          .order('created_at', ascending: false);
    }

    final response = await query;
    return (response as List<dynamic>)
        .map((e) => ItemModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}
