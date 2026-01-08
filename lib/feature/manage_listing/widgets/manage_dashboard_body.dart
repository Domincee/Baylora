import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constant/app_values.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_style.dart';
import '../../../core/widgets/listing_summary_card.dart';
import '../../details/constants/item_details_strings.dart';
import '../../details/controller/item_details_controller.dart';
import '../../details/widgets/bid_list.dart';
import '../../post/screens/edit_listing_screen.dart';
import '../constant/manage_listing_strings.dart';
import '../mixins/manage_listing_action.dart';

class ManageDashboardBody extends StatelessWidget with ManageListingActions {
  final Map<String, dynamic> item;
  final WidgetRef ref;

  const ManageDashboardBody({super.key, required this.item, required this.ref});

  @override
  Widget build(BuildContext context) {
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
          Stack(
            children: [
              ListingSummaryCard(
                item: item,
                bottomAction: OutlinedButton.icon(
                  onPressed: isLocked ? null : () => Navigator.push(context, MaterialPageRoute(builder: (_) => EditListingScreen(itemId: item['id']))),
                  icon: Icon(isLocked ? Icons.lock : Icons.edit, size: 16),
                  label: Text(isLocked ? ManageListingStrings.editingLockedShort : ManageListingStrings.editItemDetails, style: AppTextStyles.bodyMedium(context)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.black,
                    disabledForegroundColor: AppColors.grey400,
                    side: BorderSide(color: isLocked ? AppColors.greyLight : AppColors.greyMedium),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              Positioned(
                top: 4, right: 4,
                child: IconButton(
                  onPressed: () => handleDeleteListing(context, ref, item['id'].toString()),
                  icon: const Icon(Icons.delete_outline, color: AppColors.errorColor),
                ),
              ),
            ],
          ),
          AppValues.gapL,
          Text("${ManageListingStrings.offersTitle} (${offers.length})", style: AppTextStyles.bodyLarge(context, bold: true)),
          AppValues.gapM,
          offers.isEmpty
              ? _buildEmptyState(context)
              : BidList(
            offers: offers,
            isTrade: isTrade,
            isMix: isMix,
            isManageMode: true,
            isExpiredAuction: isExpired && type == ItemDetailsStrings.typeCash,
            onAccept: (offerId) => handleAcceptOffer(context, ref, item['id'].toString(), offerId),
            onReject: (offerId) => handleRejectOffer(context, ref, item['id'].toString(), offerId),
          ),
          const SizedBox(height: 100),
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
}