
import 'package:baylora_prjct/feature/post/constants/post_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ListingRepository {
  final SupabaseClient _client;

  ListingRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  /// Uploads a list of images to Supabase storage.
  /// Accepts XFile to support both Mobile and Web.
  Future<List<String>> uploadImages(List<XFile> images, String userId) async {
    final List<String> uploadedUrls = [];

    for (var image in images) {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      
      // Get filename safely
      String name = image.name; // XFile has a .name property
      
      final path = '$userId/${timestamp}_$name';
      
      // Read as bytes to support Web and Mobile consistently
      final Uint8List bytes = await image.readAsBytes();

      await _client.storage
          .from(PostStorage.bucketItemImages)
          .uploadBinary(
            path,
            bytes,
            fileOptions: const FileOptions(contentType: 'image/jpeg'), // Adjust if needed
          );

      final url = _client.storage
          .from(PostStorage.bucketItemImages)
          .getPublicUrl(path);

      uploadedUrls.add(url);
    }
    return uploadedUrls;
  }

  /// Inserts a new listing into the database.
  Future<String> createListing(Map<String, dynamic> listingData) async {
    final response = await _client
        .from(PostStorage.tableItems)
        .insert(listingData)
        .select()
        .single();

    return response['id'].toString();
  }

  /// Calls an RPC to increment the total_trades count for the current user.
  /// This requires the 'increment_user_trades' SQL function in your Supabase project.
  Future<void> incrementTotalTrades() async {
    try {
      // await _client.rpc('increment_user_trades');
      // Logic for incrementing trades is removed as per updated requirement.
    } catch (e) {
      if (kDebugMode) {
        print('Could not increment total trades: $e');
      }
    }
  }
}
