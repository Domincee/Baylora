import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants/post_strings.dart';

class PhotosSection extends StatelessWidget {
  final List<XFile> images; // Changed to XFile
  final VoidCallback onAddPhoto;
  final ValueChanged<XFile>? onRemovePhoto; // Changed to XFile
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
              PostStrings.photos,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                ),
            ),
            AppValues.gapHS,
            Text(
              "${images.length}/3",
             style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: AppColors.black,
               fontWeight: FontWeight.w600
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
                  padding: EdgeInsets.only(right: AppValues.spacingM),
                  child: GestureDetector(
                    onTap: onAddPhoto,
                    child: Container(
                      height:AppValues.containerSizeImage.height,
                      width: AppValues.containerSizeImage.width
                      ,
                      decoration: BoxDecoration(
                        color: AppColors.greyLight,
                        borderRadius: AppValues.borderRadiusM,
                      ),
                      child: Center(
                        child: Container(
                          padding: AppValues.paddingCard,

                          decoration: BoxDecoration(
                            color: AppColors.blueLight,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt, 
                            color: AppColors.royalBlue, 
                            size: AppValues.iconM,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ...images.map(
                (xFile) => Padding(
                  padding:  EdgeInsets.only(right: AppValues.spacingM),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                              height:AppValues.containerSizeImage.height,
                              width: AppValues.containerSizeImage.width,
                        decoration: BoxDecoration(
                          color: AppColors.greyLight,
                          borderRadius: AppValues.borderRadiusM,
                          image: DecorationImage(
                            image: kIsWeb 
                                ? NetworkImage(xFile.path) 
                                : FileImage(File(xFile.path)) as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () => onRemovePhoto?.call(xFile),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              size: AppValues.iconS,
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
          AppValues.gapXS,
           Text(
             PostStrings.imageErrMess,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.errorColor,
            ),
          ),
        ],
      ],
    );
  }
}
