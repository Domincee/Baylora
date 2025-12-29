import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:baylora_prjct/feature/profile/service/profile_service.dart';
import 'package:baylora_prjct/feature/profile/domain/user_profile.dart';

final profileServiceProvider = Provider<ProfileService>((ref) {
  return ProfileService();
});

// ✅ FIXED: Returns UserProfile (The Model), not Map
final userProfileProvider = StreamProvider<UserProfile>((ref) {
  final profileService = ref.watch(profileServiceProvider);
  return profileService.myProfileStream;
});

// Listings (returns List of Maps)
final myListingsProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final profileService = ref.watch(profileServiceProvider);
  return profileService.myListingsStream;
});

// Bids (returns List of Maps)
final myBidsProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final profileService = ref.watch(profileServiceProvider);
  return profileService.myBidsStream;
});
