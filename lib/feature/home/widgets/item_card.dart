import 'package:baylora_prjct/core/constant/app_values_widget.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/core/util/uni_image.dart';
import 'package:baylora_prjct/feature/home/widgets/build_price.dart';
import 'package:baylora_prjct/feature/home/widgets/build_rating.dart';
import 'package:baylora_prjct/feature/home/widgets/build_user.dart';
import 'package:baylora_prjct/feature/home/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';


class ItemCard extends StatelessWidget {
  final String postedTime;
  /* user info */
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
      padding: AppValuesWidget.padding, 
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

                  const SizedBox(width: AppValuesWidget.sizedBoxSize), 
                  BuildUser(sellerName: sellerName, isVerified: isVerified, postedTime: postedTime),
                ],
              ),
              BuildRating(rating: rating, totalTrade: totalTrade, context: context),
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
                BuildPrice(type: type, price: price, swapItem: swapItem, context: context),
              ],
            ),
          ),
          
          const SizedBox(height: AppValuesWidget.sizedBoxSize,),

          // --- MAIN IMAGE ---
          Expanded(
            child: ClipRRect(
              borderRadius: AppValuesWidget.borderRadius,
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
}

