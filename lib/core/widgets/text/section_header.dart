import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String subTitle;
  final VoidCallback? onSeeAll;
  final bool showSeeAll;

  const SectionHeader({
    super.key,
    required this.title,
    required this.subTitle,
    this.onSeeAll,
    this.showSeeAll = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (showSeeAll)
              GestureDetector(
                onTap: onSeeAll,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppValues.spacingS,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.blueLight,
                    borderRadius: AppValues.borderRadiusXL,
                  ),
                  child: Row(
                    children: [
                      Text(
                        "See All",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.blueText,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.blueText,
                        size: 12,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        AppValues.gapXXS,
        Text(
          subTitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.subTextColor,
          ),
        ),
      ],
    );
  }
}
