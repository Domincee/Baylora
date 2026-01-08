import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../profile/provider/profile_provider.dart';
import '../../details/provider/item_details_provider.dart';
import '../constant/manage_listing_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_style.dart';

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
      await Supabase.instance.client.from('items').delete().eq('id', itemId);
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