import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/profile/constant/profile_strings.dart';
import 'package:flutter/material.dart';

class BidCard extends StatelessWidget {
  final String title;
  final String myOffer;
  final String timer;
  final String postedTime;
  final String status;
  final String? extraStatus;
  final String? imageUrl;
  final VoidCallback? onTap;

  const BidCard({
    super.key,
    required this.title,
    required this.myOffer,
    required this.timer,
    required this.postedTime,
    required this.status,
    this.extraStatus,
    this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppValues.paddingSmall,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: AppValues.borderRadiusL,
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: AppValues.borderRadiusM,
              child: Container(
                width: 80,
                height: 80,
                color: AppColors.greyLight,
                child: imageUrl != null && imageUrl!.isNotEmpty
                    ? Image.network(
                        imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, stack) =>
                            const Icon(Icons.image_not_supported, color: AppColors.grey400),
                      )
                    : const Icon(Icons.image_not_supported, color: AppColors.grey400),
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppValues.gapXXS,
                  Text(
                    "My Offer: $myOffer",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.royalBlue,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  AppValues.gapXS,
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 12, color: AppColors.textGrey),
                      const SizedBox(width: 4),
                      Text(
                        timer,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.textGrey,
                            ),
                      ),
                      const Spacer(),
                      _buildStatusChip(context, status),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, String status) {
    Color bg = AppColors.blueLight;
    Color text = AppColors.blueText;
    String label = status;

    if (extraStatus != null && extraStatus!.toLowerCase() == 'accepted') {
      bg = AppColors.successColor.withValues(alpha: 0.1);
      text = AppColors.successColor;
      label = ProfileStrings.statusAccepted;
    } else if (status.toLowerCase() == 'sold') {
      bg = AppColors.grey200;
      text = AppColors.textGrey;
      label = ProfileStrings.statusSold;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: text,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
