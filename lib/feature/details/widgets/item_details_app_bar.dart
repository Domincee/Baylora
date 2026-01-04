import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ItemDetailsAppBar extends StatelessWidget {
  const ItemDetailsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Container(
        margin: const EdgeInsets.only(left: 8),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white54,
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white54,
          ),
          child: IconButton(
            icon: const Icon(Icons.share_outlined, color: AppColors.black),
            onPressed: () {},
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 16),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white54,
          ),
          child: IconButton(
            icon: const Icon(Icons.favorite_border, color: AppColors.black),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
