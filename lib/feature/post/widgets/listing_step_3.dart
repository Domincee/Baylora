import 'dart:io';
import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';

import '../constants/post_strings.dart';

class ListingStep3 extends StatelessWidget {
  final List<File> images;
  final String title;
  final String category;
  final String condition;
  final String? duration;
  final String description;
  final String price;
  final List<String> wishlistTags;
  final int selectedType; // 0: Sell, 1: Trade, 2: Both
  final VoidCallback onPost;

  const ListingStep3({
    super.key,
    required this.images,
    required this.title,
    required this.category,
    required this.condition,
    this.duration,
    required this.description,
    required this.price,
    required this.wishlistTags,
    required this.selectedType,
    required this.onPost,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppValues.paddingAll,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          AppValues.gapL,
          // Photos Section
          Row(
            children: [
              Text(
               PostStrings.photos,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    ),
              ),
              AppValues.gapHS,
              Text(
                "${images.length}/3",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.black,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
          AppValues.gapS,
            _imageBox(),
          AppValues.gapL,
          // Basic Info Header
          Text(
            PostStrings.basicInfo,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                ),
          ),
          AppValues.gapM,

          // Title
          _buildLabel(context, PostStrings.title),//string
          _buildReadOnlyField(context, title.isNotEmpty ? title : PostStrings.noTitle),//string
          AppValues.gapM,
          // Category
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  _buildLabel(context, PostStrings.category),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: _buildReadOnlyChip(context, category),//string
                  ),
                ],
              ),

              AppValues.gapM,

              // Condition
              Column(
                children: [
                  _buildLabel(context,PostStrings.condition),//string
                  Align(
                    alignment: Alignment.centerLeft,
                    child: _buildReadOnlyChip(context, condition),

                  ),
                ],
              ),

              AppValues.gapM,
              if (duration != null) ...[
                Column(
                  children: [
                    _buildLabel(context, PostStrings.duration),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: _buildReadOnlyChip(context, duration!),
                    ),
                  ],
                ),
              ],

            ],
          ),
          AppValues.gapM,

          // Price Section (Sell or Both)
          if (selectedType == 0 || selectedType == 2) ...[
            _buildLabel(context, PostStrings.minimumToBid),
            _PriceBox(price: price),
            AppValues.gapM,
          ],

          // Wishlist Section (Trade or Both)
          if (selectedType == 1 || selectedType == 2) ...[
            _buildLabel(context, PostStrings.lookingFor),
            _ItemBox(wishlistTags: wishlistTags),
            AppValues.gapL,
          ],

          // Description
          _buildLabel(context, PostStrings.descAndDetails),
          _DescriptionBox(description: description),
          AppValues.gapL,


          // Post Button
          _PostButton(onPost: onPost),
          AppValues.gapXL,
        ],
      ),
    );
  }

  //image box widget
  SizedBox _imageBox() {
    return SizedBox(
            height: AppValues.imageContainer.height,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              separatorBuilder: (context, index) => AppValues.gapM,
              itemBuilder: (context, index) {
                return Container(
                  width: AppValues.imageContainer.width,
                  height: AppValues.imageContainer.height,
                  decoration: BoxDecoration(
                    color: AppColors.greyLight,
                    borderRadius: AppValues.borderRadiusM,
                    border: Border.all(color: AppColors.greyMedium),
                    image: DecorationImage(
                      image: FileImage(images[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          );
  }

  //Title widget with bottom padding
  Widget _buildLabel(BuildContext context,String text) {
    return Padding(
      padding:  EdgeInsets.only(bottom: AppValues.spacingXS),
      child: Text(
        text,
        style:  Theme.of(context).textTheme.bodyLarge
      ),
    );
  }

  //gray box with text for title
  Widget _buildReadOnlyField(BuildContext context, String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: AppValues.spacingM, vertical: AppValues.spacingS),
      decoration: BoxDecoration(
        color: AppColors.greyLight,
        borderRadius:AppValues.borderRadiusCircular,
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.subTextColor
        ),
      ),
    );
  }

//gray pill with text for category,condition,duration
  Widget _buildReadOnlyChip(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppValues.spacingM, vertical: AppValues.spacingS),
      decoration: BoxDecoration(
        color: AppColors.greyLight,
        borderRadius:AppValues.borderRadiusCircular,
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
               color: AppColors.subTextColor
            ),
      ),
    );
  }
}

//post button at the bottom
class _PostButton extends StatelessWidget {
  const _PostButton({
    required this.onPost,
  });

  final VoidCallback onPost;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPost,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.royalBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius:AppValues.borderRadiusCircular,
          ),
          elevation: 0,
        ),
        child: const Text(
          "Post",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// item with light blue with text item name
class _ItemBox extends StatelessWidget {
  const _ItemBox({
    required this.wishlistTags,
  });

  final List<String> wishlistTags;


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppColors.greyLight,
        borderRadius: AppValues.borderRadiusM,
      ),
      child: Container(
        width: double.infinity,
        padding: AppValues.paddingS,
        decoration: BoxDecoration(
          borderRadius: AppValues.borderRadiusM,
        ),
        child:
             Wrap(
                spacing: 8,
                runSpacing: 8,
                children: wishlistTags.map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppValues.spacingM, vertical: AppValues.spacingS),
                    decoration: BoxDecoration(
                      color: AppColors.lavenderBlue,
                      borderRadius: AppValues.borderRadiusCircular,
                    ),
                    child: Text(
                      tag,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
                            color: AppColors.highLightTextColor,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  );
                }).toList(),
              ),
      ),
    );
  }
}

//container with gray color with value text of minimum price
class _PriceBox extends StatelessWidget {
  const _PriceBox({
    required this.price,
  });

  final String price;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: AppColors.greyLight,
        borderRadius: AppValues.borderRadiusM,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppValues.spacingM, vertical: AppValues.spacingS),
        decoration: BoxDecoration(
          borderRadius: AppValues.borderRadiusM,
        ),
        child: Text(
          price.isNotEmpty ? "₱ $price" : "₱ 0.00",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.subTextColor
              ),
        ),
      ),
    );
  }
}
//container gray with text description
class _DescriptionBox extends StatelessWidget {
  const _DescriptionBox({
    required this.description,
  });

  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppValues.paddingAll,
      decoration: BoxDecoration(
        color: AppColors.greyLight,
        borderRadius: AppValues.borderRadiusM,
      ),
      constraints:  BoxConstraints(minHeight: AppValues.boxMinConstraint100H.minHeight),
      child: Text(
            description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.subTextColor,
                    fontWeight: FontWeight.w600,

                  ),
      ),
    );
  }
}
