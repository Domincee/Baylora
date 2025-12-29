import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';

class BidCard extends StatelessWidget {
  final String title;
  final String myOffer;
  final String timer;
  final String postedTime;
  final String status;
  final String? extraStatus;
  final String? imageUrl;

  const BidCard({
    super.key,
    required this.title,
    required this.myOffer,
    required this.timer,
    required this.postedTime,
    required this.status,
    this.extraStatus,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppValues.paddingSmall,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppValues.borderRadiusL,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.greyLight,
              borderRadius: BorderRadius.circular(12),
              image: imageUrl != null ? DecorationImage(image: NetworkImage(imageUrl!), fit: BoxFit.cover) : null,
            ),
          ),
          AppValues.gapHS,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                RichText(text: TextSpan(
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textGrey,
                    fontSize: 10,
                  ),
                  children: [
                    const TextSpan(text: "You offered\n"),
                    TextSpan(
                      text: myOffer,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.blueText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ]
                )),
                if (extraStatus != null)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: extraStatus == "Winning" ? Colors.deepPurpleAccent : Colors.grey[200],
                      borderRadius: BorderRadius.circular(4)
                    ),
                    child: Text(
                      extraStatus!,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontSize: 9,
                        color: extraStatus == "Winning" ? AppColors.white : AppColors.textGrey,
                      ),
                    ),
                  ),
                AppValues.gapXXS,
                Text(
                  timer,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontSize: 10,
                    color: AppColors.errorColor,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppValues.spacingXS,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.blueLight,
                  borderRadius: AppValues.borderRadiusS,
                ),
                child: Text(
                  status,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.blueDark,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              AppValues.gapL,
              Container(
                 padding: const EdgeInsets.symmetric(
                   horizontal: 10,
                   vertical: 6,
                 ),
                 decoration: BoxDecoration(
                   color: AppColors.greyLight,
                   borderRadius: AppValues.borderRadiusM,
                 ),
                 child: Text(
                   "View Item",
                   style: Theme.of(context).textTheme.labelSmall?.copyWith(
                     fontSize: 10,
                     fontWeight: FontWeight.bold,
                   ),
                 ),
              )
            ],
          )
        ],
      ),
    );
  }
}
