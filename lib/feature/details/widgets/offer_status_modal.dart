import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/chat/deal_chat_screen.dart';
import 'package:baylora_prjct/feature/details/constants/item_details_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../profile/widgets/management_listing_card.dart';

class OfferStatusModal extends ConsumerWidget {
  final Map<String, dynamic> listingItem;
  final Map<String, dynamic> myOffer;

  const OfferStatusModal({
    super.key,
    required this.listingItem,
    required this.myOffer,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemId = listingItem['id'];
    final offerId = myOffer['id'];

    // 1. LISTEN TO LIVE STATUS
    // We watch the stream for this item. If the seller changes status, this rebuilds.
    final offersAsync = ref.watch(offerSubscriptionProvider(itemId));

    // 2. Extract Latest Data
    // Find our specific offer from the live list. Fallback to 'myOffer' if loading/error.
    final currentOffer = offersAsync.when(
      data: (offers) => offers.firstWhere(
            (o) => o['id'] == offerId,
        orElse: () => myOffer,
      ),
      error: (_, _) => myOffer,
      loading: () => myOffer,
    );

    final status = currentOffer['status'] ?? 'pending';

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: const EdgeInsets.fromLTRB(
        AppValues.spacingL,
        AppValues.spacingS,
        AppValues.spacingL,
        AppValues.spacingL,
      ),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppValues.radiusXL)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
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

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 3. Header (Updates on status change)
                  _buildHeader(context, status),
                  AppValues.gapL,

                  // Comparison Card
                  _buildComparisonCard(context, currentOffer),
                  AppValues.gapXL,

                  // 4. Timeline (Updates colors/icons)
                  const Text(ItemDetailsStrings.whatHappensNext, style: TextStyle(fontWeight: FontWeight.bold)),
                  AppValues.gapM,

                  _buildTimeline(context, status),

                  AppValues.gapL,
                ],
              ),
            ),
          ),

          // 5. Footer Button (Updates state)
          Padding(
            padding: const EdgeInsets.only(top: AppValues.spacingS),
            child: _buildFooterButton(context, status, currentOffer),
          ),
        ],
      ),
    );
  }

  // --- WIDGET BUILDERS ---

  Widget _buildTimeline(BuildContext context, String status) {
    // Default / Pending Colors
    Color step1Color = AppColors.royalBlue.withValues(alpha: 0.1);
    Color step1Icon = AppColors.royalBlue;

    Color step2Color = AppColors.greyLight;
    Color step2Icon = AppColors.textGrey;
    IconData step2IconData = Icons.hourglass_bottom;

    Color step3Color = AppColors.greyLight;
    Color step3Icon = AppColors.textGrey;

    // Logic for Accepted/Rejected
    if (status == 'accepted') {
      // Step 2: Blue Check
      step2Color = AppColors.royalBlue.withValues(alpha: 0.1);
      step2Icon = AppColors.royalBlue;
      step2IconData = Icons.check_circle;

      // Step 3: Blue Chat
      step3Color = AppColors.royalBlue.withValues(alpha: 0.1);
      step3Icon = AppColors.royalBlue;
    } else if (status == 'rejected') {
      // Step 2: Red X
      step2Color = AppColors.errorColor.withValues(alpha: 0.1);
      step2Icon = AppColors.errorColor;
      step2IconData = Icons.cancel;
    }

    return Column(
      children: [
        _buildTimelineStep(
          context,
          icon: Icons.check_circle,
          color: step1Color,
          iconColor: step1Icon,
          title: ItemDetailsStrings.offerSent,
          subtitle: ItemDetailsStrings.offerSentSubtitle,
        ),
        _buildTimelineStep(
          context,
          icon: step2IconData,
          color: step2Color,
          iconColor: step2Icon,
          title: status == 'rejected' ? "Offer Rejected" : ItemDetailsStrings.sellerReview, // Change text if rejected
          subtitle: status == 'rejected'
              ? "The seller has declined this offer."
              : ItemDetailsStrings.sellerReviewSubtitle,
        ),
        _buildTimelineStep(
          context,
          icon: Icons.chat_bubble_outline,
          color: step3Color,
          iconColor: step3Icon,
          title: ItemDetailsStrings.chatAndMeet,
          subtitle: ItemDetailsStrings.chatAndMeetSubtitle,
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, String status) {
    String title = ItemDetailsStrings.statusUnderReview;
    String subtitle = ItemDetailsStrings.statusUnderReviewSubtitle;
    Color color = AppColors.black;

    if (status == 'accepted') {
      title = ItemDetailsStrings.statusAccepted;
      subtitle = ItemDetailsStrings.statusAcceptedSubtitle;
      color = AppColors.successColor;
    } else if (status == 'rejected') {
      title = "Offer Rejected"; // Updated Title
      subtitle = "This offer was not accepted by the seller.";
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

  Widget _buildComparisonCard(BuildContext context, Map<String, dynamic> offerData) {
    // Seller Data
    final sellerImages = listingItem['images'] as List<dynamic>? ?? [];
    final sellerImage = sellerImages.isNotEmpty ? sellerImages.first : '';
    final sellerProfile = listingItem[ItemDetailsStrings.fieldProfiles] ?? {};
    final sellerName = sellerProfile['username'] ?? 'Seller';

    // Buyer Offer Data (Use live data)
    final swapImages = offerData['swap_item_images'] as List<dynamic>? ?? [];
    final swapImage = swapImages.isNotEmpty ? swapImages.first : '';
    final swapTitle = (offerData['swap_item_text'] ?? ItemDetailsStrings.labelCashOffer).toString().split('(').first;
    final cashAmount = (offerData['cash_offer'] ?? 0).toDouble();
    final hasCash = cashAmount > 0;

    return Container(
      padding: const EdgeInsets.all(AppValues.spacingM),
      decoration: BoxDecoration(
        color: AppColors.greyLight.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppValues.radiusL),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Your Item
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
          // Arrow
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppValues.spacingS, vertical: 40),
            child: const Icon(Icons.arrow_forward, color: AppColors.royalBlue, size: 20),
          ),
          // Seller Item
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
            offset: const Offset(0, -10),
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
              color: color,
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

  Widget _buildFooterButton(BuildContext context, String status, Map<String, dynamic> offer) {
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
        Navigator.pop(context); // Close the modal
        // 1. EXTRACT SELLER INFO CORRECTLY
        final rawSeller = listingItem[ItemDetailsStrings.fieldProfiles];
        // Ensure we have a valid map or use defaults
        final sellerProfile = rawSeller != null ? Map<String, dynamic>.from(rawSeller) : <String, dynamic>{};
        final sellerName = sellerProfile['username'] ?? 'Seller';
        
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DealChatScreen(
              chatTitle: sellerName,
              itemName: listingItem['title'] ?? 'Item',
              contextId: offer['id'], // Use the offer ID as the chat room / context ID
            ),
          ),
        );
      };
    } else if (status == 'rejected') {
      text = "Rejected"; 
      bgColor = AppColors.greyDisabled;
      textColor = AppColors.grey400; // Disabled text look
      side = BorderSide.none;
      onTap = null; // Disabled
    } else {
      // Pending
      onTap = null;
    }

    return SizedBox(
      width: double.infinity,
      height: AppValues.buttonHeight,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          disabledBackgroundColor: bgColor, // Keep grey when disabled
          disabledForegroundColor: textColor, // Keep text grey
          side: side,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppValues.radiusCircular)),
        ),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }
}
