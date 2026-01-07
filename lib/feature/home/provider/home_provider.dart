import 'package:baylora_prjct/feature/home/repository/home_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:baylora_prjct/core/models/item_model.dart';

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepository(Supabase.instance.client);
});

final homeItemsProvider = FutureProvider.autoDispose.family<List<ItemModel>, String>((ref, filter) {
  final homeRepository = ref.watch(homeRepositoryProvider);
  return homeRepository.fetchItems(filter);
});
