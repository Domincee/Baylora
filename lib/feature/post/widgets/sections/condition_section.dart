import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';

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
              child: _AnimatedConditionChip(
                label: "New",
                isSelected: selectedCondition == 0,
                onTap: () => onConditionChanged(0),
              ),
            ),
            AppValues.gapH8,
            Expanded(
              child: _AnimatedConditionChip(
                label: "Used",
                isSelected: selectedCondition == 1,
                onTap: () => onConditionChanged(1),
              ),
            ),
            AppValues.gapH8,
            Expanded(
              child: _AnimatedConditionChip(
                label: "Fair",
                isSelected: selectedCondition == 3,
                onTap: () => onConditionChanged(3),
              ),
            ),
            AppValues.gapH8,
            Expanded(
              child: _AnimatedConditionChip(
                label: "Broken",
                isSelected: selectedCondition == 2,
                onTap: () => onConditionChanged(2),
              ),
            ),
          ],
        ),
      ],
    );
  }
}


class _AnimatedConditionChip extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _AnimatedConditionChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_AnimatedConditionChip> createState() => _AnimatedConditionChipState();
}

class _AnimatedConditionChipState extends State<_AnimatedConditionChip> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),

      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },

      onTapCancel: () => setState(() => _isPressed = false),

      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0, // Subtle shrink to 95%
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: AnimatedContainer(
          // 5. Color Animation (Smooth fade)
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          height: AppValues.spacing36,
          decoration: BoxDecoration(
            color: widget.isSelected ? AppColors.royalBlue : AppColors.greyLight,
            borderRadius: AppValues.borderRadiusL,
          ),
          alignment: Alignment.center,
          child: AnimatedDefaultTextStyle(
            // 6. Text Style Animation
            duration: const Duration(milliseconds: 200),
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: widget.isSelected ? AppColors.white : AppColors.textGrey,
              fontWeight: FontWeight.w500, // Optional: ensure consistent weight
            ),
            child: Text(widget.label),
          ),
        ),
      ),
    );
  }
}