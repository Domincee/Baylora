import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/home/util/date_util.dart';
import 'package:baylora_prjct/feature/profile/constant/app_listing_colors.dart';
import 'package:flutter/material.dart';

class ManagementListingCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String status; // 'Active', 'Ended', 'Sold', 'Accepted'
  final int offerCount;
  final DateTime postedDate;
  final double? price;
  final List<String>? lookingFor;

  const ManagementListingCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.status,
    required this.offerCount,
    required this.postedDate,
    this.price,
    this.lookingFor,
  });

  Color _getStatusBgColor() {
    switch (status) {
      case 'Accepted':
        return AppListingColors.statusAccepted;
      case 'Ended':
        return AppListingColors.statusEnded;
      case 'Sold':
        return AppColors.grey400;
      case 'Active':
      default:
        return AppListingColors.statusActiveBg;
    }
  }

  Color _getStatusTextColor() {
    switch (status) {
      case 'Accepted':
      case 'Ended':
      case 'Sold':
        return Colors.white;
      case 'Active':
      default:
        return AppColors.textDarkGrey;
    }
  }

  String _getActionButtonLabel() {
    if (status == 'Accepted') return "Deal Chat";
    return "Manage";
  }

  @override
  Widget build(BuildContext context) {
    final timeAgo = DateUtil.getTimeAgo(postedDate.toIso8601String());

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              width: 88,
              height: 88,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 88,
                  height: 88,
                  color: AppColors.greyLight,
                  child: const Icon(Icons.image_not_supported, color: AppColors.grey400),
                );
              },
            ),
          ),
          const SizedBox(width: 12),

          // Middle: Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

                // Type Indicator (Cash or Trade)
                if (price != null) ...[
                  Text(
                    "Buy Price",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.subTextColor,
                        ),
                  ),
                  Text(
                    "P${price!.toStringAsFixed(0)}", 
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.blueText,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ] else if (lookingFor != null && lookingFor!.isNotEmpty) ...[
                  Text(
                    "Looking for",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.subTextColor,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppListingColors.tagBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      lookingFor!.length > 1
                          ? "${lookingFor!.first} & ${lookingFor!.length - 1} others"
                          : lookingFor!.first,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppListingColors.tagText,
                            fontWeight: FontWeight.w600,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],

                const SizedBox(height: 8),

                // Stats Row
                Text(
                  "$offerCount Offers",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.subTextColor,
                        fontSize: 12,
                      ),
                ),
                Text(
                  "Posted $timeAgo",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.subTextColor,
                        fontSize: 12,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Right: Status & Action
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusBgColor(),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: _getStatusTextColor(),
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              const SizedBox(height: 12),

              // Action Button
              SizedBox(
                height: 32,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: status == 'Accepted'
                        ? AppListingColors.statusAccepted
                        : AppColors.grey200,
                    foregroundColor: status == 'Accepted'
                        ? Colors.white
                        : AppColors.textDarkGrey,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    _getActionButtonLabel(),
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
