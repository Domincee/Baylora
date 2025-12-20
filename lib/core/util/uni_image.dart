import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UniversalImage extends StatelessWidget {
  final String path;
  final BoxFit fit;
  final double? width;
  final double? height;

  const UniversalImage({
    super.key,
    required this.path,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {

    final isSvg = path.toLowerCase().endsWith('.svg');
    

    final isNetwork = path.startsWith('http');

    if (isSvg) {
      
      if (isNetwork) {
        return SvgPicture.network(
          path,
          width: width,
          height: height,
          fit: fit,
          placeholderBuilder: (_) => const Center(child: CircularProgressIndicator()),
        );
      } else {
        return SvgPicture.asset(
          path,
          width: width,
          height: height,
          fit: fit,
        );
      }
    } else {
      // --- PNG/JPG/RASTER HANDLING ---
      if (isNetwork) {
        return Image.network(
          path,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
             // Fallback if network image fails
            return Container(
              color: Colors.grey[200],
              width: width,
              height: height,
              child: const Icon(Icons.broken_image, color: Colors.grey),
            );
          },
        );
      } else {
        return Image.asset(
          path,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            return Container(color: Colors.grey);
          },
        );
      }
    }
  }
}