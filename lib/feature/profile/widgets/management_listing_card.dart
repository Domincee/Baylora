import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/profile/constant/profile_strings.dart';
import 'package:flutter/material.dart';

class ManagementListingCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String status;
  final int offerCount;
  final DateTime postedDate;
  final double? price;
  final List<String> lookingFor;
  final bool isAuction;
  final double? currentHighestBid;
  final Map<String, dynamic>? soldToItem;
  final DateTime? endTime;

  const ManagementListingCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.status,
    required this.offerCount,
    required this.postedDate,
    this.price,
    this.lookingFor = const [],
    required this.isAuction,
    this.currentHighestBid,
    this.soldToItem,
    this.endTime,
  });

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case 'active':
        return AppColors.successColor;
      case 'sold':
        return AppColors.grey600;
      case 'accepted':
        return AppColors.blueText;
      case 'ended':
        return AppColors.errorColor;
      default:
        return AppColors.textGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if item has ended (only for active items)
    bool isEnded = false;
    if (endTime != null && status.toLowerCase() == 'active') {
       isEnded = DateTime.now().isAfter(endTime!);
    }
    
    // If ended and not sold/accepted, we can visually treat it as ended
    final effectiveStatus = (isEnded && status.toLowerCase() == 'active') ? 'Ended' : status;
    final isItemEnded = effectiveStatus == 'Ended';


    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppValues.borderRadiusM,
        border: isItemEnded ? Border.all(color: AppColors.errorColor.withValues(alpha: 0.5)) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: AppValues.paddingS,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: AppValues.borderRadiusS,
            child: Stack(
              children: [
                 Image.network(
                  imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 80,
                    height: 80,
                    color: AppColors.grey200,
                    child: const Icon(Icons.image_not_supported, color: AppColors.textGrey),
                  ),
                ),
                if(isItemEnded)
                  Container(
                    width: 80,
                    height: 80,
                    color: AppColors.overlay,
                    alignment: Alignment.center,
                    child: Text(
                      "ENDED",
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  )
              ],
            ),
          ),
          AppValues.gapM,

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isItemEnded)
                       Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.errorColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          "Ended",
                           style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.errorColor,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                       )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStatusColor().withValues(alpha: 0.1),
                          borderRadius: AppValues.borderRadiusS,
                        ),
                        child: Text(
                          status,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: _getStatusColor(),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                
                // Price or Trade
                if (price != null)
                  Text(
                    "P${price!.toStringAsFixed(2)}",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                
                if (lookingFor.isNotEmpty)
                   Text(
                    "${ProfileStrings.lookingFor}: ${lookingFor.take(2).join(', ')}",
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textGrey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                const SizedBox(height: 8),

                // Offers / Bids info
                Row(
                  children: [
                    Icon(Icons.local_offer_outlined, size: 14, color: AppColors.textGrey),
                    const SizedBox(width: 4),
                    Text(
                      "$offerCount ${ProfileStrings.offers}",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textGrey,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _formatDate(postedDate),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textGrey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) return "Today";
    if (diff.inDays == 1) return "Yesterday";
    return "${date.day}/${date.month}/${date.year}";
  }
}
