import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:baylora_prjct/core/constant/app_strings.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/widgets/text/section_header.dart';
import 'package:baylora_prjct/feature/profile/constant/profile_strings.dart';
import 'package:baylora_prjct/feature/profile/provider/profile_provider.dart';
import 'package:baylora_prjct/feature/profile/screens/my_bids_screen.dart';
import 'package:baylora_prjct/feature/profile/widgets/management_listing_card.dart';
import 'package:baylora_prjct/feature/details/item_details_screen.dart';

import '../see_all_button.dart';

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
            const SectionHeader(
              title: ProfileStrings.bidsTitle,
              subTitle: ProfileStrings.bidsSubtitle,
              showSeeAll: false, // Hidden from top
            ),
            AppValues.gapM,
            if (displayList.isEmpty)
              const Text(ProfileStrings.noBids)
            else ...[
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
                  
                  // Logic matching MyBidsScreen
                  double? price;
                  List<String> lookingFor = [];
                  
                  final double cash = (bid['cash_offer'] as num?)?.toDouble() ?? 0.0;
                  final String? swap = bid['swap_item_text'];
                  
                  if (cash > 0) {
                    price = cash;
                  }
                  
                  if (swap != null && swap.isNotEmpty) {
                    final cleanTitle = swap.split('(').first.trim();
                    lookingFor = [cleanTitle];
                  }

                  String displayStatus = ProfileStrings.statusActive;
                  final bidStatus = bid['status']?.toString().toLowerCase();
                  final itemStatus = item['status']?.toString().toLowerCase();

                  DateTime? endTime;
                  if (item['end_time'] != null) {
                    try {
                      endTime = DateTime.parse(item['end_time']);
                    } catch (_) {}
                  }

                  if (bidStatus == ProfileStrings.dbStatusAccepted) {
                    displayStatus = ProfileStrings.statusAccepted;
                  } else if (bidStatus == ProfileStrings.dbStatusRejected) {
                    displayStatus = ProfileStrings.statusRejected;
                  } else if (itemStatus == ProfileStrings.dbStatusSold) {
                    displayStatus = ProfileStrings.statusSold;
                  } else {
                      if (endTime != null && DateTime.now().isAfter(endTime)) {
                        displayStatus = ProfileStrings.statusExpired;
                      }
                  }

                  DateTime postedDate = DateTime.now();
                  if (bid['created_at'] != null) {
                    try {
                      postedDate = DateTime.parse(bid['created_at']);
                    } catch (_) {}
                  }

                  return ManagementListingCard(
                    title: item['title'] ?? 'Unknown Item',
                    imageUrl: (images != null && images.isNotEmpty) ? images[0] : '',
                    status: displayStatus,
                    offerCount: 0,
                    postedDate: postedDate,
                    price: price,
                    lookingFor: lookingFor,
                    endTime: endTime,
                    onAction: () {
                      final itemId = item['id'].toString();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ItemDetailsScreen(itemId: itemId)),
                      );
                    }, 
                    isMyBid: true,
                  );
                },
              ),
              if (showSeeAll) ...[
                AppValues.gapM,
                AppValues.gapM,
                SeeAllButton(
                   destination : MyBidsScreen(),
                ),
              ],
            ]
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
