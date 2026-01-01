import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';

class PhotoUploader extends StatelessWidget {
  const PhotoUploader({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.royalBlue.withValues(alpha: 0.05),
            borderRadius: AppValues.borderRadiusM,
            border: Border.all(color: AppColors.royalBlue.withValues(alpha: 0.2)),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.camera_alt, color: AppColors.royalBlue),
              Text("Add photos", style: TextStyle(color: AppColors.royalBlue)),
            ],
          ),
        ),
      ),
    );
  }
}
