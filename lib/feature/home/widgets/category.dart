import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// A responsive category filter container that wraps items, aligned to the left.
class CategoryFilter extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onSelect;

  const CategoryFilter({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    // Wrapped in SizedBox with double.infinity to ensure the container takes full width
    // This forces the Wrap to align to the start (left) even if the parent Column centers its children.
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppValues.spacingM),
        child: Wrap(
          spacing: AppValues.spacingXS,
          runSpacing: AppValues.spacingXS,
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.start,
          children: categories.map((category) {
            final isSelected = category == selectedCategory;

            return _CategoryChip(
              label: category,

              isSelected: isSelected,
              onTap: () => onSelect(category),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: AppValues.durationNormal),
        padding: const EdgeInsets.symmetric(
          horizontal: AppValues.spacingM,
          vertical: AppValues.spacingXS,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.selectedColor : AppColors.primaryColor,
          borderRadius: AppValues.borderRadiusCircular,
          boxShadow: [
            if (!isSelected)
                const BoxShadow(
                color: AppColors.shadowColor,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
          ],
        ),
        transform: isSelected 
            ? Matrix4.diagonal3Values(1.05, 1.05, 1.0) 
            : Matrix4.identity(),
        transformAlignment: Alignment.center,
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
