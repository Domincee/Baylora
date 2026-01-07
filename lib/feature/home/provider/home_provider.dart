import 'package:baylora_prjct/feature/home/repository/home_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepository(Supabase.instance.client);
});

final homeItemsProvider = StreamProvider.autoDispose.family<List<Map<String, dynamic>>, String>((ref, filter) {
  final homeRepository = ref.watch(homeRepositoryProvider);
  return homeRepository.fetchItems(filter);
});
