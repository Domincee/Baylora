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

    return {
      'title': item['title'] ?? 'No Title',
      'description': item['description'] ?? '',
      'price': (item['price'] ?? 0).toString(),
      'type': item['type'] ?? 'cash',
      'swapItem': item['swap_preference'] ?? 'Anything',
      'imagePath': firstImage,
      'postedTime': DateUtil.getTimeAgo(item['created_at']),
      'isVerified': item['is_verified'] ?? false,
      'sellerName': profile['username'] ?? 'Unknown',
      'sellerImage': profile['avatar_url'] ?? 'https://i.pravatar.cc/150',
      'rating': (profile['rating'] ?? 0.0).toString(),
      'totalTrade': (profile['total_trades'] ?? 0).toString(),
    };
  }
}
