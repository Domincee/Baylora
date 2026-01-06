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
                   fontWeight: FontWeight.w600
               )
          ),
          AppValues.gapS,

          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppValues.spacingM, vertical: AppValues.spacing5),
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
                      filled: false, // Ensure no background color when focused
                      fillColor: Colors.transparent,
                    ),
                  ),
                ),
                Row(
                  children: [
                    _buildStepperButton(Icons.remove, () {

                    }),
                    AppValues.gapH8,
                    _buildStepperButton(Icons.add, () {

                    }),
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

  Widget _buildStepperButton(IconData icon, VoidCallback onTap) {
    return Container(
      width: AppValues.container25.width,
      height: AppValues.container25.height,
      decoration: BoxDecoration(
        color: AppColors.grey300,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Icon(
          icon,
          size: AppValues.iconS,
          color: AppColors.black,
        ),
      ),
    );
  }
}
