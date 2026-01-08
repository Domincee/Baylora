import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:baylora_prjct/core/constant/app_strings.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/widgets/text/section_header.dart';
import 'package:baylora_prjct/feature/manage_listing/screens/manage_listing_screen.dart';
import 'package:baylora_prjct/feature/profile/constant/profile_strings.dart';
import 'package:baylora_prjct/feature/profile/provider/profile_provider.dart';
import 'package:baylora_prjct/feature/profile/screens/my_listings_screen.dart';
import 'package:baylora_prjct/feature/profile/widgets/management_listing_card.dart';

import '../see_all_button.dart';

class ProfileListingsSection extends ConsumerWidget {
  const ProfileListingsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listingsAsync = ref.watch(myListingsProvider);

    return listingsAsync.when(
      data: (listings) {
        if (listings.isEmpty) return const Text(ProfileStrings.noListings);

        final previewList = listings.take(4).toList();

        return Column(
          children: [
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: previewList.length,
              separatorBuilder: (context, index) => AppValues.gapM,
              itemBuilder: (context, index) {
                final item = previewList[index];
                final images = item[ProfileStrings.fieldImages] as List?;
                
                // Handle swap_preference instead of tags
                final swapPref = item[ProfileStrings.fieldSwapPreference];
                final List<String> lookingFor = (swapPref != null && swapPref.toString().isNotEmpty)
                    ? swapPref.toString().split(ProfileStrings.separatorComma).map((e) => e.trim()).toList()
                    : [];
                
                // 1. Posted Date Parsing
                DateTime postedDate = DateTime.now();
                if (item[ProfileStrings.fieldCreatedAt] != null) {
                  try {
                    postedDate = DateTime.parse(item[ProfileStrings.fieldCreatedAt]);
                  } catch (_) {}
                }

                // 2. Price Parsing
                double? price;
                if (item[ProfileStrings.fieldPrice] != null) {
                  final parsedPrice = double.tryParse(item[ProfileStrings.fieldPrice].toString());
                  if (parsedPrice != null && parsedPrice > 0) {
                    price = parsedPrice;
                  }
                }

                // 3. Status Logic
                String displayStatus = ProfileStrings.statusActive;
                final dbStatus = item[ProfileStrings.fieldStatus]?.toString().toLowerCase();

                DateTime? endTime;
                if (item[ProfileStrings.fieldEndTime] != null) {
                   try {
                     endTime = DateTime.parse(item[ProfileStrings.fieldEndTime]);
                   } catch (_) {}
                }

                if (dbStatus == ProfileStrings.dbStatusSold) {
                  displayStatus = ProfileStrings.statusSold;
                } else if (dbStatus == ProfileStrings.dbStatusAccepted) {
                  displayStatus = ProfileStrings.statusAccepted;
                } else {
                  if (endTime != null && DateTime.now().isAfter(endTime)) {
                    displayStatus = ProfileStrings.statusExpired;
                  }
                }
                return ManagementListingCard(
                  title: item[ProfileStrings.fieldTitle] ?? ProfileStrings.untitled,
                  imageUrl: (images != null && images.isNotEmpty) ? images[0] : '',
                  status: displayStatus,
                  offerCount: item[ProfileStrings.fieldOfferCount] ?? 0,
                  postedDate: postedDate,
                  price: price,
                  lookingFor: lookingFor,
                  endTime: endTime,
                  onAction: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ManageListingScreen(itemId: item['id'].toString()),
                      ),
                    );
                  },
                );
              },
            ),
            
            // "See All" Logic: Only show if there are MORE items than we are previewing (4)
            if (listings.length > 4) ...[
              AppValues.gapM,
              AppValues.gapM,
              const SeeAllButton(
                destination : MyListingsScreen(),
              ),
            ],
          ],
        );
      },
      loading: () => const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: ProfileStrings.listingsTitle, subTitle: ProfileStrings.listingsSubtitle),
          AppValues.gapM,
          LinearProgressIndicator(),
        ],
      ),
      error: (err, stack) => Text("${AppStrings.error}: $err"),
    );
  }
}