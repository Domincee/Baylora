import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/core/widgets/listing_summary_card.dart';
import 'package:baylora_prjct/feature/chat/deal_chat_screen.dart';
import 'package:baylora_prjct/feature/details/constants/item_details_strings.dart';
import 'package:baylora_prjct/feature/details/provider/item_details_provider.dart';
import 'package:baylora_prjct/feature/details/widgets/bid_list.dart';
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
        title:  Text("Manage Listing", style: Theme.of(context).textTheme.titleSmall),
        backgroundColor: AppColors.white,
        elevation: 0,
        foregroundColor: AppColors.black,
        centerTitle: true,
      ),
      floatingActionButton: itemAsync.when(
        data: (item) => _buildFab(context, item),
        loading: () => null,
        error: (_, __) => null,
      ),
      body: itemAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Error: $err")),
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
        final username = profile != null ? profile['username'] : 'Buyer';
        
        return FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DealChatScreen(
                  chatTitle: username,
                  itemName: item['title'] ?? 'Item',
                  contextId: acceptedOffer['id'],
                ),
              ),
            );
          },
          label: const Text("Open Deal Chat", style: TextStyle(color: AppColors.highLightTextColor),),
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

    // ✅ Shared offer extraction
    final rawOffers = item[ItemDetailsStrings.fieldOffers] ?? [];
    final offers = ItemDetailsController.sortOffers(rawOffers);
    
    // Determine if editing should be locked
    final bool isLocked = status == 'accepted' || status == 'sold';

    return SingleChildScrollView(
      padding: AppValues.paddingAll,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListingSummaryCard(
            item: item,
            bottomAction: OutlinedButton.icon(
              onPressed: isLocked
                  ? null
                  : () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => EditListingScreen(itemId: item['id'])));
              },
              icon: Icon(isLocked ? Icons.lock : Icons.edit, size: 16),
              label: Text(isLocked ? "Editing Locked (Deal Pending)" : "Edit Item Details"),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.black,
                disabledForegroundColor: AppColors.grey400,
                side: BorderSide(color: isLocked ? AppColors.greyLight : AppColors.greyMedium),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),

          AppValues.gapL,

          Text(
            "Offers (${offers.length})",
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),

          AppValues.gapM,

          if (offers.isEmpty)
            _buildEmptyState()
          else
            BidList(
              offers: offers,
              isTrade: isTrade,
              isMix: isMix,
              isManageMode: true,
              isExpiredAuction: isExpired && type == ItemDetailsStrings.typeCash,
              // ✅ Pass the updated handlers
              onAccept: (offerId) => _handleAcceptOffer(context, ref, offerId),
              onReject: (offerId) => _handleRejectOffer(context, ref, offerId),
            ),

          AppValues.gapXXL,
          // Add extra padding at the bottom for FAB
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Icon(Icons.inbox, size: 48, color: AppColors.greyMedium),
            AppValues.gapS,
            Text("No offers yet", style: TextStyle(color: AppColors.textGrey)),
          ],
        ),
      ),
    );
  }

  // --- ✅ IMPLEMENTED ACTIONS ---

  Future<void> _handleAcceptOffer(BuildContext context, WidgetRef ref, String offerId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Accept Offer?"),
        content: const Text("This will mark your item as sold and reject all other offers. This cannot be undone."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancel")),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Confirm")),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await Supabase.instance.client.rpc('accept_offer', params: {'p_offer_id': offerId});

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Offer accepted!")));

        // ✅ FIX: Refresh BOTH screens
        ref.invalidate(itemDetailsProvider(itemId));
        ref.invalidate(myListingsProvider);
      }
    } catch (e) {

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error accepting offer: $e"), backgroundColor: AppColors.errorColor)
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
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Offer Rejected")));
        // 2. Refresh Data
        ref.invalidate(itemDetailsProvider(itemId));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error rejecting offer: $e"), backgroundColor: AppColors.errorColor)
        );
      }
    }
  }
}
