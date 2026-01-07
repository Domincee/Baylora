import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';

class ActionBottomSheet extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback onAction;
  final String actionLabel;
  final double heightFactor;
  final TextStyle? titleStyle;

  const ActionBottomSheet({
    super.key,
    required this.title,
    required this.child,
    required this.onAction,
    required this.actionLabel,
    this.heightFactor = 0.5,
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * heightFactor,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: AppValues.spacingS),
              width: AppValues.spacingXXL,
              height: AppValues.spacingXXS,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(AppValues.radiusXXS),
              ),
            ),
          ),
          // Title
          Text(
            title,
            style: titleStyle ??
                Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
          ),
          AppValues.gapM,
          // Body Content
          Expanded(child: child),
          // Button
          Padding(
            padding: AppValues.paddingAll,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.royalBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppValues.radiusCircular),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: AppValues.spacingM),
                ),
                child: Text(
                  actionLabel,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
