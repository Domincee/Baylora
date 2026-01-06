import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';

class SettingsTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool hideSubtitle;

  const SettingsTile({
    super.key,
    required this.title,
    this.subtitle,
    this.onTap,
    this.hideSubtitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: AppValues.paddingAll,
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
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
      trailing: Icon(
        Icons.chevron_right,
        size: 16,
        color: AppColors.textGrey,
      ),
    );
  }
}
