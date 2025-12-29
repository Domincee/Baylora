import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_strings.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppValues.searchBarHeight,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: AppValues.borderRadiusL,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        style: Theme.of(context).textTheme.bodySmall,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.textLblG,
            size: AppValues.iconM,
          ),
          hintText: AppStrings.searchText,
          hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textLblG,
          ),
          border: InputBorder.none,
          isDense: true,
        ),
      ),
    );
  }
}