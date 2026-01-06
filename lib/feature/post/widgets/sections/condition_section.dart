import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/post/widgets/shared/condition_chip.dart';

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
          "Condition",
             style: Theme.of(context).textTheme.bodyLarge,
        ),
        AppValues.gapS,
        Row(
          children: [
            Expanded(
              child: _buildChip(context, "New", 0),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildChip(context, "Used", 1),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildChip(context, "Fair", 3),
            ),
            const SizedBox(width: 8),
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
        height: 36,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.selectedColor : AppColors.greyLight,
          borderRadius: BorderRadius.circular(18),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? AppColors.white : AppColors.textGrey,
          ),
        ),
      ),
    );
  }
}
