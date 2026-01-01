import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';

class PhotoPlaceholder extends StatelessWidget {
  const PhotoPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.greyLight,
            borderRadius: AppValues.borderRadiusM,
          ),
        ),
      ),
    );
  }
}
