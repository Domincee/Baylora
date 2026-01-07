import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/core/widgets/common_error_widget.dart';
import 'package:baylora_prjct/feature/details/constants/item_details_strings.dart';
import 'package:baylora_prjct/feature/details/controller/item_details_controller.dart';
import 'package:baylora_prjct/feature/details/provider/item_details_provider.dart';
import 'package:baylora_prjct/feature/details/widgets/bid_input_modal.dart';
import 'package:baylora_prjct/feature/details/widgets/item_details_app_bar.dart';
import 'package:baylora_prjct/feature/details/widgets/item_details_body.dart';
import 'package:baylora_prjct/feature/details/widgets/item_details_bottom_bar.dart';
import 'package:baylora_prjct/feature/details/widgets/offer_status_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ItemDetailsScreen extends ConsumerWidget {
  final String itemId;

  const ItemDetailsScreen({super.key, required this.itemId});

  Future<void> _handlePlaceBid(BuildContext context, WidgetRef ref, String type, double currentHighest, double minimumBid) async {
    // Step 1: Input Modal
    final bool? success = await _showInputModal(context, type, currentHighest, minimumBid);

    // Step 2: Success Modal
    if (success == true && context.mounted) {
      ref.invalidate(itemDetailsProvider(itemId));
      await _showOfferStatusModal(context);
    }
  }

  Future<bool?> _showInputModal(BuildContext context, String type, double currentHighest, double minimumBid) {
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
        );
      },
    );
  }

  Future<void> _showOfferStatusModal(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const OfferStatusModal(),
    );
  }

  Widget _buildErrorState(Object? error, VoidCallback onRetry) {
    return CommonErrorWidget(
      error: error,
      onRetry: onRetry,
      customErrorMessage: ItemDetailsStrings.getLoadingErrorMessage(error.toString()),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, Map<String, dynamic> item) {
    // 1. Data Processing via Controller
    final seller = item[ItemDetailsStrings.fieldProfiles] ?? {};
    final rawOffers = item[ItemDetailsStrings.fieldOffers] ?? [];

    final offers = ItemDetailsController.sortOffers(rawOffers);
    final displayPrice = ItemDetailsController.calculateDisplayPrice(
        offers, item['price']);
    final isOwner = ItemDetailsController.isOwner(item, seller);

    // 2. Parsed Fields
    final images = (item['images'] as List<dynamic>?) ?? [];
    final title = item['title'] ?? ItemDetailsStrings.noTitle;
    final description = item['description'] ?? '';
    final type = item['type'] ?? ItemDetailsStrings.typeCash;
    final category = item['category'] ?? ItemDetailsStrings.defaultCategory;
    final condition = item['condition'] ?? ItemDetailsStrings.defaultCondition;
    final endTime = ItemDetailsController.parseEndTime(item['end_time']);
    final createdAtStr = item['created_at'];

    final double currentHighest = (displayPrice is num) ? displayPrice.toDouble() : 0.0;
    // Assuming minimum bid is current highest for now as logic wasn't specified beyond "Minimum Bid: P..."
    final double minimumBid = currentHighest; 

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
            onPlaceBid: () => _handlePlaceBid(context, ref, type, currentHighest, minimumBid),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemAsync = ref.watch(itemDetailsProvider(itemId));

    return Scaffold(
      backgroundColor: AppColors.white,
      body: itemAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _buildErrorState(
          error,
          () => ref.invalidate(itemDetailsProvider(itemId)),
        ),
        data: (item) => _buildContent(context, ref, item),
      ),
    );
  }
}
