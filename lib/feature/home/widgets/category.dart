import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class Category extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  
  const Category({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: AnimatedContainer(
        duration: Duration(milliseconds: AppValues.durationNormal),
        padding: const EdgeInsets.symmetric(
          horizontal: AppValues.spacingXS,
          vertical: 6,
        ),
        transform: isSelected 
            ? Matrix4.diagonal3Values(1.1, 1.1, 1.0) 
            : Matrix4.identity(),
        transformAlignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.selectedColor : AppColors.primaryColor,
          borderRadius: AppValues.borderRadiusM,
          boxShadow: [
            if (!isSelected)
              BoxShadow(
                color: AppColors.shadowColor,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}