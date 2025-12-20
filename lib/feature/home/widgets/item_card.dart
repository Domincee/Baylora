import 'package:baylora_prjct/core/constant/app_values_widget.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/core/util/uni_image.dart';
import 'package:baylora_prjct/feature/home/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/assets/images.dart';

class ItemCard extends StatelessWidget {
  final String postedTime;
  /* seller info */
  final String sellerName;
  final String sellerImage;

  final bool isVerified;
  final String totalTrade;

  final String rating;
  final bool isRated;
  /* item info */
  final String type;

  final String price;
  final String swapItem;

  final String title;
  final String description;
  final String imagePath;

  const ItemCard({
    super.key,
    required this.postedTime,
    required this.sellerName,
    required this.sellerImage,
    this.isRated = false,
    this.isVerified = false,
    this.rating = "0.0",
    this.totalTrade = "0.0",
    required this.type,
    this.price = "0.0",
    this.swapItem = "",
    required this.title,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15), 
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: AppValuesWidget.borderRadius,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.5),
            blurRadius: 0.5,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // --- LEFT GROUP: Avatar + Name + Time ---
              Row(
                children: [
                  ProfileAvatar(
                      imageUrl: sellerImage,
                      size: 32,
                    ),

                  const SizedBox(width: AppValuesWidget.sizedBoxSize), // Reduced spacing slightly for tighter look
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text("@$sellerName", style:
                          Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: AppColors.black,
                          ),
                          ),
                          if (isVerified) ...[
                            const SizedBox(width: 4),
                            SvgPicture.asset(Images.statusVerified, 
                            width: AppValuesWidget.avatarSize.width , 
                            height: AppValuesWidget.avatarSize.height,
                            ),
                          ]
                        ],
                      ),
                      Text(
                        "$postedTime ago",
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          color: AppColors.subTextColor
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              _buildRatingSection(context),
            ],
          ),

          const SizedBox(height: AppValuesWidget.sizedBoxSize,),
          // --- CONTENT: Text Info ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4), 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:  Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: AppColors.black,
                  )
                 ,
                ),
                Text(
                  description,
                  maxLines: 1, // Optional: limit lines if desc is long
                  overflow: TextOverflow.ellipsis,
                 style:  Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: AppColors.subTextColor,
                  ),
                ), 
                const SizedBox(height: 4),
                _buildPriceRow(context),
              ],
            ),
          ),
          
          const SizedBox(height: AppValuesWidget.sizedBoxSize,),

          // --- MAIN IMAGE ---
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 200, //
                ),
               child: UniversalImage( 
                  path: imagePath,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //LOGIC TO HIDE/SHOW RATING ---
  Widget _buildRatingSection(BuildContext context) {
    // Parse strings to numbers safely
    final double ratingVal = double.tryParse(rating) ?? 0.0;
    final int tradeVal = int.tryParse(totalTrade) ?? 0;

    // No rating AND No trades, hide everything.
    if (ratingVal <= 0 && tradeVal <= 0) {
      return const SizedBox.shrink(); 
    }

    // 2. Show only if there is data
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.lavenderBlue,
        borderRadius: BorderRadius.circular(8), 
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Rating Star + Number Only if rating > 0)
          if (ratingVal > 0) ...[
            SvgPicture.asset(Images.starRate, width: 15, height: 15),
            const SizedBox(width: 4),
            Text(
              rating,
              style:
              Theme.of(context).textTheme.labelMedium!.copyWith(
                color: AppColors.black,
              ), 
            ),
          ],

          // Divider Only if both exist
          if (ratingVal > 0 && tradeVal > 0)
            Container(
              height: 12,
              width: 1,
              color: AppColors.subTextColor,
              margin: const EdgeInsets.symmetric(horizontal: 6),
            ),

          // Total Trades Only if trades > 0
          if (tradeVal > 0)
            Text(
             "$totalTrade trades",
                style:
              Theme.of(context).textTheme.labelMedium!.copyWith(
                color: AppColors.black,
              ), 
            ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(BuildContext context) {
    if (type == 'cash') {
      return Text(
        "₱ $price",
        style: 
        Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: AppColors.highLightTextColor,
        )
      );
    }
     else if (type == 'trade') {
      return Row(
        children: [
          const Icon(Icons.swap_horiz, size: 16, color: Color(0xFF8B5CF6)),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              swapItem.isNotEmpty ? swapItem : "Trade Only",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: AppColors.highLightTextColor,
              ) 
              
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Text(
            "₱ ${price.replaceAll('000', 'k')}",
          style:
              Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: AppColors.highLightTextColor,
              ), 
          ),
          const SizedBox(width: 4),
           Text("or", style: 
          Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: AppColors.subTextColor,
          )
          ),
          const SizedBox(width: 4),
          const Icon(Icons.swap_horiz, size: AppValuesWidget.iconDefaultSize, color: Color(0xFF8B5CF6)),
        ],
      );
    }
  }
}