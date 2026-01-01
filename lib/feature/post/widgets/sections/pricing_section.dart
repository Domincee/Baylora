import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/post/widgets/shared/section_header.dart';

class PricingSection extends StatelessWidget {
  final TextEditingController priceController;

  const PricingSection({
    super.key,
    required this.priceController,
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
              const Text("Asking Price"),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(
                  prefixText: "₱ ",
                  hintText: "Enter asking price",
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
