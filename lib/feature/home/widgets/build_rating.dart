import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:flutter/material.dart';


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
    // Parse strings to numbers safely
    final double ratingVal = double.tryParse(rating) ?? 0.0;
    final int tradeVal = int.tryParse(totalTrade) ?? 0;

    // No rating AND No trades, hide everything.
    if (ratingVal <= 0 && tradeVal <= 0) {
      return const SizedBox.shrink(); 
    }

    // 2. Show only if there is data
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.infoCardBg,
        borderRadius: BorderRadius.circular(8), 
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [

          // Rating Star + Number Only if rating > 0
          if (ratingVal > 0) ...[
             Icon(Icons.star , color: Color(0xffFBFFB3),  ),
            const SizedBox(width: 4),
            Text(
              rating,
              style:
              Theme.of(context).textTheme.labelMedium!.copyWith(
                color: AppColors.infoCardTClr,
              ), 
            ),
          ],

          // Divider Only if both exist
          if (ratingVal > 0 && tradeVal > 0)
            Container(
              height: 12,
              width: 1,
              color: AppColors.subTextColor,
              margin: const EdgeInsets.symmetric(horizontal: 6),
            ),

          // Total Trades Only if trades > 0
          if (tradeVal > 0)
            Text(
             "$totalTrade trades",
                style:
              Theme.of(context).textTheme.labelMedium!.copyWith(
                color: AppColors.infoCardTClr,
              ), 
            ),
        ],
      ),
    );
  }
}
