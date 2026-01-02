import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';

class DurationSection extends StatelessWidget {
  final bool isDurationEnabled;
  final TextEditingController durationController;
  final ValueChanged<bool> onToggleDuration;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const DurationSection({
    super.key,
    required this.isDurationEnabled,
    required this.durationController,
    required this.onToggleDuration,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Duration",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Transform.scale(
              scale: 0.7,
              child: Switch(
                value: isDurationEnabled,
                onChanged: onToggleDuration,
              ),
            ),
          ],
        ),
        AppValues.gapXS,
        if (isDurationEnabled)
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.greyMedium),
              borderRadius: AppValues.borderRadiusS,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: onDecrement,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.remove, size: 16),
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: durationController,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                      suffixText: "hr",
                    ),
                  ),
                ),
                InkWell(
                  onTap: onIncrement,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.add, size: 16),
                  ),
                ),
              ],
            ),
          )
        else
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.greyLight,
              borderRadius: AppValues.borderRadiusS,
            ),
            child: Text(
              "No limit",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textGrey,
                  ),
            ),
          ),
      ],
    );
  }
}
