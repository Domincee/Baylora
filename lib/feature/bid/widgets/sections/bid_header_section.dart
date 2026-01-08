import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/details/constants/item_details_strings.dart';
import 'package:flutter/material.dart';

class BidHeaderSection extends StatelessWidget {
  final bool isCash;
  final bool isTrade;
  final bool isEditing;
  final String status; // Added status

  const BidHeaderSection({
    super.key,
    required this.isCash,
    required this.isTrade,
    required this.isEditing,
    this.status = '', // Default to empty
  });

  @override
  Widget build(BuildContext context) {
    String title = "";
    String? subtitle;
    Color? titleColor;

    if (status == 'accepted') {
      title = "Deal is Accepted";
      subtitle = "You can now chat with the seller.";
      titleColor = AppColors.successColor;
    } else if (status == 'rejected') {
      title = "Offer Rejected";
      subtitle = "The seller has declined this offer.";
      titleColor = AppColors.errorColor;
    } else if (isEditing) {
      title = ItemDetailsStrings.editBid;
    } else {
      if (isCash) {
        title = ItemDetailsStrings.placeYourBid;
      } else if (isTrade) {
        title = ItemDetailsStrings.placeATrade;
      } else {
        title = ItemDetailsStrings.placeYourOffer;
        subtitle = ItemDetailsStrings.offerCombine;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: titleColor, // Apply color if set
          ),
        ),
        if (subtitle != null) ...[ // Always show subtitle if set (even for editing if status changed)
          AppValues.gapXS,
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textGrey,
            ),
          ),
        ],
        AppValues.gapS,
      ],
    );
  }
}
