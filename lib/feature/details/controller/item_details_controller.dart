import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class ItemDetailsController {
  
  static List<dynamic> sortOffers(List<dynamic> rawOffers) {
    final List<dynamic> offers = List.from(rawOffers);
    offers.sort((a, b) {
      final amtA = (a['cash_offer'] ?? 0) as num;
      final amtB = (b['cash_offer'] ?? 0) as num;
      return amtB.compareTo(amtA);
    });
    return offers;
  }

  static dynamic calculateDisplayPrice(List<dynamic> offers, dynamic basePrice) {
    final highestOffer = offers.isNotEmpty ? offers.first['cash_offer'] : null;
    if (highestOffer != null && (highestOffer as num) > 0) {
      return highestOffer;
    }
    return basePrice;
  }

  static bool isOwner(Map<String, dynamic> item, Map<String, dynamic> seller) {
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;
    final String? ownerId = item['user_id']?.toString() ?? seller['id']?.toString();
    
    final isOwner = currentUserId != null && ownerId != null && currentUserId == ownerId;
    
    if (isOwner) {
      debugPrint("User is owner of this item ($ownerId)");
    }
    return isOwner;
  }

  static DateTime? parseEndTime(String? endTimeStr) {
    return endTimeStr != null ? DateTime.tryParse(endTimeStr) : null;
  }
}
