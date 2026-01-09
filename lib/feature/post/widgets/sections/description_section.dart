import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';

import '../../constants/post_strings.dart';

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
         Text(
          PostStrings.descAndDetails,
             style: Theme.of(context).textTheme.titleSmall
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
              hintText: PostStrings.hintDescription
              ,
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
          AppValues.gapXXS,

           Padding(
            padding: EdgeInsets.only(left: AppValues.spacingXS),
            child: Text(
              PostStrings.descriptionErrMess,
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
