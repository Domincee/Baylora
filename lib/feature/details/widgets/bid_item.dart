import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/home/util/date_util.dart';
import 'package:baylora_prjct/feature/home/widgets/profile_avatar.dart';
import 'package:baylora_prjct/feature/shared/widgets/secret_offer_badge.dart';
import 'package:flutter/material.dart';

class BidItem extends StatelessWidget {
  final Map<String, dynamic> offer;
  final bool isTrade;
  final bool isMix;
  final bool isManageMode;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final bool isWinningBid;
  final bool isExpiredAuction;

  const BidItem({
    super.key,
    required this.offer,
    required this.isTrade,
    required this.isMix,
    this.isManageMode = false,
    this.onAccept,
    this.onReject,
    this.isWinningBid = false,
    this.isExpiredAuction = false,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Safe Data Extraction
    // Check if profiles is wrapped in a list (PostgREST join style)
    dynamic rawProfile = offer['profiles'];
    if (rawProfile is List) {
      rawProfile = rawProfile.isNotEmpty ? rawProfile.first : null;
    }
    
    // Ensure bidder is a map
    final bidder = (rawProfile is Map) 
        ? Map<String, dynamic>.from(rawProfile) 
        : <String, dynamic>{};

    final username = bidder['username']?.toString() ?? 'Unknown';
    final avatarUrl = bidder['avatar_url']?.toString() ?? '';
    
    // Safely parse cash_offer
    final rawCash = offer['cash_offer'];
    num cashOffer = 0;
    if (rawCash is num) {
      cashOffer = rawCash;
    } else if (rawCash is String) {
      cashOffer = num.tryParse(rawCash) ?? 0;
    }
    
    // Safely parse time
    final createdAt = offer['created_at']?.toString() ?? DateTime.now().toIso8601String();
    final timeAgo = DateUtil.getTimeAgo(createdAt);
    
    // Safely extract images
    final rawImages = offer['swap_item_images'];
    List<dynamic> swapImages = [];
    if (rawImages is List) {
      swapImages = rawImages;
    } else if (rawImages is String) {
       // Handle case where Postgres text[] might be returned as string if not properly configured in client
       // Though usually client handles it. Assuming List for now.
    }
    final tradeImageUrl = swapImages.isNotEmpty ? swapImages.first.toString() : null;
    
    final hasCash = cashOffer > 0;
    final swapText = offer['swap_item_text']?.toString();
    final hasTrade = tradeImageUrl != null || (swapText != null && swapText.isNotEmpty);

    final status = offer['status']?.toString() ?? 'pending';
    final isRejected = status == 'rejected';
    final isAccepted = status == 'accepted';

    return Opacity(
      opacity: isRejected ? 0.5 : 1.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            ProfileAvatar(imageUrl: avatarUrl, size: AppValues.spacingXL),
            AppValues.gapHS,
            
            // Middle Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and Time
                  Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                        Flexible(
                          child: Text(
                            "@$username",
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.black,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (!isManageMode || !isAccepted)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              timeAgo,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textGrey,
                                    fontSize: 10,
                                  ),
                            ),
                          ),
                     ],
                  ),
                  
                  AppValues.gapXS,
                  
                  // Offer Details
                  _buildOfferContent(context, hasCash, hasTrade, cashOffer, tradeImageUrl),

                   if (isRejected)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text("Rejected", style: TextStyle(color: AppColors.errorColor, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                   if (isAccepted)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text("Accepted", style: TextStyle(color: AppColors.successColor, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                ],
              ),
            ),
            
            // Actions (Only in Manage Mode)
            if (isManageMode && !isRejected && !isAccepted) ...[
               AppValues.gapS,
               _buildActions(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOfferContent(BuildContext context, bool hasCash, bool hasTrade, num cashOffer, String? tradeImageUrl) {
     if (isMix) {
        return Row(
          children: [
             if (hasCash)
                _buildCashText(context, cashOffer),
             if (hasCash && hasTrade)
                Text(" + ", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textGrey, fontWeight: FontWeight.bold)),
             if (hasTrade)
                _buildTradeContent(context, tradeImageUrl),
          ],
        );
     } else if (isTrade) {
        return _buildTradeContent(context, tradeImageUrl);
     } else {
        return _buildCashText(context, cashOffer);
     }
  }

  Widget _buildCashText(BuildContext context, num amount) {
     return Text(
        "₱ ${amount.toString()}",
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.royalBlue,
              fontSize: 15,
            ),
     );
  }

  Widget _buildTradeContent(BuildContext context, String? imageUrl) {
     if (isManageMode && imageUrl != null) {
       // Manage Mode: Show Thumbnail
       return ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.network(
            imageUrl,
            width: 40,
            height: 40,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => const Icon(
              Icons.broken_image,
              size: 40,
              color: AppColors.greyLight,
            ),
          ),
       );
     }
     // View Mode: Show Secret Badge
     return const SecretOfferBadge();
  }

  Widget _buildActions(BuildContext context) {
      if (isExpiredAuction) {
         if (isWinningBid) {
            return ElevatedButton(
               onPressed: () {
                 // Deal Chat Nav?
               }, 
               style: ElevatedButton.styleFrom(
                 visualDensity: VisualDensity.compact,
                 backgroundColor: AppColors.royalBlue,
                 foregroundColor: Colors.white,
                 padding: const EdgeInsets.symmetric(horizontal: 8),
               ),
               child: const Text("Winner", style: TextStyle(fontSize: 10)),
            );
         }
         return const SizedBox.shrink();
      }

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ActionButton(
            icon: Icons.close,
            color: AppColors.errorColor,
            onTap: onReject,
          ),
          const SizedBox(width: 8),
          _ActionButton(
            icon: Icons.check,
            color: AppColors.successColor,
            onTap: onAccept,
          ),
        ],
      );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _ActionButton({required this.icon, required this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: 0.1),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }
}
