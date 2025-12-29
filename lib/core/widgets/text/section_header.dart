import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String subTitle;
  
  const SectionHeader({
    super.key,
    required this.title,
    required this.subTitle,
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
            Container(
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
                    "All",
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.blueText,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.blueText,
                    size: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
        AppValues.gapXXS,
        Text(
          subTitle,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.subTextColor,
          ),
        ),
      ],
    );
  }
}
