import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? trailing;

  const SectionHeader({
    super.key,
    required this.title,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleSmall),
        if (trailing != null)
          Text(
            trailing!,
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(color: AppColors.textGrey),
          ),
      ],
    );
  }
}
