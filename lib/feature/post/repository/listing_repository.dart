import 'dart:io';

import 'package:baylora_prjct/feature/post/constants/post_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ListingRepository {
  final SupabaseClient _client;

  ListingRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  /// Uploads a list of images to Supabase storage.
  /// Returns a list of public URLs for the uploaded images.
  /// Throws an exception if an upload fails.
  Future<List<String>> uploadImages(List<File> images, String userId) async {
    final List<String> uploadedUrls = [];

    for (var image in images) {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final name = image.path.split(Platform.pathSeparator).last;
      final path = '$userId/${timestamp}_$name';

      await _client.storage
          .from(PostStorage.bucketItemImages)
          .upload(path, image);

      final url = _client.storage
          .from(PostStorage.bucketItemImages)
          .getPublicUrl(path);

      uploadedUrls.add(url);
    }
    return uploadedUrls;
  }

  /// Inserts a new listing into the database.
  /// Returns the ID of the newly created listing.
  Future<String> createListing(Map<String, dynamic> listingData) async {
    final response = await _client
        .from(PostStorage.tableItems)
        .insert(listingData)
        .select()
        .single();

    return response['id'].toString();
  }
}
