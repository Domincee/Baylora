import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/details/constants/item_details_strings.dart';
import 'package:baylora_prjct/feature/details/provider/item_details_provider.dart';
import 'package:baylora_prjct/feature/details/widgets/bid_list.dart';
import 'package:baylora_prjct/feature/post/screens/edit_listing_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../details/controller/item_details_controller.dart';

// Removed local manageListingProvider to ensure consistency with ItemDetailsScreen
// We now use itemDetailsProvider from the details feature.

class ManageListingScreen extends ConsumerWidget {
  final String itemId;

  const ManageListingScreen({super.key, required this.itemId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use the shared provider that is known to work in ItemDetailsScreen
    final itemAsync = ref.watch(itemDetailsProvider(itemId));

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text("Manage Listing", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.white,
        elevation: 0,
        foregroundColor: AppColors.black,
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

    return SingleChildScrollView(
      padding: AppValues.paddingAll,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildItemHeader(
            context,
            item,
            isExpired,
            status,
            isTrade,
            isMix,
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
              onAccept: (offerId) =>
                  _handleAcceptOffer(context, ref, offerId),
              onReject: (offerId) =>
                  _handleRejectOffer(context, ref, offerId),
            ),

          AppValues.gapXXL,
        ],
      ),
    );
  }
  Widget _buildItemHeader(BuildContext context, Map<String, dynamic> item, bool isExpired, String status, bool isTrade, bool isMix) {
    final images = item['images'] as List<dynamic>? ?? [];
    final imageUrl = images.isNotEmpty ? images.first : '';
    final swapPreference = item['swap_preference']?.toString() ?? '';
    
    // Parse swap items: split by comma if needed
    List<String> swapItems = [];
    if (swapPreference.isNotEmpty) {
      swapItems = swapPreference.split(',').map((e) => e.trim()).toList();
    }

    return Container(
      padding: AppValues.paddingS,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppValues.borderRadiusL,
        border: Border.all(color: AppColors.greyLight),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 8,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // 1. Item Image
              ClipRRect(
                borderRadius: AppValues.borderRadiusM,
                child: Container(
                  width: 80,
                  height: 80,
                  color: AppColors.greyLight,
                  child: imageUrl.isNotEmpty
                      ? Image.network(imageUrl, fit: BoxFit.cover)
                      : const Icon(Icons.image, color: AppColors.grey400),
                ),
              ),
              AppValues.gapHS,

              // 2. Title & Price / Swap Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'] ?? 'No Title',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    AppValues.gapXS,
                    
                    // --- DISPLAY LOGIC ---
                    if (isMix) ...[
                      // Mix: Show Price
                      Text(
                        "Price: ₱${item['price'] ?? 0}",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.royalBlue, fontSize: 14),
                      ),
                      const SizedBox(height: 2),
                      // And "Trade for:"
                      if (swapItems.isNotEmpty)
                         Row(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                              const Text("Trade for: ", style: TextStyle(fontSize: 12, color: AppColors.textGrey)),
                              Expanded(
                                child: Text(
                                  swapItems.take(2).join(", "),
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                           ],
                         ),
                    ] else if (isTrade) ...[
                       // Trade Only
                       if (swapItems.isNotEmpty)
                         Row(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                              const Text("Trade for: ", style: TextStyle(fontSize: 12, color: AppColors.textGrey)),
                              Expanded(
                                child: Text(
                                  swapItems.take(2).join(", "),
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                           ],
                         )
                       else
                         const Text(
                          "Trade Only",
                          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.royalBlue, fontSize: 14),
                        ),
                    ] else ...[
                       // Cash Only
                       Text(
                        "Price: ₱${item['price'] ?? 0}",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.royalBlue, fontSize: 16),
                      ),
                    ],

                    AppValues.gapS,
                    // Status Badge in Row with Condition
                    Row(
                      children: [
                        _buildStatusBadge(status, isExpired),
                        const SizedBox(width: 8),
                        _buildConditionBadge(item['condition'] ?? 'Used'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          AppValues.gapM,

          // 3. Edit Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditListingScreen(itemId: item['id']),
                  ),
                );
              },
              icon: const Icon(Icons.edit, size: 16),
              label: const Text("Edit Item Details"),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.black,
                side: const BorderSide(color: AppColors.greyMedium),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildConditionBadge(String condition) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.greyLight,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        condition,
        style: const TextStyle(color: AppColors.textDarkGrey, fontWeight: FontWeight.bold, fontSize: 10),
      ),
    );
  }

  Widget _buildStatusBadge(String status, bool isExpired) {
    String label = "Active";
    Color color = AppColors.successColor;

    if (status == 'sold' || status == 'accepted') {
      label = "Completed";
      color = AppColors.royalBlue;
    } else if (isExpired) {
      label = "Time Ended";
      color = AppColors.errorColor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 10),
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

  // --- ACTIONS ---

  Future<void> _handleAcceptOffer(BuildContext context, WidgetRef ref, String offerId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Accept Offer?"),
        content: const Text("This will automatically reject all other offers. This action cannot be undone."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancel")),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Confirm")),
        ],
      ),
    );

    if (confirm != true) return;

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Offer Accepted!")));
    ref.invalidate(itemDetailsProvider(itemId)); // Updated to invalidate the correct provider
  }

  Future<void> _handleRejectOffer(BuildContext context, WidgetRef ref, String offerId) async {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Offer Rejected")));
    ref.invalidate(itemDetailsProvider(itemId)); // Updated to invalidate the correct provider
  }
}
