import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';

import '../../../../core/constant/listing_constants.dart';
import '../../constants/post_strings.dart';

class CategorySection extends StatelessWidget {
  final String? selectedCategory;
  final ValueChanged<String?> onChanged;
  final bool showError;

  const CategorySection({
    super.key,
    required this.selectedCategory,
    required this.onChanged,
    this.showError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: AppValues.spacingXXL,
          alignment: Alignment.centerLeft,
          child: Text(
            PostStrings.category,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),

        AppValues.gapS,

        Container(
          height: AppValues.spacingXXL,

          padding: AppValues.paddingHL,

          decoration: BoxDecoration(
            color: AppColors.greyLight,
            borderRadius: AppValues.borderRadiusCircular,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedCategory,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.grey600),
              hint: Text(
                PostStrings.selCategory,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textGrey,
                ),
              ),
              items: ListingConstants.categories

                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(
                          e,
                          style:  Theme.of(context).textTheme.bodyMedium,
                        ),
                      ))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
        if (showError) ...[
          const SizedBox(height: 4),
           Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              PostStrings.chooseCatErrMess,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.errorColor,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
