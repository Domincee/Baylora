import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';

class ListingAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int currentStep;
  final String step2Title;
  final bool isNextEnabled;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final VoidCallback onClose;

  const ListingAppBar({
    super.key,
    required this.currentStep,
    required this.step2Title,
    required this.isNextEnabled,
    required this.onNext,
    required this.onBack,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    if (currentStep == 0) {
      return AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.black),
          onPressed: onClose,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppValues.spacingM),
            child: TextButton(
              onPressed: isNextEnabled ? onNext : null,
              child: Text(
                "Next",
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: isNextEnabled ? AppColors.royalBlue : Colors.grey,
                    ),
              ),
            ),
          ),
        ],
      );
    } else {
      final isStep3 = currentStep == 2;
      return AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.black),
          onPressed: onBack,
        ),
        centerTitle: true,
        title: Text(
          isStep3 ? "Review" : step2Title,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold, color: AppColors.black),
        ),
        actions: [
          Center(
            child: Text(
              isStep3 ? "3/3" : "2/3",
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: AppColors.subTextColor),
            ),
          ),
          AppValues.gapS,
          if (!isStep3) ...[
            TextButton(
              onPressed: onNext,
              child: Text(
                "Next",
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(color: AppColors.royalBlue),
              ),
            ),
            AppValues.gapS,
          ],
        ],
      );
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
