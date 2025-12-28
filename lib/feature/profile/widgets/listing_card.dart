import 'package:flutter/material.dart';

class ListingCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? price;
  final List<String> tags;
  final String offers;
  final String postedTime;
  final String status;
  final String? imageUrl;

  const ListingCard({
    super.key,
    required this.title,
    this.subtitle,
    this.price,
    this.tags = const [],
    required this.offers,
    required this.postedTime,
    required this.status,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor = status == 'Accepted' ? Colors.blue : (status == 'Sold' ? Colors.grey : Colors.lightBlueAccent.withValues(alpha:  0.2));
    Color statusTextColor = status == 'Accepted' ? Colors.white : (status == 'Sold' ? Colors.white : Colors.blue[800]!);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              image: imageUrl != null ? DecorationImage(image: NetworkImage(imageUrl!), fit: BoxFit.cover) : null,
            ),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                if (price != null) ...[
                   Text("Price: $price", style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ] else if (subtitle != null) ...[
                   Text("Looking for: $subtitle", style: const TextStyle(fontSize: 11, color: Colors.grey)),
                   if (tags.isNotEmpty) 
                     Wrap(
                       spacing: 4,
                       children: tags.map((t) => Container(
                         margin: const EdgeInsets.only(top: 4),
                         padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                         decoration: BoxDecoration(color: Colors.teal[50], borderRadius: BorderRadius.circular(4)),
                         child: Text(t, style: const TextStyle(fontSize: 9, color: Colors.teal)),
                       )).toList(),
                     )
                ],
                const SizedBox(height: 8),
                Text(offers, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
                Text(postedTime, style: const TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
          ),
          // Actions
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(8)),
                child: Text(status, style: TextStyle(color: statusTextColor, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 20),
              Container(
                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                 decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
                 child: const Text("Manage", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
              )
            ],
          )
        ],
      ),
    );
  }
}
