import 'package:baylora_prjct/feature/details/constants/item_details_strings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final itemDetailsProvider = StreamProvider.autoDispose.family<Map<String, dynamic>, String>((ref, itemId) {
  return Supabase.instance.client
      .from(ItemDetailsStrings.tableItems)
      .select('*, ${ItemDetailsStrings.fieldOffers}(*, ${ItemDetailsStrings.fieldProfiles}(*))')
      .eq('id', itemId)
      .single()
      .asStream()
      .map((data) => Map<String, dynamic>.from(data));
});

final userOfferProvider = StreamProvider.autoDispose.family<Map<String, dynamic>?, String>((ref, itemId) {
  final userId = Supabase.instance.client.auth.currentUser?.id;
  if (userId == null) return Stream.value(null);
  
  return Supabase.instance.client
      .from(ItemDetailsStrings.fieldOffers)
      .select()
      .eq('item_id', itemId)
      .eq('bidder_id', userId)
      .maybeSingle()
      .asStream()
      .map((data) => data == null ? null : Map<String, dynamic>.from(data));
});
