import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';

import '../../constants/post_strings.dart';

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
          PostStrings.basicInfo,
          style: Theme.of(context).textTheme.titleSmall
        ),
        AppValues.gapS,
        ValueListenableBuilder(
          valueListenable: titleController,
          builder: (context, value, child) {
            return TextField(
              controller: titleController,
              maxLength: 25,
              onChanged: onChanged,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText:  PostStrings.yourSelling,
                hintStyle: const TextStyle(color: AppColors.textGrey,),
                counterText: "",
                suffixText: "${value.text.length}/25",
                suffixStyle: const TextStyle(color: AppColors.textGrey),
                filled: true,
                fillColor: AppColors.greyLight,
                border: OutlineInputBorder(
                  borderRadius: AppValues.borderRadiusCircular,
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: AppValues.borderRadiusCircular,
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: AppValues.borderRadiusCircular,
                  borderSide: BorderSide.none,
                ),
                contentPadding: AppValues.paddingScreen,
              ),
            );
          }
        ),
        if (showError) ...[
          const SizedBox(height: 4),
           Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              PostStrings.requiredErrMess,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.errorColor,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
