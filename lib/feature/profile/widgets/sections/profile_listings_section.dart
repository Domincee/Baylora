import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:baylora_prjct/core/constant/app_strings.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/core/widgets/text/section_header.dart';
import 'package:baylora_prjct/feature/profile/constant/profile_strings.dart';
import 'package:baylora_prjct/feature/profile/provider/profile_provider.dart';
import 'package:baylora_prjct/feature/profile/screens/my_listings_screen.dart';
import 'package:baylora_prjct/feature/profile/widgets/management_listing_card.dart';

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
                final images = item['images'] as List?;
                
                // Handle swap_preference instead of tags
                final swapPref = item['swap_preference'];
                final List<String> lookingFor = (swapPref != null && swapPref.toString().isNotEmpty)
                    ? swapPref.toString().split(',').map((e) => e.trim()).toList()
                    : [];
                
                // 1. Posted Date Parsing
                DateTime postedDate = DateTime.now();
                if (item['created_at'] != null) {
                  try {
                    postedDate = DateTime.parse(item['created_at']);
                  } catch (_) {}
                }

                // 2. Price Parsing
                double? price;
                if (item['price'] != null) {
                  final parsedPrice = double.tryParse(item['price'].toString());
                  if (parsedPrice != null && parsedPrice > 0) {
                    price = parsedPrice;
                  }
                }

                // 3. Status Logic
                String displayStatus = 'Active';
                final dbStatus = item['status']?.toString().toLowerCase();

                DateTime? endTime;
                if (item['end_time'] != null) {
                   try {
                     endTime = DateTime.parse(item['end_time']);
                   } catch (_) {}
                }

                if (dbStatus == 'sold') {
                  displayStatus = 'Sold';
                } else if (dbStatus == 'accepted') {
                  displayStatus = 'Accepted';
                } else {
                  if (endTime != null && DateTime.now().isAfter(endTime)) {
                    displayStatus = 'Expired'; // Changed from 'Ended' to 'Expired'
                  }
                }

                return ManagementListingCard(
                  title: item['title'] ?? 'Untitled',
                  imageUrl: (images != null && images.isNotEmpty) ? images[0] : '',
                  status: displayStatus,
                  offerCount: item['offer_count'] ?? 0,
                  postedDate: postedDate,
                  price: price,
                  lookingFor: lookingFor,
                  endTime: endTime,
                );
              },
            ),
            
            // "See All" Logic: Only show if there are MORE items than we are previewing (4)
            if (listings.length > 4) ...[
              AppValues.gapM,
              InkWell(
                onTap: () {
                   Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyListingsScreen()),
                  );
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "See all",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textGrey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: AppColors.textGrey,
                      ),
                    ],
                  ),
                ),
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
