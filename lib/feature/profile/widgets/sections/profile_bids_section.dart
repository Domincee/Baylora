import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:baylora_prjct/core/constant/app_strings.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/widgets/text/section_header.dart';
import 'package:baylora_prjct/feature/profile/constant/profile_strings.dart';
import 'package:baylora_prjct/feature/profile/provider/profile_provider.dart';
import 'package:baylora_prjct/feature/profile/screens/my_bids_screen.dart';
import 'package:baylora_prjct/feature/profile/widgets/bid_card.dart';

class ProfileBidsSection extends ConsumerWidget {
  const ProfileBidsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bidsAsync = ref.watch(myBidsProvider);

    return bidsAsync.when(
      data: (bids) {
        final showSeeAll = bids.length > 3;
        final displayList = showSeeAll ? bids.take(3).toList() : bids;

        return Column(
          children: [
            SectionHeader(
              title: ProfileStrings.bidsTitle,
              subTitle: ProfileStrings.bidsSubtitle,
              showSeeAll: showSeeAll,
              onSeeAll: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyBidsScreen()),
                );
              },
            ),
            AppValues.gapM,
            if (displayList.isEmpty)
              const Text(ProfileStrings.noBids)
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: displayList.length,
                separatorBuilder: (context, index) => AppValues.gapM,
                itemBuilder: (context, index) {
                  final bid = displayList[index];
                  final item = bid['items'] as Map<String, dynamic>?;

                  if (item == null) return const SizedBox.shrink();

                  final images = item['images'] as List?;
                  String myOfferText = bid['cash_offer'] != null ? "P${bid['cash_offer']}" : (bid['swap_item_text'] ?? "Unknown Offer");

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
              ),
          ],
        );
      },
      loading: () => const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           SectionHeader(title: ProfileStrings.bidsTitle, subTitle: ProfileStrings.bidsSubtitle),
           AppValues.gapM,
           LinearProgressIndicator(),
        ],
      ),
      error: (err, stack) => Text("${AppStrings.error}: $err"),
    );
  }
}
