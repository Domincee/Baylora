import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/post/widgets/shared/photo_placeholder.dart';
import 'package:baylora_prjct/feature/post/widgets/shared/photo_uploader.dart';
import 'package:baylora_prjct/feature/post/widgets/shared/section_header.dart';
import 'dart:io';

class PhotosSection extends StatelessWidget {
  final VoidCallback onAddPhoto;
  final List<File> images;

  const PhotosSection({
    super.key,
    required this.onAddPhoto,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: "Photos", trailing: "${images.length}/3"),
        AppValues.gapS,
        Row(
          children: [
            if (images.isEmpty) ...[
              PhotoUploader(onTap: () {
                debugPrint("Add Photo Clicked");
                onAddPhoto();
              }),
              AppValues.gapHS,
              const PhotoPlaceholder(),
              AppValues.gapHS,
              const PhotoPlaceholder(),
            ] else if (images.length == 1) ...[
              _buildImageSlot(images[0]),
              AppValues.gapHS,
              PhotoUploader(onTap: () {
                debugPrint("Add Photo Clicked");
                onAddPhoto();
              }),
              AppValues.gapHS,
              const PhotoPlaceholder(),
            ] else if (images.length == 2) ...[
              _buildImageSlot(images[0]),
              AppValues.gapHS,
              _buildImageSlot(images[1]),
              AppValues.gapHS,
              PhotoUploader(onTap: () {
                debugPrint("Add Photo Clicked");
                onAddPhoto();
              }),
            ] else ...[
              _buildImageSlot(images[0]),
              AppValues.gapHS,
              _buildImageSlot(images[1]),
              AppValues.gapHS,
              _buildImageSlot(images[2]),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildImageSlot(File file) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: AppValues.borderRadiusM,
            border: Border.all(color: AppColors.greyMedium),
          ),
          child: ClipRRect(
            borderRadius: AppValues.borderRadiusM,
            child: Image.file(
              file,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
