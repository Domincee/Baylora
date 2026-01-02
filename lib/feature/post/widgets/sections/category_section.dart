import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/post/constants/listing_constants.dart';
import 'package:baylora_prjct/feature/post/widgets/shared/section_header.dart';

class CategorySection extends StatelessWidget {
  final String? selectedCategory;
  final ValueChanged<String?> onChanged;

  const CategorySection({
    super.key,
    required this.selectedCategory,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: "Category"),
        AppValues.gapS,
        DropdownButtonFormField<String>(
          initialValue: selectedCategory,
          hint:  Text("Select", style: Theme.of(context).textTheme.bodyMedium),
          items: ListingConstants.categories
              .map((c) => DropdownMenuItem(
                  value: c,
                  child: Text(c,
                      style: Theme.of(context).textTheme.bodyMedium)))
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.greyLight,
            border: OutlineInputBorder(
              borderRadius: AppValues.borderRadiusM,
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
          icon: const Icon(Icons.arrow_drop_down, color: AppColors.textGrey),
        ),
      ],
    );
  }
}
