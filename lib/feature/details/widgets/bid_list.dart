import 'package:baylora_prjct/feature/details/constants/item_details_strings.dart';
import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/home/util/date_util.dart';
import 'package:baylora_prjct/feature/home/widgets/profile_avatar.dart';
import 'package:baylora_prjct/feature/shared/widgets/secret_offer_badge.dart';

class BidList extends StatelessWidget {
  final List<dynamic> offers;
  final bool isTrade;
  final bool isMix;

  const BidList({
    super.key,
    required this.offers,
    this.isTrade = false,
    this.isMix = false,
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
      itemCount: offers.length > 5 ? 5 : offers.length, // Show max 5 recent bids
      separatorBuilder: (context, index) => const Divider(height: AppValues.spacingM),
      itemBuilder: (context, index) {
        final offer = offers[index];
        final bidder = offer['profiles'] ?? {};
        final cashOffer = (offer['cash_offer'] ?? 0) as num;
        final timeAgo = DateUtil.getTimeAgo(offer['created_at']);
        final swapItemText = offer['swap_item_text'];
        
        final hasCash = cashOffer > 0;
        final hasTrade = swapItemText != null && swapItemText.toString().isNotEmpty;

        return Row(
          children: [
            ProfileAvatar(imageUrl: bidder['avatar_url'] ?? '', size: AppValues.spacingXL),
            AppValues.gapHS,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "@${bidder['username'] ?? 'Unknown'}",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    timeAgo,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textGrey,
                          fontSize: 12,
                        ),
                  ),
                ],
              ),
            ),
            
            // Mix/Hybrid Logic
            if (isMix) ...[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (hasCash)
                    Text(
                      "₱ ${cashOffer.toString()}",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  
                  if (hasCash && hasTrade)
                    Text(
                      " + ",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textGrey,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    
                  if (hasTrade)
                    const SecretOfferBadge(),
                ],
              ),
            ] else if (isTrade) ...[
              const SecretOfferBadge(),
            ] else ...[
              // Cash Only
              Text(
                "₱ ${cashOffer.toString()}",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ],
        );
      },
    );
  }
}
