import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';

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
        const Text(
          "Description & Details",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        AppValues.gapS,
        Container(
          width: double.infinity,
          padding: AppValues.paddingCard,
          decoration: BoxDecoration(
            color: AppColors.greyLight,
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextField(
            controller: descriptionController,
            minLines: 6,
            maxLines: null,
            maxLength: 500,
            onChanged: onChanged,
            decoration: const InputDecoration(
              hintText: "Describe the item, its condition and what buyers should know...",
              hintStyle: TextStyle(color: AppColors.textGrey),
              filled: true,
              fillColor: Colors.transparent,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
        if (showError) ...[
          const SizedBox(height: 4),
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              "Description can't be empty",
              style: TextStyle(
                color: AppColors.errorColor,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
