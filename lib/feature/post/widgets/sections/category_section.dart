import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/post/widgets/shared/section_header.dart';

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
        const SectionHeader(title: "Category"),
        AppValues.gapS,
        Container(
          padding: AppValues.paddingCard,
          decoration: BoxDecoration(
            color: AppColors.greyLight,
            borderRadius: AppValues.borderRadiusM,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedCategory,
                  isExpanded: true,
                  hint: Text("Choose...", style: Theme.of(context).textTheme.bodyMedium,),
                  items: [
                    "Electronics",
                    "Clothing",
                    "Books",
                    "Furniture",
                    "Appliances",
                    "Other"
                  ]
                      .map((e) => DropdownMenuItem(value: e,
                      child: Text(e,
                      style: Theme.of(context).textTheme.bodyMedium
                  )))
                      .toList(),
                  onChanged: onChanged,
                ),
              ),
            ],
          ),
        ),
        if (showError) ...[
          const SizedBox(height: 4),
          const Text(
            "Choose a category",
            style: TextStyle(
              color: AppColors.errorColor,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}
