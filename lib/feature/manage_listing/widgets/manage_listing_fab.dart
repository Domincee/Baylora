import 'package:flutter/material.dart';
import '../../chat/screens/deal_chat_screen.dart';
import '../constant/manage_listing_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_style.dart';

class ManageListingFab extends StatelessWidget {
  final Map<String, dynamic> item;

  const ManageListingFab({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    // 1. Extract status safely
    final status = item['status']?.toString().toLowerCase();

    // 2. ✅ Show FAB if status is 'accepted' OR 'sold'
    if (status == 'accepted' || status == 'sold') {
      final offers = List<Map<String, dynamic>>.from(item['offers'] ?? []);

      // Find the specific offer that was accepted
      final acceptedOffer = offers.firstWhere(
            (o) => o['status']?.toString().toLowerCase() == 'accepted',
        orElse: () => {},
      );

      if (acceptedOffer.isNotEmpty) {
        final profile = acceptedOffer['profiles'];
        final username = profile != null
            ? profile['username']
            : ManageListingStrings.defaultBuyerName;

        return FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DealChatScreen(
                  chatTitle: username,
                  itemName: item['title'] ?? ManageListingStrings.defaultItemName,
                  contextId: acceptedOffer['id'],
                ),
              ),
            );
          },
          label: Text(
            ManageListingStrings.openDealChat,
            style: AppTextStyles.bodyMedium(
              context,
              color: AppColors.highLightTextColor,
            ),
          ),
          icon: const Icon(Icons.chat_bubble, color: AppColors.highLightTextColor),
          backgroundColor: AppColors.lavenderBlue,
        );
      }
    }

    // 3. ✅ Return empty widget instead of null to satisfy the build method
    return const SizedBox.shrink();
  }
}