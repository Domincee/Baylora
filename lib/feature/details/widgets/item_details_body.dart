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
    final isTrade = type == 'trade';

    return Positioned.fill(
      bottom: 80, // Leave space for the bottom action bar
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // A. Images Header
            ImageCarouselHeader(images: images),

            Padding(
              padding: EdgeInsets.all(AppValues.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // B. Seller Info
                  SellerInfoRow(seller: seller, createdAtStr: createdAtStr),
                  AppValues.gapM,

                  // C. Title & Tags
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                  ),
                  AppValues.gapS,
                  TagsRow(
                    category: category,
                    condition: condition,
                    type: type,
                    endTime: endTime,
                  ),
                  AppValues.gapL,

                  // D. Description
                  Text(
                    ItemDetailsStrings.description,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  AppValues.gapXS,
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textGrey,
                          height: 1.5,
                        ),
                  ),
                  AppValues.gapL,

                  // E. Price Section OR Swap Preference
                  if (isTrade) ...[
                    Text(
                      "Seller is looking for:",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.textGrey,
                          ),
                    ),
                    AppValues.gapS,
                    SwapItemsWrap(swapItemString: item['swap_preference']),
                  ] else ...[
                    Text(
                      offers.isNotEmpty ? ItemDetailsStrings.currentHighestBid : ItemDetailsStrings.price,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.textGrey,
                          ),
                    ),
                    AppValues.gapXXS,
                    Text(
                      "${ItemDetailsStrings.currencySymbol} ${displayPrice.toString()}",
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: AppColors.highLightTextColor, // Blue
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                  AppValues.gapL,

                  // F. Bid History
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isTrade ? "Current Offers" : ItemDetailsStrings.currentBids,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        ItemDetailsStrings.offers,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textGrey,
                            ),
                      ),
                    ],
                  ),
                  AppValues.gapM,
                  BidList(offers: offers, isTrade: isTrade),

                  // Extra padding at bottom for scrolling past the floating button
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
