import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';

class ListingStep3 extends StatelessWidget {
  final int selectedType;
  final String title;
  final String price;
  final String description;
  final int selectedCondition;
  final List<String> wishlistTags;
  final VoidCallback onPublish;

  const ListingStep3({
    super.key,
    required this.selectedType,
    required this.title,
    required this.price,
    required this.description,
    required this.selectedCondition,
    required this.wishlistTags,
    required this.onPublish,
  });

  String _getConditionLabel(int condition) {
    switch (condition) {
      case 0:
        return "New";
      case 1:
        return "Used";
      case 2:
        return "Broken";
      case 3:
        return "Fair";
      default:
        return "Unknown";
    }
  }

  String _getTypeLabel(int type) {
    switch (type) {
      case 0:
        return "Sell";
      case 1:
        return "Trade";
      case 2:
        return "Sell & Trade";
      default:
        return "Unknown";
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSellOrMix = selectedType == 0 || selectedType == 2;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: AppValues.paddingH.copyWith(bottom: AppValues.spacingXXL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header (Images Placeholder)
                SizedBox(
                  height: 100,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    separatorBuilder: (_, __) => AppValues.gapS,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 100,
                        decoration: BoxDecoration(
                          color: AppColors.greyLight,
                          borderRadius: AppValues.borderRadiusM,
                        ),
                        child: const Icon(Icons.image, color: Colors.grey),
                      );
                    },
                  ),
                ),
                AppValues.gapL,

                // Main Info: Title
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                AppValues.gapS,

                // Price
                if (isSellOrMix)
                  Text(
                    price.isEmpty ? "₱ 0.00" : "₱ $price",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.royalBlue,
                          fontWeight: FontWeight.bold,
                        ),
                  )
                else
                  Text(
                    "Trade Only",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.royalBlue,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                AppValues.gapM,

                // Badges Row
                Row(
                  children: [
                    _buildBadge(context, _getConditionLabel(selectedCondition)),
                    AppValues.gapS,
                    _buildBadge(context, _getTypeLabel(selectedType)),
                  ],
                ),
                AppValues.gapL,

                // Exchange Preferences (Logic)
                if (selectedType == 1 || selectedType == 2) ...[
                  Text(
                    "Looking For:",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  AppValues.gapS,
                  if (wishlistTags.isEmpty)
                    Text(
                      "Open to any trade",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textGrey,
                          ),
                    )
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: wishlistTags
                          .map(
                            (tag) => Chip(
                              label: Text(
                                tag,
                                style: const TextStyle(
                                  color: AppColors.royalBlue,
                                  fontSize: 12,
                                ),
                              ),
                              backgroundColor:
                                  AppColors.royalBlue.withValues(alpha: 0.1),
                              side: BorderSide(
                                color: AppColors.royalBlue.withValues(alpha: 0.3),
                                width: 1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: AppValues.borderRadiusCircular,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  AppValues.gapL,
                ],

                // Description
                Text(
                  "Description",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                AppValues.gapS,
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),

        // Bottom Action Button
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onPublish,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.royalBlue,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: AppValues.borderRadiusM,
                ),
              ),
              child: const Text(
                "Publish Listing",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(BuildContext context, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.greyLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
