import 'package:baylora_prjct/feature/details/constants/item_details_strings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final offerSubscriptionProvider = StreamProvider.family<List<Map<String, dynamic>>, String>((ref, itemId) {
  return Supabase.instance.client
      .from('offers')
      .stream(primaryKey: ['id'])
      .eq('item_id', itemId);
});

// ✅ FIX: Ensure query correctly joins profiles without filters that might exclude sold items
final itemDetailsProvider = StreamProvider.autoDispose.family<Map<String, dynamic>, String>((ref, itemId) {
  return Supabase.instance.client
      .from(ItemDetailsStrings.tableItems)
      // Removed implicit filters. Explicitly join profiles for the seller (owner_id -> profiles).
      // Also join offers and THEIR bidders.
      .select('*, profiles:owner_id(*), ${ItemDetailsStrings.fieldOffers}(*, profiles:bidder_id(*))')
      .eq('id', itemId)
      .single()
      .asStream()
      .map((data) => Map<String, dynamic>.from(data));
});

final userOfferProvider = FutureProvider.family<Map<String, dynamic>?, String>((ref, itemId) async {
  final user = Supabase.instance.client.auth.currentUser;
  if (user == null) return null;

  // Watch the stream! If status changes (Accepted/Rejected), this re-fetches.
  ref.watch(offerSubscriptionProvider(itemId));

  final response = await Supabase.instance.client
      .from('offers')
      .select()
      .eq('item_id', itemId)
      .eq('bidder_id', user.id)
      .maybeSingle();

  if (response == null) return null;
  return Map<String, dynamic>.from(response);
});
