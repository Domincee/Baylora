import 'dart:io';
import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Photos",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                "${images.length}/3",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textGrey,
                    ),
              ),
            ],
          ),
          AppValues.gapS,
          if (images.isNotEmpty)
            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                separatorBuilder: (context, index) => AppValues.gapM,
                itemBuilder: (context, index) {
                  return Container(
                    width: 100,
                    height: 100,
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
            )
          else
            Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.greyLight,
                borderRadius: AppValues.borderRadiusM,
              ),
              child: const Center(child: Text("No images uploaded")),
            ),

          AppValues.gapL,

          // Basic Info Header
          Text(
            "Basic info",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          AppValues.gapM,

          // Title
          _buildLabel("Title"),
          _buildReadOnlyField(context, title.isNotEmpty ? title : "No Title"),
          AppValues.gapM,

          // Category
          _buildLabel("Category"),
          Align(
            alignment: Alignment.centerLeft,
            child: _buildReadOnlyChip(context, category),
          ),
          AppValues.gapM,

          // Condition
          _buildLabel("Condition"),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.royalBlue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                condition,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          AppValues.gapM,

          // Duration (Optional)
          if (duration != null) ...[
            _buildLabel("Duration"),
            Align(
              alignment: Alignment.centerLeft,
              child: _buildReadOnlyChip(context, duration!),
            ),
            AppValues.gapM,
          ],

          // Description
          _buildLabel("Description & Details"),
          Container(
            width: double.infinity,
            padding: AppValues.paddingAll,
            decoration: BoxDecoration(
              color: AppColors.greyLight,
              borderRadius: AppValues.borderRadiusM,
            ),
            constraints: const BoxConstraints(minHeight: 100),
            child: Text(
              description.isNotEmpty
                  ? description
                  : "Description of the item....",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textDarkGrey,
                  ),
            ),
          ),
          AppValues.gapL,

          // Price Section (Sell or Both)
          if (selectedType == 0 || selectedType == 2) ...[
            _buildLabel("Price ₱ "),
            Container(
              width: double.infinity,
              padding: AppValues.paddingAll,
              decoration: BoxDecoration(
                color: AppColors.greyLight,
                borderRadius: AppValues.borderRadiusM,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  price.isNotEmpty ? price: "₱ 0.00",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
            AppValues.gapM,
          ],

          // Wishlist Section (Trade or Both)
          if (selectedType == 1 || selectedType == 2) ...[
            _buildLabel("Wishlist"),
            Container(
              width: double.infinity,
              padding: AppValues.paddingAll,
              decoration: BoxDecoration(
                color: AppColors.greyLight,
                borderRadius: AppValues.borderRadiusM,
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: wishlistTags.isNotEmpty
                    ? Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: wishlistTags.map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.blueLight,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              tag,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppColors.blueText,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          );
                        }).toList(),
                      )
                    : const Text("No wishlist items added"),
              ),
            ),
            AppValues.gapL,
          ],

          // Post Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: onPost,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.royalBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
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
          ),
          AppValues.gapXL,
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.black87,
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(BuildContext context, String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.greyLight,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Widget _buildReadOnlyChip(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.greyLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}
