import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/details/constants/item_details_strings.dart';
import 'package:baylora_prjct/feature/details/widgets/bid_list.dart';
import 'package:baylora_prjct/feature/details/widgets/image_carousel_header.dart';
import 'package:baylora_prjct/feature/details/widgets/seller_info_row.dart';
import 'package:baylora_prjct/feature/details/widgets/tags_row.dart';
import 'package:baylora_prjct/feature/shared/widgets/swap_items_wrap.dart';
import 'package:flutter/material.dart';

class ItemDetailsBody extends StatelessWidget {
  final Map<String, dynamic> item;
  final Map<String, dynamic> seller;
  final List<dynamic> offers;
  final dynamic displayPrice;
  final List<dynamic> images;
  final String title;
  final String description;
  final String type;
  final String category;
  final String condition;
  final DateTime? endTime;
  final String createdAtStr;

  const ItemDetailsBody({
    super.key,
    required this.item,
    required this.seller,
    required this.offers,
    required this.displayPrice,
    required this.images,
    required this.title,
    required this.description,
    required this.type,
    required this.category,
    required this.condition,
    required this.endTime,
    required this.createdAtStr,
  });

  @override
  Widget build(BuildContext context) {
    final isTrade = type == ItemDetailsStrings.typeTrade;
    final isMix = type == ItemDetailsStrings.typeMix;

    return Positioned.fill(
      bottom: AppValues.buttonHeight + AppValues.spacingXL, // Leave space for the bottom action bar
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // A. Images Header
            ImageCarouselHeader(images: images),

            Padding(
              padding: const EdgeInsets.all(AppValues.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // B. Seller Info
                  SellerInfoRow(seller: seller, createdAtStr: createdAtStr),
                  AppValues.gapM,

                  // C. Title & Tags
                  _buildTitle(context),
                  AppValues.gapS,
                  TagsRow(
                    category: category,
                    condition: condition,
                    type: type,
                    endTime: endTime,
                  ),
                  AppValues.gapL,

                  // D. Description
                  _buildDescription(context),
                  AppValues.gapL,

                  // E. Price Section OR Swap Preference
                  _buildPriceOrSwapSection(context, isMix, isTrade),
                  AppValues.gapL,

                  // F. Bid History
                  _buildBidHistoryHeader(context, isTrade, isMix),
                  AppValues.gapM,

                  // Bid List
                  BidList(offers: offers, isTrade: isTrade, isMix: isMix),

                  // Extra padding at bottom for scrolling past the floating button
                  AppValues.gapXXL,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ItemDetailsStrings.description,
          style: _getHeaderStyle(context),
        ),
        AppValues.gapXS,
        Text(
          description,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textGrey,
                height: 1.5,
              ),
        ),
      ],
    );
  }

  Widget _buildPriceOrSwapSection(
    BuildContext context,
    bool isMix,
    bool isTrade,
  ) {
    if (isMix) {
      return _buildMixSection(context);
    } else if (isTrade) {
      return _buildSwapSection(context);
    } else {
      return _buildCashSection(context);
    }
  }

  Widget _buildMixSection(BuildContext context) {
    // Check if there are offers and the first one has a valid amount
    final double highestBid =
        (offers.isNotEmpty) ? (offers.first['amount'] ?? 0).toDouble() : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildPriceColumn(
              context,
              ItemDetailsStrings.price,
              item['price']?.toString() ?? '0',
            ),
            if (highestBid > 0)
              _buildPriceColumn(
                context,
                ItemDetailsStrings.currentHighestBid,
                highestBid.toString(),
                crossAxisAlignment: CrossAxisAlignment.end,
              ),
          ],
        ),
        AppValues.gapL,
        _buildSwapSection(context),
      ],
    );
  }

  Widget _buildCashSection(BuildContext context) {
    final label = offers.isNotEmpty
        ? ItemDetailsStrings.currentHighestBid
        : ItemDetailsStrings.price;

    return _buildPriceColumn(
      context,
      label,
      displayPrice.toString(),
    );
  }

  Widget _buildSwapSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ItemDetailsStrings.sellerLookingFor,
          style: _getSubHeaderStyle(context),
        ),
        AppValues.gapS,
        SwapItemsWrap(swapItemString: item['swap_preference']),
      ],
    );
  }

  Widget _buildPriceColumn(
    BuildContext context,
    String label,
    String amount, {
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
  }) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(
          label,
          style: _getSubHeaderStyle(context),
        ),
        AppValues.gapXXS,
        Text(
          "${ItemDetailsStrings.currencySymbol} $amount",
          style: _getPriceStyle(context),
        ),
      ],
    );
  }

  Widget _buildBidHistoryHeader(
    BuildContext context,
    bool isTrade,
    bool isMix,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          (isTrade || isMix)
              ? ItemDetailsStrings.currentOffers
              : ItemDetailsStrings.currentBids,
              style: _getHeaderStyle(context),
        ),
        Text(
          ItemDetailsStrings.offers,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textGrey,
              ),
        ),
      ],
    );
  }

  // --- Reusable Text Styles ---

  TextStyle? _getHeaderStyle(BuildContext context) {
    return Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        );
  }

  TextStyle? _getSubHeaderStyle(BuildContext context) {
    return Theme.of(context).textTheme.titleMedium?.copyWith(
          color: AppColors.textGrey,
        );
  }

  TextStyle? _getPriceStyle(BuildContext context) {
    return Theme.of(context).textTheme.headlineMedium?.copyWith(
          color: AppColors.highLightTextColor,
          fontWeight: FontWeight.bold,
        );
  }
}
