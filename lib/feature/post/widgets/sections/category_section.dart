import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';

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
        // Match the height of the DurationSection header (which has a Switch)
        // Switch is usually around 40px, so we wrap Text in a Container with height 40
        Container(
          height: 40,
          alignment: Alignment.centerLeft,
          child: Text(
            "Category",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 40, // Match duration section height
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: AppColors.greyLight,
            borderRadius: BorderRadius.circular(30),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedCategory,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.grey600),
              hint: Text(
                "Select Category",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textGrey,
                ),
              ),
              items: [
                "Electronics",
                "Clothing",
                "Books",
                "Furniture",
                "Appliances",
                "Other"
              ]
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
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              "Choose a category",
              style: TextStyle(
                color: AppColors.errorColor,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
