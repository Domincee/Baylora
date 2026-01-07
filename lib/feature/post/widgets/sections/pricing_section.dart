import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';

import '../../constants/post_strings.dart';

class PricingSection extends StatelessWidget {
  final TextEditingController priceController;
  final bool showError;
  final ValueChanged<String>? onChanged;

  const PricingSection({
    super.key,
    required this.priceController,
    this.showError = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.greyLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            PostStrings.minimumToBid,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          AppValues.gapS,

          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppValues.spacingM, vertical: AppValues.spacingXXS),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: AppValues.borderRadiusM,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: priceController,
                    onChanged: onChanged,
                    keyboardType: TextInputType.number,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                      prefixText: "₱ ",
                      prefixStyle: TextStyle(
                        fontSize: 16,
                        color: AppColors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      hintText: "0.00",
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      filled: false,
                      fillColor: Colors.transparent,
                    ),
                  ),
                ),
                Row(
                  children: [
                    // REPLACED helper method with the new animated widget
                    _BouncingStepperButton(
                      icon: Icons.remove,
                      onTap: () {
                        double currentValue = double.tryParse(
                            priceController.text.replaceAll(',', '')) ??
                            0.0;

                        double newValueDouble = currentValue - 100;
                        if (newValueDouble < 0) {
                          newValueDouble = 0;
                        }

                        String newValue = newValueDouble.toStringAsFixed(0);
                        priceController.text = newValue;
                        onChanged?.call(newValue);
                      },
                    ),
                    AppValues.gapHXS,
                    // REPLACED helper method with the new animated widget
                    _BouncingStepperButton(
                      icon: Icons.add,
                      onTap: () {
                        double currentValue = double.tryParse(
                            priceController.text.replaceAll(',', '')) ??
                            0.0;
                        String newValue =
                        (currentValue + 100).toStringAsFixed(0);
                        priceController.text = newValue;
                        onChanged?.call(newValue);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (showError) ...[
            AppValues.gapXXS,
            Padding(
              padding: EdgeInsets.only(left: AppValues.spacingXS),
              child: Text(
                PostStrings.requiredErrMess,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.errorColor,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}


class _BouncingStepperButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _BouncingStepperButton({
    required this.icon,
    required this.onTap,
  });

  @override
  State<_BouncingStepperButton> createState() => _BouncingStepperButtonState();
}

class _BouncingStepperButtonState extends State<_BouncingStepperButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 1. Detect touch down -> Shrink
      onTapDown: (_) => setState(() => _isPressed = true),
      // 2. Detect touch up -> Restore size & trigger action
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      // 3. Detect cancel (drag out) -> Restore size only
      onTapCancel: () => setState(() => _isPressed = false),

      // 4. AnimatedScale handles the smooth shrinking effect
      child: AnimatedScale(
        scale: _isPressed ? 0.85 : 1.0, // Shrinks to 85% when pressed
        duration: const Duration(milliseconds: 100), // Fast snappy animation
        curve: Curves.easeInOut,
        child: Container(
          width: AppValues.containerSizeS.width,
          height: AppValues.containerSizeS.height,
          decoration: BoxDecoration(
            color: AppColors.grey300,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Icon(
              widget.icon,
              size: AppValues.iconS,
              color: AppColors.black,
            ),
          ),
        ),
      ),
    );
  }
}