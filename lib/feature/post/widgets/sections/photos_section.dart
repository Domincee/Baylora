import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'dart:io';

class PhotosSection extends StatelessWidget {
  final List<File> images;
  final VoidCallback onAddPhoto;
  final ValueChanged<File>? onRemovePhoto;
  final bool showError;

  const PhotosSection({
    super.key,
    required this.images,
    required this.onAddPhoto,
    this.onRemovePhoto,
    this.showError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Photos",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "${images.length}/3",
              style: const TextStyle(
                color: AppColors.textGrey,
                fontSize: 14,
              ),
            ),
          ],
        ),
        AppValues.gapS,
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              if (images.length < 3)
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: GestureDetector(
                    onTap: onAddPhoto,
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        color: AppColors.greyLight,
                        borderRadius: AppValues.borderRadiusM,
                      ),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.blueLight,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt, 
                            color: AppColors.royalBlue, 
                            size: 24
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ...images.map(
                (file) => Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          color: AppColors.greyLight,
                          borderRadius: AppValues.borderRadiusM,
                          image: DecorationImage(
                            image: FileImage(file),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () => onRemovePhoto?.call(file),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 16,
                              color: AppColors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
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
