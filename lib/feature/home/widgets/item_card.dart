import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/core/util/uni_image.dart';
import 'package:baylora_prjct/feature/home/widgets/build_price.dart';
import 'package:baylora_prjct/feature/home/widgets/profile_avatar.dart';
import 'package:baylora_prjct/feature/shared/widgets/user_rating_pill.dart';
import 'package:baylora_prjct/feature/shared/widgets/username_with_badge.dart';
import 'package:flutter/material.dart';


class ItemCard extends StatelessWidget {
  final String postedTime;
  /* user info */
  final String sellerName;
  final String sellerImage;
  final bool isVerified;
  final String totalTrade;
  final String rating;
  final bool isRated;
  /* item info */
  final String type;
  final String price;
  final String swapItem;
  final String title;
  final String description;
  final String imagePath;
  final String? timeRemaining;
  final VoidCallback? onTap;

  const ItemCard({
    super.key,
    required this.postedTime,
    required this.sellerName,
    required this.sellerImage,
    this.isRated = false,
    this.isVerified = false,
    this.rating = "0.0",
    this.totalTrade = "0.0",
    required this.type,
    this.price = "0.0",
    this.swapItem = "",
    required this.title,
    required this.description,
    required this.imagePath,
    this.timeRemaining,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // Color moved to Material widget below
        borderRadius: AppValues.borderRadiusM,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: AppValues.borderRadiusM,
        child: Material(
          color: AppColors.white,
          child: InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Info Section
                Padding(
                  padding: AppValues.paddingCard,
                  child: Row(
                    children: [
                      ProfileAvatar(
                        imageUrl: sellerImage,
                        size: 40,
                      ),
                      AppValues.gapHS,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            UsernameWithBadge(
                              username: sellerName,
                              isVerified: isVerified,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.black,
                              ),
                            ),
                            Text(
                              postedTime,
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: AppColors.textGrey,
                                fontWeight: FontWeight.w600
                              ),
                            ),
                          ],
                        ),
                      ),
                      UserRatingPill(rating: rating, totalTrades: totalTrade),
                    ],
                  ),
                ),

                // Item Details
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppValues.spacingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (timeRemaining != null) ...[
                            AppValues.gapHXXS,
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.errorColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.errorColor.withValues(alpha: 0.5)),
                              ),
                              child: Text(
                                timeRemaining!,
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: AppColors.errorColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      AppValues.gapXXS,
                      Text(
                        description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.subTextColor,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      AppValues.gapXS,
                      BuildPrice(
                        type: type,
                        price: price,
                        swapItem: swapItem,
                        context: context,
                      ),
                      type == 'mix' ? AppValues.gapXXS : SizedBox.shrink(),
                      type == 'mix'
                          ? Row(
                              children: [
                                Text(
                                  "Willing to swap for:",
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: AppColors.textGrey,
                                  ),
                                ),
                                AppValues.gapHXXS,
                                ...swapItem.split(',').take(2).map((item) => Container(
                                      margin: EdgeInsets.only(right: 4),
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.blueLight,
                                        borderRadius: AppValues.borderRadiusS,
                                      ),
                                      child: Text(
                                        item.trim(),
                                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                          color: AppColors.blueText,
                                          fontSize: 10,
                                        ),
                                      ),
                                    )),
                              ],
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),

                AppValues.gapS,

                // Item Image
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(AppValues.radiusM),
                    bottomRight: Radius.circular(AppValues.radiusM),
                  ),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: UniversalImage(
                      path: imagePath,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
