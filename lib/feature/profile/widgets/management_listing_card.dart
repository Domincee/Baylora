import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/home/util/date_util.dart';
import 'package:baylora_prjct/feature/profile/constant/app_listing_colors.dart';
import 'package:baylora_prjct/feature/profile/constant/profile_strings.dart';
import 'package:flutter/material.dart';

class ManagementListingCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String status; // 'Active', 'Ended', 'Sold', 'Accepted'
  final int offerCount;
  final DateTime postedDate;
  final double? price;
  final List<String>? lookingFor;
  final String? currentHighestBid;
  final String? soldToItem;
  final bool isAuction;
  final DateTime? endTime; // Added for duration calculation

  const ManagementListingCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.status,
    required this.offerCount,
    required this.postedDate,
    this.price,
    this.lookingFor,
    this.currentHighestBid,
    this.soldToItem,
    this.isAuction = false,
    this.endTime,
  });

  Color _getStatusBgColor() {
    switch (status) {
      case 'Accepted':
        return AppListingColors.statusAccepted; // Cyan/Light Blue
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
        return AppColors.white;
      case 'Active':
      default:
        return AppListingColors.tagText;
    }
  }

  String _getActionButtonLabel() {
    if (status == 'Accepted') return ProfileStrings.dealChat;
    if (status == 'Sold') return ProfileStrings.leaveReview;
    return ProfileStrings.manageItem;
  }

  Color _getActionButtonBgColor() {
    if (status == 'Accepted') return AppListingColors.statusAccepted;
    if (status == 'Sold') return const Color(0xFFFFEBEE); // Light Pink
    return AppColors.grey200;
  }

  Color _getActionButtonTextColor() {
    if (status == 'Accepted') return AppColors.white;
    if (status == 'Sold') return const Color(0xFF2E7D32); // Green
    return AppColors.textDarkGrey;
  }

  @override
  Widget build(BuildContext context) {
    // Calculate time ago using DateUtil
    final timeAgo = DateUtil.getTimeAgo(postedDate.toIso8601String());
    final hasNoOffers = offerCount == 0;
    
    // Use Shared Logic for Time Remaining
    final timeRemaining = DateUtil.getRemainingTime(endTime, short: true);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
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

                // Type Indicator (Cash/Auction or Trade)
                if (price != null) ...[
                  Text(
                    isAuction ? ProfileStrings.startingBid : ProfileStrings.buyPrice,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.subTextColor,
                        ),
                  ),
                  Text(
                    "P${price!.toStringAsFixed(0)}", 
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.blueText, // Should verify this is right blue
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ] else if (lookingFor != null && lookingFor!.isNotEmpty) ...[
                  Text(
                    ProfileStrings.lookingFor,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.subTextColor,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppListingColors.tagBg,
                          borderRadius: BorderRadius.circular(8), 
                        ),
                        child: Text(
                          lookingFor!.length > 1
                              ? "${lookingFor!.first} & ${lookingFor!.length - 1} ${ProfileStrings.others}"
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
                  ),
                ],

                const SizedBox(height: 8),

                // Stats Row
                if (hasNoOffers)
                  Text(
                    isAuction ? ProfileStrings.noBidsYet : ProfileStrings.noOffersYet,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.subTextColor,
                          fontSize: 12,
                        ),
                  )
                else
                  Text(
                    "$offerCount ${ProfileStrings.offers}",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.subTextColor,
                          fontSize: 12,
                        ),
                  ),
                Text(
                  "${ProfileStrings.posted} $timeAgo",
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
              // Status Badge Row with Duration
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (timeRemaining != null && status == 'Active') ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.errorColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.errorColor.withOpacity(0.5)),
                      ),
                      child: Text(
                        timeRemaining,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.errorColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
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
                ],
              ),
              const SizedBox(height: 8),

              // Extra Info for Accepted/Sold
              if (status == 'Accepted' && currentHighestBid != null) ...[
                Text(
                  ProfileStrings.currentHighest,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.subTextColor,
                    fontSize: 10,
                  ),
                ),
                Text(
                  currentHighestBid!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textDarkGrey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
              ] else if (status == 'Sold' && soldToItem != null) ...[
                Text(
                  ProfileStrings.add,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.subTextColor,
                    fontSize: 10,
                  ),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 80),
                  child: Text(
                    soldToItem!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppListingColors.statusAccepted, // Cyan/Light Blue
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.end,
                  ),
                ),
                const SizedBox(height: 8),
              ] else ...[
                 const SizedBox(height: 20), // Spacer for active items to align button bottom
              ],

              // Action Button
              SizedBox(
                height: 32,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getActionButtonBgColor(),
                    foregroundColor: _getActionButtonTextColor(),
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
