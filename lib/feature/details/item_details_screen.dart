import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/core/widgets/common_error_widget.dart';
import 'package:baylora_prjct/feature/bid/widgets/modals/bid_input_modal.dart';
import 'package:baylora_prjct/feature/details/constants/item_details_strings.dart';
import 'package:baylora_prjct/feature/details/controller/item_details_controller.dart';
import 'package:baylora_prjct/feature/details/provider/item_details_provider.dart';
import 'package:baylora_prjct/feature/details/widgets/item_details_app_bar.dart';
import 'package:baylora_prjct/feature/details/widgets/item_details_body.dart';
import 'package:baylora_prjct/feature/details/widgets/item_details_bottom_bar.dart';
import 'package:baylora_prjct/feature/details/widgets/offer_status_modal.dart';
import 'package:baylora_prjct/feature/profile/provider/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ItemDetailsScreen extends ConsumerWidget {
  final String itemId;

  const ItemDetailsScreen({super.key, required this.itemId});

  Future<void> _handlePlaceBid(
      BuildContext context,
      WidgetRef ref,
      String type,
      double currentHighest,
      double minimumBid,
      double? existingBidAmount,
      bool hasOffered,
      ) async {
    final isTradeOrMix = type == ItemDetailsStrings.typeTrade || type == ItemDetailsStrings.typeMix;

    if (hasOffered && isTradeOrMix) {
      // FIX: Added 'ref' here
      await _showOfferStatusModal(context, ref);
      return;
    }

    final bool? success = await _showInputModal(context, type, currentHighest, minimumBid, existingBidAmount);

    // Step 2: Success Modal
    if (success == true && context.mounted) {
      ref.invalidate(itemDetailsProvider(itemId));
      ref.invalidate(userOfferProvider(itemId));
      ref.invalidate(myBidsProvider);
      // FIX: 'ref' was already correct here
      await _showOfferStatusModal(context, ref);
    }
  }

  Future<bool?> _showInputModal(
      BuildContext context,
      String type,
      double currentHighest,
      double minimumBid,
      double? existingBidAmount,
      ) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return BidInputModal(
          listingType: type,
          currentHighest: currentHighest,
          minimumBid: minimumBid,
          itemId: itemId,
          initialBidAmount: existingBidAmount,
        );
      },
    );
  }

  Future<void> _showOfferStatusModal(BuildContext context, WidgetRef ref) async {
    // 1. Get current data from providers
    final itemState = ref.read(itemDetailsProvider(itemId));
    final offerState = ref.read(userOfferProvider(itemId));

    // 2. Extract Data (Safe Unwrap)
    final listingItem = itemState.valueOrNull;
    final myOffer = offerState.valueOrNull;

    if (listingItem == null || myOffer == null) return;

    // 3. Show Modal with Data
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => OfferStatusModal(
        listingItem: listingItem,
        myOffer: myOffer,
      ),
    );
  }

  // Added back to ensure compilation
  Widget _buildErrorState(Object? error, VoidCallback onRetry) {
    return CommonErrorWidget(
      error: error,
      onRetry: onRetry,
      customErrorMessage: ItemDetailsStrings.getLoadingErrorMessage(error.toString()),
    );
  }

  Widget _buildContent(
      BuildContext context,
      WidgetRef ref,
      Map<String, dynamic> item,
      Map<String, dynamic>? userOffer,
      ) {
    final seller = item[ItemDetailsStrings.fieldProfiles] ?? {};
    final rawOffers = item[ItemDetailsStrings.fieldOffers] ?? [];

    final offers = ItemDetailsController.sortOffers(rawOffers);
    final displayPrice = ItemDetailsController.calculateDisplayPrice(
        offers, item['price']);
    final isOwner = ItemDetailsController.isOwner(item, seller);

    final images = (item['images'] as List<dynamic>?) ?? [];
    final title = item['title'] ?? ItemDetailsStrings.noTitle;
    final description = item['description'] ?? '';
    final type = item['type'] ?? ItemDetailsStrings.typeCash;
    final category = item['category'] ?? ItemDetailsStrings.defaultCategory;
    final condition = item['condition'] ?? ItemDetailsStrings.defaultCondition;
    final endTime = ItemDetailsController.parseEndTime(item['end_time']);
    final createdAtStr = item['created_at'];

    final bool hasBids = offers.isNotEmpty;
    final double startingPrice = (item['price'] as num?)?.toDouble() ?? 0.0;

    // Logic: If there are bids, the highest is the first one (since we sorted).
    // If no bids, current highest is 0 (or you could set it to startingPrice if you prefer).
    final double highestBidAmount = hasBids ? ((offers.first['cash_offer'] ?? 0) as num).toDouble() : 0.0;

    final double minimumBid = startingPrice;

    final bool hasOffered = userOffer != null;
    final double? existingBidAmount = hasOffered && userOffer['cash_offer'] != null
        ? (userOffer['cash_offer'] as num).toDouble()
        : null;

    return Stack(
      children: [
        // 1. Scrollable Content
        ItemDetailsBody(
          item: item,
          seller: seller,
          offers: offers,
          displayPrice: displayPrice,
          images: images,
          title: title,
          description: description,
          type: type,
          category: category,
          condition: condition,
          endTime: endTime,
          createdAtStr: createdAtStr,
        ),

        // 2. Transparent App Bar
        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: ItemDetailsAppBar(),
        ),

        // 3. Bottom Action Bar
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ItemDetailsBottomBar(
            isOwner: isOwner,
            isTrade: type == ItemDetailsStrings.typeTrade,
            isMix: type == ItemDetailsStrings.typeMix,
            hasBid: hasOffered,
            onPlaceBid: () => _handlePlaceBid(
                context,
                ref,
                type,
                highestBidAmount,
                minimumBid,
                existingBidAmount,
                hasOffered
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemAsync = ref.watch(itemDetailsProvider(itemId));
    final userOfferAsync = ref.watch(userOfferProvider(itemId));

    return Scaffold(
      backgroundColor: AppColors.white,
      body: itemAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _buildErrorState(
          error,
              () {
            ref.invalidate(itemDetailsProvider(itemId));
            ref.invalidate(userOfferProvider(itemId));
          },
        ),
        data: (item) {
          return userOfferAsync.when(
            data: (userOffer) => _buildContent(context, ref, item, userOffer),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => _buildContent(context, ref, item, null),
          );
        },
      ),
    );
  }
}