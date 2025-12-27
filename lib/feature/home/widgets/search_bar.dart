import 'package:baylora_prjct/core/constant/app_strings.dart';
import 'package:baylora_prjct/core/constant/app_values_widget.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomeSearchBar extends StatelessWidget {
  const CustomeSearchBar({
    super.key,
  });
@override
Widget build(BuildContext context) {
  return Container(
    height: AppValuesWidget.searchBarSize, 
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: AppColors.primaryColor,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: AppColors.shadowColor,
          blurRadius: 0.5,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: TextField(
      style: Theme.of(context).textTheme.bodySmall,
      textAlignVertical: TextAlignVertical.center, 
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search, color: AppColors.textLblG, size: AppValuesWidget.iconDefaultSize,),
        hintText: AppStrings.searchText,
        hintStyle: const TextStyle(color: AppColors.textLblG),
        border: InputBorder.none,
        
        isDense: true, 
      ),
    ),
  );
}
}