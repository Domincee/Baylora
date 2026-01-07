// ignore_for_file: avoid_print

import 'package:baylora_prjct/feature/home/constant/home_strings.dart';
import 'package:baylora_prjct/feature/home/util/date_util.dart';
import 'package:baylora_prjct/core/models/item_model.dart';

class ItemCardMapper {
  ItemCardMapper._();

  static Map<String, dynamic> map(ItemModel item) {
    final firstImage = item.images.isNotEmpty
        ? item.images.first
        : HomeStrings.placeholderImage;
    
    return {
      'title': item.title,
      'description': item.description,
      'price': item.price.toString(),
      'type': item.type,
      'swapItem': item.swapPreference ?? HomeStrings.anything,
      'imagePath': firstImage,
      'postedTime': DateUtil.getTimeAgo(item.createdAt.toIso8601String()),

      'isVerified': item.profile?.isVerified ?? false,
      'sellerName': item.profile?.username ?? HomeStrings.unknownUser,

      'sellerImage': item.profile?.avatarUrl ?? '',
      'rating': (item.profile?.rating ?? 0.0).toString(),
      'totalTrade': (item.profile?.totalTrades ?? 0).toString(),

      'timeRemaining': item.endTime != null 
          ? (DateTime.now().isAfter(item.endTime!) ? HomeStrings.ended : DateUtil.getRemainingTime(item.endTime!, short: false)) 
          : null,
    };
  }
}
