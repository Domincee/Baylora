import 'package:baylora_prjct/core/constant/app_values_widget.dart';
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
  }) : super();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: AnimatedContainer(
        duration: const Duration(milliseconds: AppValuesWidget.animDuration),
        padding: AppValuesWidget.boxSizeCat,
        margin: const EdgeInsets.only(right: 10), 
transform: isSelected 
    ? Matrix4.diagonal3Values(1.1, 1.1, 1.0) 
    : Matrix4.identity(),     // 2. IMPORTANT: Scale from the center, otherwise it grows from the top-left
      transformAlignment: Alignment.center,

        decoration: 
        BoxDecoration(
          color: isSelected ?  AppColors.selectedColor : AppColors.primaryColor, 
          borderRadius: BorderRadius.all(Radius.circular(AppValuesWidget.borderRadius)),
          boxShadow: [
       
            if (!isSelected)
              BoxShadow(
                color: AppColors.shadowColor,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
            color: isSelected ? Colors.white : Colors.black87),
        
        ),
      ),
    );
  }
}