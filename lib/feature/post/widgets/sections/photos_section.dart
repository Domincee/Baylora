import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/feature/post/widgets/shared/photo_placeholder.dart';
import 'package:baylora_prjct/feature/post/widgets/shared/photo_uploader.dart';
import 'package:baylora_prjct/feature/post/widgets/shared/section_header.dart';

class PhotosSection extends StatelessWidget {
  const PhotosSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: "Photos", trailing: "2/3"),
        AppValues.gapS,
        const Row(
          children: [
            PhotoUploader(),
            AppValues.gapHS,
            PhotoPlaceholder(),
            AppValues.gapHS,
            PhotoPlaceholder(),
          ],
        ),
      ],
    );
  }
}
