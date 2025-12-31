import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';

class AuthCheckbox extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;
  final VoidCallback? onLabelTap;
  final bool showError;
  final String? linkText;

  const AuthCheckbox({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.onLabelTap,
    this.showError = false,
    this.linkText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.royalBlue,
            side: BorderSide(
              color: showError ? AppColors.errorColor : AppColors.greyMedium,
              width: showError ? 2 : 1,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: GestureDetector(
            onTap: onLabelTap,
            child: RichText(
              text: TextSpan(
                text: label,
                style: Theme.of(context).textTheme.bodySmall,
                children: [
                  if (linkText != null)
                    TextSpan(
                      text: linkText,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.highLightTextColor,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
