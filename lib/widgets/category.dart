import 'package:baylora_prjct/theme/app_colors.dart';
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
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        margin: const EdgeInsets.only(right: 10), 

        decoration: BoxDecoration(
        
          color: isSelected ?  AppColors.selectedColor : AppColors.primaryColor, 
          borderRadius: BorderRadius.circular(30),
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
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}