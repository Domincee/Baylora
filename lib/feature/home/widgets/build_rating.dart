import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';

class BuildRating extends StatelessWidget {
  const BuildRating({
    super.key,
    required this.rating,
    required this.totalTrade,
    required this.context,
  });

  final String rating;
  final String totalTrade;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final double ratingVal = double.tryParse(rating) ?? 0.0;
    final int tradeVal = int.tryParse(totalTrade) ?? 0;

    if (ratingVal <= 0 && tradeVal <= 0) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppValues.spacingXS,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.lavenderBlue,
        borderRadius: AppValues.borderRadiusS,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (ratingVal > 0) ...[
            const Icon(Icons.star, color: AppColors.yellowAcc, size: 22),
            AppValues.gapHXXS,
            Text(
              rating,
              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                color: AppColors.infoCardTClr,
                 fontWeight: FontWeight.w600,
              ),
            ),
          ],
          if (ratingVal > 0 && tradeVal > 0)
            Container(
              height: 12,
              width: 1,
              color: AppColors.subTextColor,
              margin: const EdgeInsets.symmetric(horizontal: 6),
            ),
          if (tradeVal > 0)
            Text(
              "$totalTrade trades",
              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                color: AppColors.infoCardTClr,
               fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }
}
