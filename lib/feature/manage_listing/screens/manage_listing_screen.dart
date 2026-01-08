import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/core/theme/app_text_style.dart';
import 'package:baylora_prjct/core/widgets/listing_summary_card.dart';
import 'package:baylora_prjct/feature/chat/deal_chat_screen.dart';
import 'package:baylora_prjct/feature/details/constants/item_details_strings.dart';
import 'package:baylora_prjct/feature/details/provider/item_details_provider.dart';
import 'package:baylora_prjct/feature/details/widgets/bid_list.dart';
import 'package:baylora_prjct/feature/manage_listing/constant/manage_listing_strings.dart';
import 'package:baylora_prjct/feature/post/screens/edit_listing_screen.dart';
import 'package:baylora_prjct/feature/details/controller/item_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../profile/provider/profile_provider.dart';

class ManageListingScreen extends ConsumerWidget {
  final String itemId;

  const ManageListingScreen({super.key, required this.itemId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use the shared provider
    final itemAsync = ref.watch(itemDetailsProvider(itemId));

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title:  Text(ManageListingStrings.manageListingTitle, style: AppTextStyles.titleSmall(context)),
        backgroundColor: AppColors.white,
        elevation: 0,
        foregroundColor: AppColors.black,
        centerTitle: true,
      ),
      floatingActionButton: itemAsync.when(
        data: (item) => _buildFab(context, item),
        loading: () => null,
        error: (_, _) => null,
      ),
      body: itemAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("${ManageListingStrings.errorPrefix}$err", style: AppTextStyles.bodyMedium(context, color: AppColors.errorColor))),
        data: (item) {
          return _buildDashboard(context, ref, item);
        },
      ),
    );
  }

  Widget? _buildFab(BuildContext context, Map<String, dynamic> item) {
    final status = item['status'];
    if (status == 'accepted') {
      final offers = List<Map<String, dynamic>>.from(item['offers'] ?? []);
      final acceptedOffer = offers.firstWhere(
            (o) => o['status'] == 'accepted',
        orElse: () => {},
      );

      if (acceptedOffer.isNotEmpty) {
        final profile = acceptedOffer['profiles'];
        final username = profile != null ? profile['username'] : ManageListingStrings.defaultBuyerName;

        return FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DealChatScreen(
                  chatTitle: username,
                  itemName: item['title'] ?? ManageListingStrings.defaultItemName,
                  contextId: acceptedOffer['id'],
                ),
              ),
            );
          },
          label: Text(ManageListingStrings.openDealChat, style: AppTextStyles.bodyMedium(context, color: AppColors.highLightTextColor),),
          icon: const Icon(Icons.chat_bubble, color: AppColors.highLightTextColor,),
          backgroundColor: AppColors.lavenderBlue,
        );
      }
    }
    return null;
  }
  Widget _buildDashboard(
      BuildContext context,
      WidgetRef ref,
      Map<String, dynamic> item,
      ) {
    final status = item['status'] ?? 'active';
    final type = item['type'] ?? ItemDetailsStrings.typeCash;

    final isTrade = type == ItemDetailsStrings.typeTrade;
    final isMix = type == ItemDetailsStrings.typeMix;

    final endTime = ItemDetailsController.parseEndTime(item['end_time']);
    final isExpired = endTime != null && DateTime.now().isAfter(endTime);

    final rawOffers = item[ItemDetailsStrings.fieldOffers] ?? [];
    final offers = ItemDetailsController.sortOffers(rawOffers);

    final bool isLocked = status == 'accepted' || status == 'sold';

    return SingleChildScrollView(
      padding: AppValues.paddingAll,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Use a Stack here so the Positioned Delete button works
          Stack(
            children: [
              ListingSummaryCard(
                item: item,
                bottomAction: OutlinedButton.icon(
                  onPressed: isLocked
                      ? null
                      : () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => EditListingScreen(itemId: item['id']))
                    );
                  },
                  icon: Icon(isLocked ? Icons.lock : Icons.edit, size: 16),
                  label: Text(
                      isLocked ? ManageListingStrings.editingLockedShort : ManageListingStrings.editItemDetails,
                      style: AppTextStyles.bodyMedium(context)
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.black,
                    disabledForegroundColor: AppColors.grey400,
                    side: BorderSide(color: isLocked ? AppColors.greyLight : AppColors.greyMedium),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              // ✅ Delete Button positioned top-right of the card
              Positioned(
                top: 4,
                right: 4,
                child: IconButton(
                  onPressed: () => _handleDeleteListing(context, ref, item['id'].toString()),
                  icon: const Icon(Icons.delete_outline, color: AppColors.errorColor),
                  tooltip: ManageListingStrings.deleteListing,
                ),
              ),
            ],
          ),

          AppValues.gapL,

          Text(
            "${ManageListingStrings.offersTitle} (${offers.length})",
            style: AppTextStyles.bodyLarge(context, bold: true),
          ),

          AppValues.gapM,

          if (offers.isEmpty)
            _buildEmptyState(context)
          else
            BidList(
              offers: offers,
              isTrade: isTrade,
              isMix: isMix,
              isManageMode: true,
              isExpiredAuction: isExpired && type == ItemDetailsStrings.typeCash,
              onAccept: (offerId) => _handleAcceptOffer(context, ref, offerId),
              onReject: (offerId) => _handleRejectOffer(context, ref, offerId),
            ),

          AppValues.gapXXL,
          AppValues.gapXXL,
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            const Icon(Icons.inbox, size: 48, color: AppColors.greyMedium),
            AppValues.gapS,
            Text(ManageListingStrings.noOffers, style: AppTextStyles.bodyMedium(context, color: AppColors.textGrey)),
          ],
        ),
      ),
    );
  }

  Future<void> _handleDeleteListing(BuildContext context, WidgetRef ref, String itemId) async {
    // 1. Show Confirmation Dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title:  Text(ManageListingStrings.deleteListing,style: AppTextStyles.bodyLarge(context),),
        content: Text( ManageListingStrings.deleteConfirmationMessage, style: AppTextStyles.bodyLarge(context),),
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
      // 2. Perform Hard Delete in Supabase
      await Supabase.instance.client
          .from('items')
          .delete()
          .eq('id', itemId);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(ManageListingStrings.deleteSuccess)),
        );

        ref.invalidate(myListingsProvider);
        ref.invalidate(itemDetailsProvider(itemId));

        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${ManageListingStrings.deleteError}$e"), backgroundColor: Colors.red),
        );
      }
    }
  }
  // --- ✅ IMPLEMENTED ACTIONS ---

  Future<void> _handleAcceptOffer(BuildContext context, WidgetRef ref, String offerId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(ManageListingStrings.acceptOfferDialogTitle, style: AppTextStyles.titleSmall(context)),
        content: Text(ManageListingStrings.acceptOfferDialogContent, style: AppTextStyles.bodyMedium(context)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(ManageListingStrings.cancel, style: AppTextStyles.bodyMedium(context))),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(ManageListingStrings.confirm, style: AppTextStyles.bodyMedium(context))),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await Supabase.instance.client.rpc('accept_offer', params: {'p_offer_id': offerId});

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ManageListingStrings.offerAcceptedSnackbar, style: AppTextStyles.bodyMedium(context))));

        // ✅ FIX: Refresh BOTH screens
        ref.invalidate(itemDetailsProvider(itemId));
        ref.invalidate(myListingsProvider);
      }
    } catch (e) {

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("${ManageListingStrings.errorAcceptingOfferPrefix}$e", style: AppTextStyles.bodyMedium(context, color: AppColors.white)), backgroundColor: AppColors.errorColor)
        );
      }
    }
  }

  Future<void> _handleRejectOffer(BuildContext context, WidgetRef ref, String offerId) async {
    try {
      // 1. Reject specific offer (Standard Update)
      await Supabase.instance.client
          .from('offers')
          .update({'status': 'rejected'})
          .eq('id', offerId);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ManageListingStrings.offerRejectedSnackbar, style: AppTextStyles.bodyMedium(context))));
        // 2. Refresh Data
        ref.invalidate(itemDetailsProvider(itemId));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("${ManageListingStrings.errorRejectingOfferPrefix}$e", style: AppTextStyles.bodyMedium(context, color: AppColors.white)), backgroundColor: AppColors.errorColor)
        );
      }
    }
  }
}
