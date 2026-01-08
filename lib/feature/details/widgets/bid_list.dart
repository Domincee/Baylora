import 'package:baylora_prjct/feature/details/constants/item_details_strings.dart';
import 'package:baylora_prjct/feature/details/widgets/bid_item.dart';
import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';

class BidList extends StatelessWidget {
  final List<dynamic> offers;
  final bool isTrade;
  final bool isMix;
  final bool isManageMode; // Add this
  final Function(String offerId)? onAccept;
  final Function(String offerId)? onReject;
  final bool isExpiredAuction;

  const BidList({
    super.key,
    required this.offers,
    this.isTrade = false,
    this.isMix = false,
    this.isManageMode = false,
    this.onAccept,
    this.onReject,
    this.isExpiredAuction = false,
  });

  @override
  Widget build(BuildContext context) {
    if (offers.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppValues.spacingL),
          child: Column(
            children: [
              Icon(Icons.local_offer_outlined, size: AppValues.spacingXXL, color: AppColors.grey300),
              AppValues.gapXS,
              Text(
                ItemDetailsStrings.noOffers,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textGrey,
                      fontStyle: FontStyle.italic,
                    ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      // Show all offers if managing, otherwise limit to 5
      itemCount: isManageMode ? offers.length : (offers.length > 5 ? 5 : offers.length),
      separatorBuilder: (context, index) => const Divider(height: AppValues.spacingM),
      itemBuilder: (context, index) {
        final offer = offers[index];
        // Cast to Map to ensure safety if it came from explicit list
        final offerMap = Map<String, dynamic>.from(offer);

        return BidItem(
           offer: offerMap,
           isTrade: isTrade,
           isMix: isMix,
           isManageMode: isManageMode,
           isWinningBid: index == 0 && isExpiredAuction, // Assuming sorted list
           isExpiredAuction: isExpiredAuction,
           onAccept: onAccept != null ? () => onAccept!(offer['id']) : null,
           onReject: onReject != null ? () => onReject!(offer['id']) : null,
        );
      },
    );
  }
}
