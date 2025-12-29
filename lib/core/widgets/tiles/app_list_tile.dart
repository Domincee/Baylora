import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';

class AppListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool hideSubtitle;
  final Color? titleColor;

  const AppListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.onTap,
    this.hideSubtitle = false,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: titleColor,
        ),
      ),
      subtitle: (hideSubtitle || subtitle == null)
          ? null
          : Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textGrey,
              ),
            ),
      trailing: Icon(Icons.chevron_right, color: AppColors.textGrey),
    );
  }
}
