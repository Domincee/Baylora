import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';

class ProfileHeader extends StatelessWidget {
  final String avatarUrl;
  final String name;
  final String username;
  final String bio;
  final double rating;
  final VoidCallback onEdit;

  const ProfileHeader({
    super.key,
    required this.avatarUrl,
    required this.name,
    required this.username,
    required this.bio,
    required this.rating,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppValues.paddingCard,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppValues.borderRadiusXL,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundImage: NetworkImage(avatarUrl),
            backgroundColor: Colors.grey[200],
          ),
          AppValues.gapHM,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      username,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    IconButton(
                      onPressed: onEdit,
                      icon: Icon(
                        Icons.edit_note,
                        size: 20,
                        color: AppColors.textGrey,
                      ),
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
                Text(
                  bio.isEmpty ? "No bio yet" : bio,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textGrey,
                  ),
                ),
                AppValues.gapXXS,
                Row(children: List.generate(5, (index) => Icon(
                  Icons.star, 
                  color: index < rating ? Colors.amber : Colors.grey[300], 
                  size: 16
                ))),
              ],
            ),
          )
        ],
      ),
    );
  }
}
