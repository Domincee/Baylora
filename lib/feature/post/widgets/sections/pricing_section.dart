import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/post/widgets/shared/section_header.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: "Pricing"),
        AppValues.gapS,
        Container(
          padding: AppValues.paddingCard,
          decoration: BoxDecoration(
            color: AppColors.greyLight,
            borderRadius: AppValues.borderRadiusM,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: priceController,
                onChanged: onChanged,
                decoration: const InputDecoration(
                  prefixText: "₱ ",
                  hintText: "Enter asking price",
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        if (showError) ...[
          const SizedBox(height: 4),
          const Text(
            "This is required",
            style: TextStyle(
              color: AppColors.errorColor,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}
