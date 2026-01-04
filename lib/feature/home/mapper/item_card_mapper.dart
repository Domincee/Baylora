// ignore_for_file: avoid_print

import 'package:baylora_prjct/feature/home/util/date_util.dart';

class ItemCardMapper {
  ItemCardMapper._();

  static Map<String, dynamic> map(Map<String, dynamic> item) {
    final profile = item['profiles'] ?? {};

    final images = item['images'] as List?;
    final firstImage = (images != null && images.isNotEmpty)
        ? images.first
        : 'https://via.placeholder.com/300';
    
    // Parse End Time
    DateTime? endTime;
    if (item['end_time'] != null) {
      endTime = DateTime.tryParse(item['end_time']);
    }

    return {
      'title': item['title'] ?? 'No Title',
      'description': item['description'] ?? '',
      'price': (item['price'] ?? 0).toString(),
      'type': item['type'] ?? 'cash',
      'swapItem': item['swap_preference'] ?? 'Anything',
      'imagePath': firstImage,
      'postedTime': DateUtil.getTimeAgo(item['created_at']),
      // FIX: Map isVerified from profile data, not item data
      'isVerified': profile['is_verified'] ?? false,
      'sellerName': profile['username'] ?? 'Unknown',
      // FIX: Changed from pravatar.cc to empty string so ProfileAvatar uses default logic
      'sellerImage': profile['avatar_url'] ?? '',
      'rating': (profile['rating'] ?? 0.0).toString(),
      'totalTrade': (profile['total_trades'] ?? 0).toString(),
      // Use Shared Logic
      'timeRemaining': endTime != null 
          ? (DateTime.now().isAfter(endTime) ? "Ended" : DateUtil.getRemainingTime(endTime, short: false)) 
          : null,
    };
  }
}
