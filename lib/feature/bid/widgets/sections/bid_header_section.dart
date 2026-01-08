import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/details/constants/item_details_strings.dart';
import 'package:flutter/material.dart';

class BidHeaderSection extends StatelessWidget {
  final bool isCash;
  final bool isTrade;
  final bool isEditing;

  const BidHeaderSection({
    super.key,
    required this.isCash,
    required this.isTrade,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    String title = "";
    String? subtitle;

    if (isEditing) {
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
          ),
        ),
        if (subtitle != null && !isEditing) ...[
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