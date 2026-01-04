import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/core/util/uni_image.dart';

class ImageCarouselHeader extends StatefulWidget {
  final List<dynamic> images;

  const ImageCarouselHeader({super.key, required this.images});

  @override
  State<ImageCarouselHeader> createState() => _ImageCarouselHeaderState();
}

class _ImageCarouselHeaderState extends State<ImageCarouselHeader> {
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return Container(
        height: 300,
        width: double.infinity,
        color: AppColors.greyLight,
        child: const Center(
          child: Icon(Icons.image_not_supported, size: 50, color: AppColors.textGrey),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 300,
          width: double.infinity,
          child: PageView.builder(
            itemCount: widget.images.length,
            onPageChanged: (index) => setState(() => _currentImageIndex = index),
            itemBuilder: (context, index) {
              return UniversalImage(
                path: widget.images[index],
                fit: BoxFit.cover,
                width: double.infinity,
              );
            },
          ),
        ),
        if (widget.images.length > 1) ...[
          AppValues.gapS,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.images.length, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentImageIndex == index ? 20 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentImageIndex == index
                      ? AppColors.royalBlue
                      : AppColors.grey300,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}
