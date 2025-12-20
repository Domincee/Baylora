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
    // Default Avatar Widget
    final Widget defaultAvatarWidget = SizedBox(
      width: size,
      height: size,
      child: const Icon(Icons.person, color: AppColors.royalBlue),
    );

    // If empty, show default immediately
    if (imageUrl.isEmpty || !imageUrl.startsWith('http')) {
      return _buildCircle(defaultAvatarWidget);
    }

    // Try to load Network Image
    return _buildCircle(
      Image.network(
        imageUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return defaultAvatarWidget;
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: size,
            height: size,
            color: Colors.grey[200],
            child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        },
      ),
    );
  }

  // FIXED HELPER FUNCTION
  Widget _buildCircle(Widget child) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size / 2),
      child: Container(
        width: size,
        height: size,
        color: AppColors.lavenderBlue,
        child: child,
      ),
    );
  }
}