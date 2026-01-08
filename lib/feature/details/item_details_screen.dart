import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/core/widgets/common_error_widget.dart';
import 'package:baylora_prjct/feature/bid/widgets/modals/bid_input_modal.dart';
import 'package:baylora_prjct/feature/chat/screens/deal_chat_screen.dart';
import 'package:baylora_prjct/feature/details/constants/item_details_strings.dart';
import 'package:baylora_prjct/feature/details/controller/item_details_controller.dart';
import 'package:baylora_prjct/feature/details/provider/item_details_provider.dart';
import 'package:baylora_prjct/feature/details/widgets/item_details_app_bar.dart';
import 'package:baylora_prjct/feature/details/widgets/item_details_body.dart';
import 'package:baylora_prjct/feature/details/widgets/item_details_bottom_bar.dart';
import 'package:baylora_prjct/feature/details/widgets/offer_status_modal.dart';
import 'package:baylora_prjct/feature/manage_listing/screens/manage_listing_screen.dart';
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
      Map<String, dynamic>? userOffer,
      ) async {
    final isTradeOrMix = type == ItemDetailsStrings.typeTrade || type == ItemDetailsStrings.typeMix;

    if (hasOffered && isTradeOrMix) {
      await _showOfferStatusModal(context, ref);
      return;
    }

    final bool? success = await _showInputModal(context, type, currentHighest, minimumBid, existingBidAmount, userOffer);

    if (success == true && context.mounted) {
      ref.invalidate(itemDetailsProvider(itemId));
      ref.invalidate(userOfferProvider(itemId));
      ref.invalidate(myBidsProvider);
      await _showOfferStatusModal(context, ref);
    }
  }

  Future<bool?> _showInputModal(
      BuildContext context,
      String type,
      double currentHighest,
      double minimumBid,
      double? existingBidAmount,
      Map<String, dynamic>? userOffer,
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
          initialOffer: userOffer,
        );
      },
    );
  }

  Future<void> _showOfferStatusModal(BuildContext context, WidgetRef ref) async {
    final itemState = ref.read(itemDetailsProvider(itemId));
    final offerState = ref.read(userOfferProvider(itemId));

    final listingItem = itemState.valueOrNull;
    final myOffer = offerState.valueOrNull;

    if (listingItem == null || myOffer == null) return;

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

    final rawSeller = item[ItemDetailsStrings.fieldProfiles];
    final seller = rawSeller != null ? Map<String, dynamic>.from(rawSeller) : <String, dynamic>{};
    
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

    final double highestBidAmount = hasBids ? ((offers.first['cash_offer'] ?? 0) as num).toDouble() : 0.0;

    final double minimumBid = startingPrice;

    final bool hasOffered = userOffer != null;
    final double? existingBidAmount = hasOffered && userOffer['cash_offer'] != null
        ? (userOffer['cash_offer'] as num).toDouble()
        : null;

    final status = userOffer?['status'] ?? ''; // Extract status from offer

    return Stack(
      children: [
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

        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: ItemDetailsAppBar(),
        ),

        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ItemDetailsBottomBar(
            isOwner: isOwner,
            isTrade: type == ItemDetailsStrings.typeTrade,
            isMix: type == ItemDetailsStrings.typeMix,
            hasBid: hasOffered,
            status: status, // Pass the status
            onOwnerTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ManageListingScreen(itemId: itemId),
                ),
              );
            },
            onChatTap: () {
              // Navigate to Chat
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DealChatScreen(
                    chatTitle: seller['username'] ?? 'Seller',
                    itemName: title,
                    contextId: userOffer?['id'] ?? '',
                  ),
                ),
              );
            },
            onPlaceBid: () => _handlePlaceBid(
                context,
                ref,
                type,
                highestBidAmount,
                minimumBid,
                existingBidAmount,
                hasOffered,
                userOffer
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
