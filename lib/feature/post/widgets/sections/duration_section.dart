import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
            Expanded(
              child: Text(
                "Set Duration",
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
                activeColor: AppColors.white,
                activeTrackColor: AppColors.royalBlue,
                inactiveThumbColor: AppColors.white,
                inactiveTrackColor: AppColors.grey400,
                trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.greyLight  ,
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          child: isDurationEnabled
              ? Row(
                  children: [
                    _buildControlIcon(Icons.remove, onDecrement),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(18),
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
                    const SizedBox(width: 8),
                    const Text(
                      "hr",
                      style: TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildControlIcon(Icons.add, onIncrement),
                  ],
                )
              : Center(
                  child: Container(
                    height: 36,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    alignment: Alignment.center,
                    child:  Text(
                      "no limit",
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
        size: 18,
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
