import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/post/widgets/shared/condition_chip.dart';

import '../../constants/post_strings.dart';

class ConditionSection extends StatelessWidget {
  final int selectedCondition;
  final ValueChanged<int> onConditionChanged;

  const ConditionSection({
    super.key,
    required this.selectedCondition,
    required this.onConditionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text(
         PostStrings.condition,
             style: Theme.of(context).textTheme.bodyLarge,
        ),
        AppValues.gapS,
        Row(
          children: [
            Expanded(
              child: _buildChip(context, "New", 0),
            ),
           AppValues.gapH8,
            Expanded(
              child: _buildChip(context, "Used", 1),
            ),
            AppValues.gapH8,

            Expanded(
              child: _buildChip(context, "Fair", 3),
            ),

            AppValues.gapH8,
            Expanded(
              child: _buildChip(context, "Broken", 2),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChip(BuildContext context, String label, int index) {
    final bool isSelected = selectedCondition == index;
    return GestureDetector(
      onTap: () => onConditionChanged(index),
      child: Container(
        height: AppValues.spacing36,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.selectedColor : AppColors.greyLight,
          borderRadius: AppValues.borderRadiusL,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: isSelected ? AppColors.white : AppColors.textGrey,
          ),
        ),
      ),
    );
  }
}
