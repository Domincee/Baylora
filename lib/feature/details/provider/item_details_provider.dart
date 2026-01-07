import 'package:baylora_prjct/feature/details/constants/item_details_strings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final itemDetailsProvider = StreamProvider.autoDispose.family<Map<String, dynamic>, String>((ref, itemId) {
  return Supabase.instance.client
      .from(ItemDetailsStrings.tableItems)
      .select('*, ${ItemDetailsStrings.fieldProfiles}(*), ${ItemDetailsStrings.fieldOffers}(*, ${ItemDetailsStrings.fieldProfiles}(*))')
      .eq('id', itemId)
      .single()
      .asStream();
});
