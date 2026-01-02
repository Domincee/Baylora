import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';

class ListingCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? price;
  final List<String> tags;
  final String offers;
  final String postedTime;
  final String status;
  final String? imageUrl;

  const ListingCard({
    super.key,
    required this.title,
    this.subtitle,
    this.price,
    this.tags = const [],
    required this.offers,
    required this.postedTime,
    required this.status,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor = status == 'Accepted' ? Colors.blue : (status == 'Sold' ? Colors.grey : Colors.lightBlueAccent.withValues(alpha:  0.2));
    Color statusTextColor = status == 'Accepted' ? Colors.white : (status == 'Sold' ? Colors.white : Colors.blue[800]!);

    return Container(
      padding: AppValues.paddingSmall,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppValues.borderRadiusL,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
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
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,

                  ),
                ),
                if (price != null) ...[
                   Text(
                     "Price: $price",
                     style: Theme.of(context).textTheme.bodySmall?.copyWith(
                       color: AppColors.subTextColor,
                       fontWeight: FontWeight.w600,
                     ),
                   ),
                ] else if (subtitle != null) ...[
                   Text(
                     "$subtitle",
                     style: Theme.of(context).textTheme.bodySmall?.copyWith(
                       color: AppColors.subTextColor,
                       fontWeight: FontWeight.w600,
                     ),
                   ),
                   if (tags.isNotEmpty) 
                     Wrap(
                       spacing: 4,
                       children: tags.map((t) => Container(
                         margin: const EdgeInsets.only(top: 4),
                         padding: const EdgeInsets.symmetric(
                           horizontal: 6,
                           vertical: 2,
                         ),
                         decoration: BoxDecoration(
                           color: AppColors.tealLight,
                           borderRadius: AppValues.borderRadiusS,
                         ),
                         child: Text(
                           t,
                           style: Theme.of(context).textTheme.labelSmall?.copyWith(
                             color: AppColors.tealText,
                             fontSize: 9,
                           ),
                         ),
                       )).toList(),
                     )
                ],
                AppValues.gapXS,
                Text(
                  offers,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  postedTime,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textGrey,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          // Actions
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppValues.spacingXS,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: AppValues.borderRadiusS,
                ),
                child: Text(
                  status,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: statusTextColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              AppValues.gapM,
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
                   "Manage",
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
