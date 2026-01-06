import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';

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
         Text(
          "Basic info",
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.w600
          )
        ),
        AppValues.gapS,
        ValueListenableBuilder(
          valueListenable: titleController,
          builder: (context, value, child) {
            return TextField(
              controller: titleController,
              maxLength: 25,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: "What are you selling?",
                hintStyle: const TextStyle(color: AppColors.textGrey),
                counterText: "",
                suffixText: "${value.text.length}/25",
                suffixStyle: const TextStyle(color: AppColors.textGrey),
                filled: true,
                fillColor: AppColors.greyLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
            );
          }
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
    );
  }
}
