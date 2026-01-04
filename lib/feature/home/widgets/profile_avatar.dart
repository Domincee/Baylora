import 'package:baylora_prjct/core/assets/images.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String imageUrl;
  final double size;

  const ProfileAvatar({
    super.key,
    required this.imageUrl,
    this.size = 32.0,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Determine Image Source
    // If empty or doesn't start with http, treat as invalid/local placeholder needed
    final bool isNetwork = imageUrl.isNotEmpty && imageUrl.startsWith('http');
    
    // 2. Resolve the final image provider
    final ImageProvider imageProvider;
    if (isNetwork) {
      imageProvider = NetworkImage(imageUrl);
    } else {
      // If imageUrl is empty, use default. Otherwise, assume it's a local asset path (rare but possible)
      // or just fallback to default.
      final assetPath = imageUrl.isNotEmpty ? imageUrl : Images.defaultAvatar;
      imageProvider = AssetImage(assetPath);
    }

    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        color: AppColors.lavenderBlue,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.royalBlue, width: 2.0),
      ),
      child: ClipOval(
        child: Image(
          image: imageProvider,
          width: size,
          height: size,
          fit: BoxFit.cover,
          // Loading Builder only works for NetworkImage usually, but Image widget supports it
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: size,
              height: size,
              color: AppColors.greyLight,
              child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2)),
            );
          },
          // Error Builder
          errorBuilder: (context, error, stackTrace) {
            // Fallback to default asset if network fails
            return Image.asset(
              Images.defaultAvatar,
              width: size,
              height: size,
              fit: BoxFit.cover,
            );
          },
        ),
      ),
    );
  }
}
