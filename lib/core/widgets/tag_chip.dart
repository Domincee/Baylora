import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';

class TagChip extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final Border? border;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final TextStyle? textStyle;

  const TagChip({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    this.border,
    this.padding,
    this.borderRadius,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ??
          const EdgeInsets.symmetric(
              horizontal: AppValues.spacingS, vertical: AppValues.spacingXS),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius ?? AppValues.radiusXL),
        border: border,
      ),
      child: Text(
        label,
        style: textStyle ??
            Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
      ),
    );
  }
}
