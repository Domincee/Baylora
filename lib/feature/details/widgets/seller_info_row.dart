import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/home/util/date_util.dart';
import 'package:baylora_prjct/feature/home/widgets/profile_avatar.dart';
import 'package:baylora_prjct/feature/shared/widgets/username_with_badge.dart'; // Import Shared Widget

class SellerInfoRow extends StatelessWidget {
  final Map<String, dynamic> seller;
  final String createdAtStr;

  const SellerInfoRow({
    super.key,
    required this.seller,
    required this.createdAtStr,
  });

  @override
  Widget build(BuildContext context) {
    final username = seller['username'] ?? 'Unknown';
    final avatarUrl = seller['avatar_url'] ?? '';
    final isVerified = seller['is_verified'] ?? false;
    
    final num rating = seller['rating'] ?? 0;
    final num trades = seller['total_trades'] ?? 0;
    final bool hasRating = rating > 0;
    final bool hasTrades = trades > 0;

    return Row(
      children: [
        ProfileAvatar(imageUrl: avatarUrl, size: 48),
        AppValues.gapHM,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // REPLACED: Custom Row -> Shared UsernameWithBadge
              UsernameWithBadge(
                username: username,
                isVerified: isVerified,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                DateUtil.getTimeAgo(createdAtStr),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textGrey,
                    ),
              ),
            ],
          ),
        ),
        
        // Rating Pill - Only show if rating > 0 or trades > 0
        if (hasRating || hasTrades)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.greyLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                if (hasRating) ...[
                  const Icon(Icons.star_rounded, color: AppColors.starColor, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    "$rating",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDarkGrey,
                        ),
                  ),
                ],
                
                if (hasRating && hasTrades)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      "·",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDarkGrey,
                          ),
                    ),
                  ),

                if (hasTrades)
                  Text(
                    "$trades trades",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDarkGrey,
                        ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
