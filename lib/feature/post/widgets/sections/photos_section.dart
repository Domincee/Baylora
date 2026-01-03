import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/post/widgets/shared/section_header.dart';
import 'dart:io';

class PhotosSection extends StatelessWidget {
  final List<File> images;
  final VoidCallback onAddPhoto;
  final bool showError;

  const PhotosSection({
    super.key,
    required this.images,
    required this.onAddPhoto,
    this.showError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: "Photos"),
        AppValues.gapS,
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ...images.map(
                (file) => Container(
                  width: 100,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: AppColors.greyLight,
                    borderRadius: AppValues.borderRadiusM,
                    image: DecorationImage(
                      image: FileImage(file),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              if (images.length < 3)
                GestureDetector(
                  onTap: onAddPhoto,
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                      color: AppColors.greyLight,
                      borderRadius: AppValues.borderRadiusM,
                      border: Border.all(
                        color: AppColors.greyMedium,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: const Icon(
                      Icons.add_a_photo,
                      color: AppColors.textGrey,
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (showError) ...[
          const SizedBox(height: 4),
          const Text(
            "You need to upload at least 1 image",
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
