import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';

import '../../constants/post_strings.dart';

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
            Expanded(
              child: Text(
               PostStrings.setDuration,
                style: Theme.of(context).textTheme.bodyLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Transform.scale(
              scale: 0.8,
              child: Switch(
                value: isDurationEnabled,
                onChanged: onToggleDuration,
                activeThumbColor: AppColors.white,
                activeTrackColor: AppColors.royalBlue,
                inactiveThumbColor: AppColors.white,
                inactiveTrackColor: AppColors.grey400,
                trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
              ),
            ),
          ],
        ),
       AppValues.gapS,

        Container(
          height: AppValues.spacingXXL,
          decoration: BoxDecoration(
            color: AppColors.greyLight  ,
            borderRadius: AppValues.borderRadiusCircular,
          ),

          padding: const EdgeInsets.symmetric(horizontal: AppValues.spacingS, vertical: AppValues.spacingXXS),
          child: isDurationEnabled
              ? Row(
                  children: [
                    _buildControlIcon(Icons.remove, onDecrement),
                    AppValues.gapXS,
                    Expanded(

                      child: Container(
                        height: AppValues.spacingXL,

                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: AppValues.borderRadiusM,

                        ),
                        alignment: Alignment.center,
                        child: TextField(
                          controller: durationController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,

                            _MaxValueFormatter(24),
                          ],
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isDense: false,

                            contentPadding: EdgeInsets.zero,
                          ),
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: AppColors.black,
                          )
                        ),
                      ),
                    ),

                    AppValues.gapXS,

                     Text(
                      "hr",
                      style:Theme.of(context).textTheme.bodyMedium
                    ),

                    AppValues.gapXS,

                    _buildControlIcon(Icons.add, onIncrement),
                  ],
                )
              : Center(
                  child: Container(

                    height: AppValues.spacingXL,
                    width: double.infinity,
                    margin: AppValues.paddingHL,
                    decoration: BoxDecoration(

                      color: AppColors.white,
                      borderRadius: AppValues.borderRadiusXL,
                    ),

                    alignment: Alignment.center,
                    child:  Text(
                      PostStrings.noLimit,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.subTextColor,
                      )
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildControlIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        icon,
        color: AppColors.grey600,
        size: AppValues.iconS,
      ),
    );
  }
}

class _MaxValueFormatter extends TextInputFormatter {
  final int maxValue;

  _MaxValueFormatter(this.maxValue);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    final int? value = int.tryParse(newValue.text);
    if (value == null) {
      return oldValue;
    }
    if (value > maxValue) {
      return TextEditingValue(
        text: maxValue.toString(),
        selection: TextSelection.collapsed(offset: maxValue.toString().length),
      );
    }
    return newValue;
  }
}
