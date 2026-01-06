// ignore_for_file: avoid_print

import 'package:baylora_prjct/feature/home/constant/home_strings.dart';
import 'package:baylora_prjct/feature/home/util/date_util.dart';

class ItemCardMapper {
  ItemCardMapper._();

  static Map<String, dynamic> map(Map<String, dynamic> item) {
    final profile = item['profiles'] ?? {};

    final images = item['images'] as List?;
    final firstImage = (images != null && images.isNotEmpty)
        ? images.first
        : HomeStrings.placeholderImage;
    
    // Parse End Time
    DateTime? endTime;
    if (item['end_time'] != null) {
      endTime = DateTime.tryParse(item['end_time']);
    }

    return {
      'title': item['title'] ?? HomeStrings.noTitle,
      'description': item['description'] ?? '',
      'price': (item['price'] ?? 0).toString(),
      'type': item['type'] ?? HomeStrings.cash,
      'swapItem': item['swap_preference'] ?? HomeStrings.anything,
      'imagePath': firstImage,
      'postedTime': DateUtil.getTimeAgo(item['created_at']),

      'isVerified': profile['is_verified'] ?? false,
      'sellerName': profile['username'] ?? HomeStrings.unknownUser,

      'sellerImage': profile['avatar_url'] ?? '',
      'rating': (profile['rating'] ?? 0.0).toString(),
      'totalTrade': (profile['total_trades'] ?? 0).toString(),

      'timeRemaining': endTime != null 
          ? (DateTime.now().isAfter(endTime) ? HomeStrings.ended : DateUtil.getRemainingTime(endTime, short: false)) 
          : null,
    };
  }
}
