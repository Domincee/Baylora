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
    // 1. Check if it is an SVG file (handling query parameters like ?token=...)
    bool isSvg = false;
    try {
      final uri = Uri.parse(path);
      isSvg = uri.path.toLowerCase().endsWith('.svg');
    } catch (_) {
      // Fallback for asset paths or invalid URIs
      isSvg = path.toLowerCase().endsWith('.svg');
    }
    
    // 2. Check if it is a Network URL (http/https)
    final isNetwork = path.startsWith('http');

    if (isSvg) {
      // --- SVG HANDLING ---
      if (isNetwork) {
        return SvgPicture.network(
          path,
          width: width,
          height: height,
          fit: fit,
          placeholderBuilder: (_) => Container(
            width: width,
            height: height,
            color: Colors.grey[200],
            child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),
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