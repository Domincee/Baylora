import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';

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
            "Minimum to Bid",
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.bold
            ),
          ),
          AppValues.gapS,

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: priceController,
                    onChanged: onChanged,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                      prefixText: "₱ ",
                      prefixStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
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
                    const SizedBox(width: 8),
                    _buildStepperButton(Icons.add, () {

                    }),
                  ],
                ),
              ],
            ),
          ),
          if (showError) ...[
            const SizedBox(height: 4),
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(
                "This is required",
                style: TextStyle(
                  color: AppColors.errorColor,
                  fontSize: 12,
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
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: AppColors.grey300,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Icon(
          icon,
          size: 16,
          color: AppColors.black,
        ),
      ),
    );
  }
}
