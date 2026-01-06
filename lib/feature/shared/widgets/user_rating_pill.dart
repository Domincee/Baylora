import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';

import 'constant/shared_widgets_strings.dart';

class UserRatingPill extends StatelessWidget {
  final String rating;
  final String totalTrades;

  const UserRatingPill({
    super.key,
    required this.rating,
    required this.totalTrades,
  });

  @override
  Widget build(BuildContext context) {
    final double ratingVal = double.tryParse(rating) ?? 0.0;
    final int tradeVal = int.tryParse(totalTrades) ?? 0;

    if (ratingVal <= 0 && tradeVal <= 0) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppValues.spacingXS,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppColors.gradientGreyStart,
            AppColors.gradientGreyEnd,
          ],
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (ratingVal > 0) ...[
            const Icon(Icons.star, color: AppColors.yellowAcc, size: 22),
            AppValues.gapHXXS,
            Text(
              rating,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          if (ratingVal > 0 && tradeVal > 0)
            Container(
              height: 12,
              width: 1,
              color: AppColors.white,
              margin: const EdgeInsets.symmetric(horizontal: 6),
            ),
          if (tradeVal > 0)
            Text(
              "$totalTrades ${SharedWidgetString.trades}",
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }
}
