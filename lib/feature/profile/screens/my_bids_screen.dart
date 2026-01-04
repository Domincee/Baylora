import 'package:baylora_prjct/core/constant/app_strings.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/profile/constant/profile_strings.dart';
import 'package:baylora_prjct/feature/profile/provider/profile_provider.dart';
import 'package:baylora_prjct/feature/profile/widgets/bid_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyBidsScreen extends ConsumerWidget {
  const MyBidsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bidsAsync = ref.watch(myBidsProvider);

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: const Text(ProfileStrings.bidsTitle),
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.black),
        titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.black,
              fontWeight: FontWeight.w600,
            ),
      ),
      body: bidsAsync.when(
        data: (bids) {
          if (bids.isEmpty) {
            return const Center(child: Text(ProfileStrings.noBids));
          }
          return ListView.separated(
            padding: AppValues.paddingAll,
            itemCount: bids.length,
            separatorBuilder: (context, index) => AppValues.gapM,
            itemBuilder: (context, index) {
              final bid = bids[index];
              final item = bid['items'] as Map<String, dynamic>?;

              if (item == null) return const SizedBox.shrink();

              final images = item['images'] as List?;
              String myOfferText = bid['cash_offer'] != null
                  ? "P${bid['cash_offer']}"
                  : (bid['swap_item_text'] ?? "Unknown Offer");

              return BidCard(
                title: item['title'] ?? 'Unknown Item',
                myOffer: myOfferText,
                timer: ProfileStrings.endsSoon,
                postedTime: ProfileStrings.recently,
                status: item['status'] ?? 'Active',
                extraStatus: bid['status'],
                imageUrl: (images != null && images.isNotEmpty) ? images[0] : null,
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("${AppStrings.error}: $err")),
      ),
    );
  }
}
