import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';

class OptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final bool isRecommended;
  final VoidCallback onTap;

  const OptionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.isRecommended = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppValues.paddingCard,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.royalBlue.withValues(alpha: 0.05)
              : AppColors.white,
          border: Border.all(
            color: isSelected ? AppColors.royalBlue : AppColors.greyMedium,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: AppValues.borderRadiusM,
        ),
        child: Row(children: [
          Container(
              padding: AppValues.paddingSmall,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.royalBlue : AppColors.greyLight,
                shape: BoxShape.circle,
              ),
              child: Icon(icon,
                  color: isSelected ? AppColors.white : AppColors.textDarkGrey,
                  size: AppValues.iconM)),
          AppValues.gapHM,
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Row(children: [
                  Text(title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: isSelected
                              ? AppColors.royalBlue
                              : AppColors.black)),
                  if (isRecommended) ...[
                    AppValues.gapHXS,
                    Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                            color: AppColors.recommendedColor.withValues(alpha: 0.1),
                            borderRadius: AppValues.borderRadiusS),
                        child: Text("Recommended",
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.recommendedColor)))
                  ]
                ]),
                AppValues.gapXXS,
                Text(subtitle,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(color: AppColors.textDarkGrey))
              ])),
          Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: isSelected
                          ? AppColors.royalBlue
                          : AppColors.greyDisabled,
                      width: 2)),
              child: isSelected
                  ? Center(
                      child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                              color: AppColors.royalBlue,
                              shape: BoxShape.circle)))
                  : null)
        ]),
      ),
    );
  }
}
