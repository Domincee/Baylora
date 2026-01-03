import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/post/widgets/shared/section_header.dart';

class BasicInfoSection extends StatelessWidget {
  final TextEditingController titleController;
  final bool showError;
  final ValueChanged<String>? onChanged;

  const BasicInfoSection({
    super.key,
    required this.titleController,
    this.showError = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: "Title"),
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
                controller: titleController,
                maxLength: 25,
                onChanged: onChanged,
                decoration: const InputDecoration(
                  hintText: "e.g. iPhone 13 Pro Max",
                  counterText: "",
                  border: InputBorder.none,
                ),
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
