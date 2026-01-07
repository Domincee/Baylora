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
  final dynamic displayPrice; // This is the 'Highest Bid' calculated by Controller
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
      bottom: AppValues.buttonHeight + AppValues.spacingXL,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageCarouselHeader(images: images),
            Padding(
              padding: const EdgeInsets.all(AppValues.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SellerInfoRow(seller: seller, createdAtStr: createdAtStr),
                  AppValues.gapM,
                  _buildTitle(context),
                  AppValues.gapS,
                  TagsRow(
                    category: category,
                    condition: condition,
                    type: type,
                    endTime: endTime,
                  ),
                  AppValues.gapL,
                  _buildDescription(context),
                  AppValues.gapL,

                  // FIXED: Updated Price Section Logic
                  _buildPriceOrSwapSection(context, isMix, isTrade),

                  AppValues.gapL,
                  _buildBidHistoryHeader(context, isTrade, isMix),
                  AppValues.gapM,

                  // Bid List
                  BidList(offers: offers, isTrade: isTrade, isMix: isMix),
                  AppValues.gapXXL,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ... (Title and Description methods remain the same) ...
  Widget _buildTitle(BuildContext context) {
    return Text(title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold));
  }

  Widget _buildDescription(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(ItemDetailsStrings.description, style: _getHeaderStyle(context)),
        AppValues.gapXS,
        Text(description, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textGrey, height: 1.5)),
      ],
    );
  }

  Widget _buildPriceOrSwapSection(BuildContext context, bool isMix, bool isTrade) {
    if (isMix) return _buildMixSection(context);
    if (isTrade) return _buildSwapSection(context);
    return _buildCashSection(context);
  }

  Widget _buildMixSection(BuildContext context) {
    // 1. Get the Minimum Price (Starting Price)
    final double minPrice = (item['price'] is num) ? (item['price'] as num).toDouble() : 0.0;

    // 2. Get Current Highest Bid (Safe parsing)
    // We try to use the 'displayPrice' passed from parent, or calculate from offers
    double highestBid = 0.0;
    if (offers.isNotEmpty) {
      // FIX: Use 'cash_offer' instead of 'amount'
      highestBid = (offers.first['cash_offer'] ?? 0).toDouble();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // LEFT: Always show Minimum Price
            _buildPriceColumn(
              context,
              "Minimum Bid", // Label for base price
              minPrice.toStringAsFixed(0),
            ),

            // RIGHT: Only show Highest Bid if it exists (> 0)
            if (highestBid > 0)
              _buildPriceColumn(
                context,
                ItemDetailsStrings.currentHighestBid,
                highestBid.toStringAsFixed(0),
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
    // 1. Get Minimum Price
    final double minPrice = (item['price'] is num) ? (item['price'] as num).toDouble() : 0.0;

    // 2. Get Highest Bid
    double highestBid = 0.0;
    if (offers.isNotEmpty) {
      highestBid = (offers.first['cash_offer'] ?? 0).toDouble();
    }

    // Logic: Always show Minimum. If there is a bid, show that too.
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildPriceColumn(
          context,
          "Minimum Bid",
          minPrice.toStringAsFixed(0),
        ),

        if (highestBid > 0)
          _buildPriceColumn(
            context,
            ItemDetailsStrings.currentHighestBid,
            highestBid.toStringAsFixed(0),
            crossAxisAlignment: CrossAxisAlignment.end,
          ),
      ],
    );
  }

  Widget _buildSwapSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(ItemDetailsStrings.sellerLookingFor, style: _getSubHeaderStyle(context)),
        AppValues.gapS,
        SwapItemsWrap(swapItemString: item['swap_preference']),
      ],
    );
  }

  Widget _buildPriceColumn(BuildContext context, String label, String amount, {CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start}) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(label, style: _getSubHeaderStyle(context)),
        AppValues.gapXXS,
        Text(
          "${ItemDetailsStrings.currencySymbol} $amount",
          style: _getPriceStyle(context),
        ),
      ],
    );
  }

  Widget _buildBidHistoryHeader(BuildContext context, bool isTrade, bool isMix) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text((isTrade || isMix) ? ItemDetailsStrings.currentOffers : ItemDetailsStrings.currentBids, style: _getHeaderStyle(context)),
        Text(ItemDetailsStrings.offers, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textGrey)),
      ],
    );
  }

  TextStyle? _getHeaderStyle(BuildContext context) => Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold);
  TextStyle? _getSubHeaderStyle(BuildContext context) => Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.textGrey);
  TextStyle? _getPriceStyle(BuildContext context) => Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.highLightTextColor, fontWeight: FontWeight.bold);
}