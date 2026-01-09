import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../profile/provider/profile_provider.dart';
import '../../details/provider/item_details_provider.dart';
import '../constant/manage_listing_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_style.dart';
import '../../post/constants/post_storage.dart';

mixin ManageListingActions {
  Future<void> handleDeleteListing(BuildContext context, WidgetRef ref, String itemId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(ManageListingStrings.deleteListing, style: AppTextStyles.bodyLarge(context)),
        content: Text(ManageListingStrings.deleteConfirmationMessage, style: AppTextStyles.bodyLarge(context)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text(ManageListingStrings.cancel)),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(ManageListingStrings.deleteAction, style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final client = Supabase.instance.client;

      // 1. Fetch item to get image URLs before deleting
      final itemData = await client
          .from(PostStorage.tableItems)
          .select('images')
          .eq('id', itemId)
          .single();

      final List<dynamic>? imageUrls = itemData['images'];

      // 2. Delete the item from the database
      await client.from(PostStorage.tableItems).delete().eq('id', itemId);

      // 3. Delete images from storage if they exist
      if (imageUrls != null && imageUrls.isNotEmpty) {
        final List<String> pathsToDelete = imageUrls.map((url) {
          final uri = Uri.parse(url.toString());
          final pathSegments = uri.pathSegments;
          // Supabase public URL format: .../storage/v1/object/public/bucket_name/path/to/file
          // We need the part after the bucket name
          final bucketIndex = pathSegments.indexOf(PostStorage.bucketItemImages);
          if (bucketIndex != -1 && bucketIndex < pathSegments.length - 1) {
            return pathSegments.sublist(bucketIndex + 1).join('/');
          }
          return '';
        }).where((path) => path.isNotEmpty).toList();

        if (pathsToDelete.isNotEmpty) {
          await client.storage.from(PostStorage.bucketItemImages).remove(pathsToDelete);
        }
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(ManageListingStrings.deleteSuccess)));
        ref.invalidate(myListingsProvider);
        ref.invalidate(itemDetailsProvider(itemId));
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${ManageListingStrings.errorPrefix}$e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> handleAcceptOffer(BuildContext context, WidgetRef ref, String itemId, String offerId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(ManageListingStrings.acceptOfferDialogTitle, style: AppTextStyles.titleSmall(context)),
        content: Text(ManageListingStrings.acceptOfferDialogContent, style: AppTextStyles.bodyMedium(context)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(ManageListingStrings.cancel)),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(ManageListingStrings.confirm)),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await Supabase.instance.client.rpc('accept_offer', params: {'p_offer_id': offerId});
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ManageListingStrings.offerAcceptedSnackbar)));
        ref.invalidate(itemDetailsProvider(itemId));
        ref.invalidate(myListingsProvider);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${ManageListingStrings.errorAcceptingOfferPrefix}$e"), backgroundColor: AppColors.errorColor),
        );
      }
    }
  }

  Future<void> handleRejectOffer(BuildContext context, WidgetRef ref, String itemId, String offerId) async {
    try {
      await Supabase.instance.client.from('offers').update({'status': 'rejected'}).eq('id', offerId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ManageListingStrings.offerRejectedSnackbar)));
        ref.invalidate(itemDetailsProvider(itemId));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${ManageListingStrings.errorRejectingOfferPrefix}$e"), backgroundColor: AppColors.errorColor),
        );
      }
    }
  }
}
