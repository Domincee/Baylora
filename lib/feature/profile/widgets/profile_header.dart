import 'package:flutter/material.dart';

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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundImage: NetworkImage(avatarUrl),
            backgroundColor: Colors.grey[200],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(username, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    IconButton(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit_note, size: 20, color: Colors.grey),
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
                Text(bio.isEmpty ? "No bio yet" : bio, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 4),
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
