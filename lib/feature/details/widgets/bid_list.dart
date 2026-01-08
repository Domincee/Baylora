import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/details/constants/item_details_strings.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class BidList extends StatelessWidget {
  final List<dynamic> offers;
  final bool isTrade;
  final bool isMix;
  final bool isManageMode;
  final Function(String offerId)? onAccept;
  final Function(String offerId)? onReject;
  final bool isExpiredAuction;

  const BidList({
    super.key,
    required this.offers,
    this.isTrade = false,
    this.isMix = false,
    this.isManageMode = false,
    this.onAccept,
    this.onReject,
    this.isExpiredAuction = false,
  });

  @override
  Widget build(BuildContext context) {
    // --- 1. Empty State ---
    if (offers.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppValues.spacingL),
          child: Column(
            children: [
              const Icon(Icons.inbox_outlined, size: AppValues.iconXL, color: AppColors.grey300),
              AppValues.gapM,
              Text(
                ItemDetailsStrings.noOffers,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textGrey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // --- 2. List Builder ---
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      // Limit to 5 for public view, show all for manage mode
      itemCount: isManageMode ? offers.length : (offers.length > 5 ? 5 : offers.length),
      separatorBuilder: (context, index) => const SizedBox(height: AppValues.spacingM),
      itemBuilder: (context, index) {
        final offer = Map<String, dynamic>.from(offers[index]);

        // Sorting logic: Top bid is winner if auction expired
        final isWinner = index == 0 && isExpiredAuction;

        return _BidItem(
          offer: offer,
          isManageMode: isManageMode,
          isWinner: isWinner,
          isExpiredAuction: isExpiredAuction,
          onAccept: onAccept,
          onReject: onReject,
        );
      },
    );
  }
}

// ==========================================
// PRIVATE SUB-WIDGET: The Offer Card
// ==========================================

class _BidItem extends StatelessWidget {
  final Map<String, dynamic> offer;
  final bool isManageMode;
  final bool isWinner;
  final bool isExpiredAuction;
  final Function(String)? onAccept;
  final Function(String)? onReject;

  const _BidItem({
    required this.offer,
    required this.isManageMode,
    required this.isWinner,
    required this.isExpiredAuction,
    this.onAccept,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    // --- Data Parsing ---
    final profile = offer['profiles'] ?? {};
    final String username = profile['username'] ?? 'User';
    final String? avatarUrl = profile['avatar_url'];

    final double cashOffer = (offer['cash_offer'] ?? 0).toDouble();
    final List<dynamic> swapImages = offer['swap_item_images'] ?? [];
    final String? tradeImageUrl = swapImages.isNotEmpty
        ? swapImages.first
        : null;

    // Determine Type
    final bool hasCash = cashOffer > 0;
    final bool hasTrade = tradeImageUrl != null;

    // Status
    final String status = offer['status'] ?? 'pending';
    final bool isRejected = status == 'rejected';
    final bool isAccepted = status == 'accepted';

    // Dates
    final DateTime createdAt = DateTime.tryParse(offer['created_at'] ?? '') ??
        DateTime.now();

    // --- Opacity for Rejected Items ---
    return Opacity(
      opacity: isRejected ? 0.5 : 1.0,
      child: Container(
        padding: AppValues.paddingCard, // 16px
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: AppValues.borderRadiusL, // 16px radius
          border: Border.all(color: AppColors.greyLight),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor.withValues(alpha: 0.05),
              blurRadius: AppValues.radiusS,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ===========================
            // 1. LEFT: Avatar & Name
            // ===========================
            _buildUserInfo(username, avatarUrl),

            AppValues.gapHM, // 16px horizontal gap

            // ===========================
            // 2. MIDDLE: Offer Content
            // ===========================
            Expanded(
              child: _buildOfferContent(
                  context, hasCash, hasTrade, cashOffer, tradeImageUrl),
            ),

            AppValues.gapHM,

            // ===========================
            // 3. RIGHT: Actions & Time
            // ===========================
            _buildActionsAndTime(
                context, createdAt, status, isRejected, isAccepted,
                offer['id']),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(String username, String? avatarUrl) {
    // If NOT manage mode (Public), we might want to hide/blur name
    final displayName = isManageMode ? username : "${username[0]}***";

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(2), // border thickness
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.royalBlue, width: 2),
          ),
          child: CircleAvatar(
            radius: AppValues.iconS, // 16px radius = 32px diameter
            backgroundColor: AppColors.greyLight,
            backgroundImage: (avatarUrl != null && avatarUrl.isNotEmpty)
                ? NetworkImage(avatarUrl)
                : null,
            child: (avatarUrl == null || avatarUrl.isEmpty)
                ? const Icon(
              Icons.person,
              size: AppValues.iconS,
              color: AppColors.grey400,
            )
                : null,
          ),
        ),
        AppValues.gapXS,
        SizedBox(

        width: 60, // Limit width
          child: Text(
            displayName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: AppColors.textDarkGrey
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOfferContent(BuildContext context, bool hasCash, bool hasTrade,
      double cashAmount, String? tradeImageUrl) {
    // --- SCENARIO A: MIX (Trade + Cash) ---
    if (hasTrade && hasCash) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTradeImage(context, tradeImageUrl),
          AppValues.gapHS,
          Flexible(
            child: Text(
              "+ ₱${cashAmount.toStringAsFixed(0)}",
              style: const TextStyle(
                color: AppColors.royalBlue,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      );
    }

    if (hasTrade) {
      return Row(
        children: [
          _buildTradeImage(context, tradeImageUrl),
          AppValues.gapHS,
          const Text(
            "Trade",
            style: TextStyle(
                fontSize: 12,
                color: AppColors.textGrey,
                fontStyle: FontStyle.italic
            ),
          ),
        ],
      );
    }


    return Text(
      "₱${cashAmount.toStringAsFixed(0)}",
      style: const TextStyle(
        fontSize: 16, // Large
        fontWeight: FontWeight.w900, // Very Bold
        color: AppColors.royalBlue,
      ),
    );
  }

  Widget _buildTradeImage(BuildContext context, String? imageUrl) {


    if (imageUrl == null || imageUrl.isEmpty) return const SizedBox.shrink();


    if (!isManageMode) {
      return Container(
        height: 50, width: 50,
        decoration: BoxDecoration(
          color: AppColors.greyLight,
          borderRadius: BorderRadius.circular(AppValues.radiusS),
        ),
        child: const Icon(
            Icons.lock_outline, size: 20, color: AppColors.textGrey),
      );
    }

    return GestureDetector(
      onTap: () => _showFullscreenImage(context, imageUrl),
      child: Hero(
        tag: "bid_image_$imageUrl",
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppValues.radiusS),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
            border: Border.all(color: AppColors.greyLight),
          ),
        ),
      ),
    );
  }

  Widget _buildActionsAndTime(BuildContext context, DateTime date,
      String status, bool isRejected, bool isAccepted, String offerId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Time
        Text(
          timeago.format(date, locale: 'en_short'), // "5m", "now"
          style: const TextStyle(fontSize: 10, color: AppColors.textGrey),
        ),

        AppValues.gapS,

        // 2. Action Buttons (Only show if Manage Mode)
        if (isManageMode) ...[
          if (isAccepted)
            const Icon(
                Icons.check_circle, color: AppColors.successColor, size: 28)
          else
            if (isRejected)
              const Icon(Icons.cancel, color: AppColors.errorColor, size: 28)
            else
              if (isExpiredAuction && !isWinner)
                const Text("Lost",
                    style: TextStyle(fontSize: 12, color: AppColors.textGrey))
              else
                if (isExpiredAuction && isWinner)
                  const Text("Winner", style: TextStyle(fontSize: 12,
                      color: AppColors.successColor,
                      fontWeight: FontWeight.bold))
                else
                // ACTIVE STATE: Show Accept/Reject
                  Row(
                    children: [
                      // REJECT
                      InkWell(
                        onTap: () => onReject?.call(offerId),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(4), // small padding
                          decoration: BoxDecoration(
                            color: AppColors.errorColor.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close, size: 18,
                              color: AppColors.errorColor),
                        ),
                      ),

                      AppValues.gapHS,

                      // ACCEPT
                      InkWell(
                        onTap: () => onAccept?.call(offerId),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.successColor.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check, size: 18,
                              color: AppColors.successColor),
                        ),
                      ),
                    ],
                  )
        ] else
          ...[
            if (isWinner)
              const Text("Winning Bid", style: TextStyle(fontSize: 10,
                  color: AppColors.successColor,
                  fontWeight: FontWeight.bold))
            else
              const SizedBox(height: 24),
          ]
      ],
    );
  }

  void _showFullscreenImage(BuildContext context, String imageUrl) {
    Navigator.of(context).push(PageRouteBuilder(
      opaque: false,
      barrierDismissible: true,
      // FIX: Use specific names instead of _, __
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Scaffold(
          backgroundColor: Colors.black.withValues(alpha: 0.09),
          body: Stack(
            children: [
              Center(
                child: Hero(
                  tag: "bid_image_$imageUrl",
                  child: Image.network(imageUrl),
                ),
              ),
              Positioned(
                top: 40,
                right: 20,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        );
      },
    ));
  }
}