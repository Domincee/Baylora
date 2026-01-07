import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/core/widgets/action_bottom_sheet.dart';
import 'package:baylora_prjct/core/widgets/common_error_widget.dart';
import 'package:baylora_prjct/feature/details/constants/item_details_strings.dart';
import 'package:baylora_prjct/feature/details/controller/item_details_controller.dart';
import 'package:baylora_prjct/feature/details/provider/item_details_provider.dart';
import 'package:baylora_prjct/feature/details/widgets/item_details_app_bar.dart';
import 'package:baylora_prjct/feature/details/widgets/item_details_body.dart';
import 'package:baylora_prjct/feature/details/widgets/item_details_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ItemDetailsScreen extends ConsumerWidget {
  final String itemId;

  const ItemDetailsScreen({super.key, required this.itemId});

  Future<void> _handlePlaceBid(BuildContext context, String type) async {
    // Step 1: Input Modal
    final bool? shouldProceed = await _showInputModal(context, type);

    // Step 2: Review Modal
    if (shouldProceed == true && context.mounted) {
      await _showReviewModal(context);
    }
  }

  Future<bool?> _showInputModal(BuildContext context, String type) {
    final isCash = type == ItemDetailsStrings.typeCash;
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppValues.radiusXL)),
      ),
      builder: (context) {
        return ActionBottomSheet(
          heightFactor: 0.5,
          title: isCash
              ? ItemDetailsStrings.placeYourBid
              : ItemDetailsStrings.placeYourOffer,
          titleStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          actionLabel: isCash
              ? ItemDetailsStrings.confirmBid
              : ItemDetailsStrings.submitOffer,
          onAction: () => Navigator.pop(context, true),
          child: Container(), // Body Placeholder
        );
      },
    );
  }

  Future<void> _showReviewModal(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppValues.radiusXL)),
      ),
      builder: (context) {
        return ActionBottomSheet(
          heightFactor: 0.4,
          title: ItemDetailsStrings.reviewOffer,
          titleStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          actionLabel: ItemDetailsStrings.submitFinalOffer,
          onAction: () {
            // Submit Final Offer logic
            Navigator.pop(context);
          },
          child: Container(), // Body Placeholder
        );
      },
    );
  }

  Widget _buildErrorState(Object? error, VoidCallback onRetry) {
    return CommonErrorWidget(
      error: error,
      onRetry: onRetry,
      customErrorMessage: ItemDetailsStrings.getLoadingErrorMessage(error.toString()),
    );
  }

  Widget _buildContent(BuildContext context, Map<String, dynamic> item) {
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
            onPlaceBid: () => _handlePlaceBid(context, type),
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
          () => ref.refresh(itemDetailsProvider(itemId)),
        ),
        data: (item) => _buildContent(context, item),
      ),
    );
  }
}
