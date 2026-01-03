import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/post/widgets/shared/section_header.dart';

class DescriptionSection extends StatelessWidget {
  final TextEditingController descriptionController;
  final bool showError;
  final ValueChanged<String>? onChanged;

  const DescriptionSection({
    super.key,
    required this.descriptionController,
    this.showError = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: "Description"),
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
              TextField(
                controller: descriptionController,
                maxLines: 4,
                maxLength: 120,
                onChanged: onChanged,
                decoration: const InputDecoration(
                  hintText: "Enter description",
                  border: InputBorder.none,
                ),
              ),
            ],
          ),
        ),
        if (showError) ...[
          const SizedBox(height: 4),
          const Text(
            "Description can't be empty",
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
