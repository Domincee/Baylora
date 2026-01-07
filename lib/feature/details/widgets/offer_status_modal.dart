import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/details/constants/item_details_strings.dart';
import 'package:flutter/material.dart';

class OfferStatusModal extends StatelessWidget {
  final Map<String, dynamic> listingItem;
  final Map<String, dynamic> myOffer;

  const OfferStatusModal({
    super.key,
    required this.listingItem,
    required this.myOffer,
  });

  @override
  Widget build(BuildContext context) {
    final status = myOffer['status'] ?? 'pending'; // pending, accepted, rejected

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: const EdgeInsets.fromLTRB(
        AppValues.spacingL, // Left (double)
        AppValues.spacingS, // Top (double)
        AppValues.spacingL, // Right (double)
        AppValues.spacingL, // Bottom (double)
      ),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppValues.radiusXL)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Drag Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(bottom: AppValues.spacingL),
              width: AppValues.spacingXXL,
              height: AppValues.spacingXXS,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(AppValues.radiusXXS),
              ),
            ),
          ),

          // Wrap the scrollable content in Expanded + SingleChildScrollView
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. Dynamic Header
                  _buildHeader(context, status),
                  AppValues.gapL,

                  // 3. Comparison Card (Your Item vs Seller Item)
                  _buildComparisonCard(context),
                  AppValues.gapXL,

                  // 4. Timeline / Next Steps
                  const Text(ItemDetailsStrings.whatHappensNext, style: TextStyle(fontWeight: FontWeight.bold)),
                  AppValues.gapM,
                  _buildTimelineStep(
                    context,
                    icon: Icons.check_circle,
                    color: AppColors.royalBlue.withValues(alpha:  0.3),
                    iconColor: AppColors.royalBlue,
                    title: ItemDetailsStrings.offerSent,
                    subtitle: ItemDetailsStrings.offerSentSubtitle,
                  ),
                  _buildTimelineStep(
                    context,
                    icon: Icons.hourglass_bottom,
                    color: AppColors.greyLight,
                    iconColor: AppColors.textGrey,
                    title: ItemDetailsStrings.sellerReview,
                    subtitle: ItemDetailsStrings.sellerReviewSubtitle,
                  ),
                  _buildTimelineStep(
                    context,
                    icon: Icons.chat_bubble_outline,
                    color: AppColors.greyLight,
                    iconColor: AppColors.textGrey,
                    title: ItemDetailsStrings.chatAndMeet,
                    subtitle: ItemDetailsStrings.chatAndMeetSubtitle,
                  ),
                  
                  // Add some bottom padding to ensure content isn't flush with the button/bottom
                  AppValues.gapL,
                ],
              ),
            ),
          ),

          // 5. Dynamic Footer Button (Fixed at bottom)
          Padding(
            padding: const EdgeInsets.only(top: AppValues.spacingS),
            child: _buildFooterButton(context, status),
          ),
        ],
      ),
    );
  }

  // --- WIDGET BUILDERS ---

  Widget _buildHeader(BuildContext context, String status) {
    String title = ItemDetailsStrings.statusUnderReview;
    String subtitle = ItemDetailsStrings.statusUnderReviewSubtitle;
    Color color = AppColors.black;

    if (status == 'accepted') {
      title = ItemDetailsStrings.statusAccepted;
      subtitle = ItemDetailsStrings.statusAcceptedSubtitle;
      color = AppColors.successColor; 
    } else if (status == 'rejected') {
      title = ItemDetailsStrings.statusRejected;
      subtitle = ItemDetailsStrings.statusRejectedSubtitle;
      color = AppColors.errorColor;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        AppValues.gapXS,
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildComparisonCard(BuildContext context) {
    // A. Parse Seller Data (Right Side)
    final sellerImages = listingItem['images'] as List<dynamic>? ?? [];
    final sellerImage = sellerImages.isNotEmpty ? sellerImages.first : '';
    final sellerProfile = listingItem[ItemDetailsStrings.fieldProfiles] ?? {};
    final sellerName = sellerProfile['username'] ?? 'Seller';

    // B. Parse Buyer Offer Data (Left Side)
    final swapImages = myOffer['swap_item_images'] as List<dynamic>? ?? [];
    final swapImage = swapImages.isNotEmpty ? swapImages.first : '';
    // Offer might store "Nike (Used)" -> Just take "Nike"
    final swapTitle = (myOffer['swap_item_text'] ?? ItemDetailsStrings.labelCashOffer).toString().split('(').first;

    // Check for Cash component
    final cashAmount = (myOffer['cash_offer'] ?? 0).toDouble();
    final hasCash = cashAmount > 0;

    return Container(
      padding: const EdgeInsets.all(AppValues.spacingM),
      decoration: BoxDecoration(
        color: AppColors.greyLight.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppValues.radiusL),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Align to top
        children: [
          // 1. YOUR ITEM (Left)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(ItemDetailsStrings.labelYourItem, style: TextStyle(fontSize: 10, color: AppColors.textGrey)),
                Text(
                  swapImage.isEmpty && hasCash ? ItemDetailsStrings.labelCashOffer : swapTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                AppValues.gapS,
                _buildItemImage(
                    imageUrl: swapImage,
                    cashBadge: hasCash ? "${ItemDetailsStrings.currencySymbol}${cashAmount.toStringAsFixed(0)}" : null,
                    isCashOnly: swapImage.isEmpty && hasCash
                ),
              ],
            ),
          ),

          // 2. ARROW (Center)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppValues.spacingS, vertical: 40),
            child: const Icon(Icons.arrow_forward, color: AppColors.royalBlue, size: 20),
          ),

          // 3. SELLER ITEM (Right)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(ItemDetailsStrings.labelSellerItem, style: TextStyle(fontSize: 10, color: AppColors.textGrey)),
                Text(
                  listingItem['title'] ?? ItemDetailsStrings.defaultItemName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                AppValues.gapS,
                _buildItemImage(imageUrl: sellerImage),
                AppValues.gapS,
                Text(
                  "${ItemDetailsStrings.sellerPrefix}$sellerName",
                  style: const TextStyle(fontSize: 10, color: AppColors.textGrey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemImage({required String imageUrl, String? cashBadge, bool isCashOnly = false}) {
    return Column(
      children: [
        Container(
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppValues.radiusM),
            image: (imageUrl.isNotEmpty)
                ? DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover)
                : null,
          ),
          child: (imageUrl.isEmpty)
              ? Icon(isCashOnly ? Icons.payments_outlined : Icons.image_not_supported, color: AppColors.greyMedium, size: 40)
              : null,
        ),
        if (cashBadge != null) ...[
          Transform.translate(
            offset: const Offset(0, -10), // Float up slightly overlap
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppValues.spacingM, vertical: 4),
              decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppValues.radiusS),
                  boxShadow: [
                    BoxShadow(color: AppColors.black.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 2))
                  ]
              ),
              child: Text(
                cashBadge,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          )
        ]
      ],
    );
  }

  Widget _buildTimelineStep(BuildContext context, {required IconData icon, required Color color, required Color iconColor, required String title, required String subtitle}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppValues.spacingM),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppValues.spacingS),
            decoration: BoxDecoration(
              color: color, // Light Blue or Grey
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: iconColor),
          ),
          AppValues.gapM,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text(subtitle, style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildFooterButton(BuildContext context, String status) {
    String text = ItemDetailsStrings.btnPending;
    Color bgColor = AppColors.white;
    Color textColor = AppColors.royalBlue;
    BorderSide side = const BorderSide(color: AppColors.royalBlue, width: 1.5);
    VoidCallback? onTap;

    if (status == 'accepted') {
      text = ItemDetailsStrings.btnDealChat;
      bgColor = AppColors.royalBlue;
      textColor = AppColors.white;
      side = BorderSide.none;
      onTap = () {
        // TODO: Navigate to Chat Screen
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(ItemDetailsStrings.msgNavigatingChat)));
      };
    } else if (status == 'rejected') {
      text = ItemDetailsStrings.btnRejected;
      bgColor = AppColors.greyDisabled; // Or Red Light
      textColor = AppColors.errorColor; // Or Red Dark
      side = BorderSide.none;
      onTap = null; // Disabled
    } else {
      // Pending
      onTap = null; // Disabled
    }

    return SizedBox(
      width: double.infinity,
      height: AppValues.buttonHeight,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          side: side,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppValues.radiusCircular)),
        ),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }
}
