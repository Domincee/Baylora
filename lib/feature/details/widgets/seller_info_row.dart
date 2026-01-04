import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/home/util/date_util.dart';
import 'package:baylora_prjct/feature/home/widgets/profile_avatar.dart';

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
    final rating = (seller['rating'] ?? 0.0).toString();
    final trades = (seller['total_trades'] ?? 0).toString();

    return Row(
      children: [
        ProfileAvatar(imageUrl: avatarUrl, size: 48),
        AppValues.gapHM,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "@$username",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (isVerified) ...[
                    AppValues.gapHXXS,
                    const Icon(Icons.verified, size: 16, color: AppColors.blueText),
                  ],
                ],
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
        // Rating Pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.greyLight,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const Icon(Icons.star_rounded, color: AppColors.starColor, size: 18),
              const SizedBox(width: 4),
              Text(
                "$rating · $trades trades",
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
