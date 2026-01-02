import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/feature/post/widgets/shared/condition_chip.dart';
import 'package:baylora_prjct/feature/post/widgets/shared/section_header.dart';

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
        const SectionHeader(title: "Condition"),
        AppValues.gapS,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ConditionChip(
              label: "New",
              isSelected: selectedCondition == 0,
              onTap: () => onConditionChanged(0),
            ),
            ConditionChip(
              label: "Used",
              isSelected: selectedCondition == 1,
              onTap: () => onConditionChanged(1),
            ),
            ConditionChip(
              label: "Fair",
              isSelected: selectedCondition == 3,
              onTap: () => onConditionChanged(3),
            ),
            ConditionChip(
              label: "Broken",
              isSelected: selectedCondition == 2,
              onTap: () => onConditionChanged(2),
            ),
          ],
        ),
      ],
    );
  }
}
