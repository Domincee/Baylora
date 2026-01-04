import 'package:baylora_prjct/core/assets/images.dart';
import 'package:baylora_prjct/core/constant/app_strings.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/core/widgets/text/section_header.dart';
import 'package:baylora_prjct/core/widgets/tiles/app_list_tile.dart';
import 'package:baylora_prjct/feature/home/provider/home_provider.dart';
import 'package:baylora_prjct/feature/profile/constant/profile_strings.dart';
import 'package:baylora_prjct/feature/profile/domain/user_profile.dart';
import 'package:baylora_prjct/feature/profile/provider/profile_provider.dart';
import 'package:baylora_prjct/feature/profile/screens/my_bids_screen.dart';
import 'package:baylora_prjct/feature/profile/screens/my_listings_screen.dart';
import 'package:baylora_prjct/feature/profile/widgets/bid_card.dart';
import 'package:baylora_prjct/feature/profile/widgets/edit_profile_dialog.dart';
import 'package:baylora_prjct/feature/profile/widgets/management_listing_card.dart';
import 'package:baylora_prjct/feature/profile/widgets/profile_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  void _showEditProfileDialog(BuildContext context, WidgetRef ref, UserProfile profile) {
    showDialog(
      context: context,
      builder: (context) => EditProfileDialog(
        username: profile.username,
        bio: profile.bio ?? '',
        onSave: ({required username, required bio}) async {
          final profileService = ref.read(profileServiceProvider);
          await profileService.updateProfile(username: username, bio: bio);

          ref.invalidate(userProfileProvider);
          // Invalidate home providers to reflect name changes if necessary
          ref.invalidate(homeItemsProvider("All"));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: profileAsync.when(
        data: (profile) => SingleChildScrollView(
          padding: AppValues.paddingAll,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileHeader(
                avatarUrl: (profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty)
                    ? profile.avatarUrl!
                    : Images.defaultAvatar,
                name: profile.fullName,
                username: profile.username.isNotEmpty ? profile.username : ProfileStrings.defaultUsername,
                bio: profile.bio ?? ProfileStrings.noBio,
                rating: profile.rating,
                isVerified: profile.isVerified, // FIXED: Pass isVerified to header
                onEdit: () => _showEditProfileDialog(context, ref, profile),
              ),
              AppValues.gapL,
              SectionHeader(title: ProfileStrings.listingsTitle, subTitle: ProfileStrings.listingsSubtitle),
              AppValues.gapL,

              const _ListingsSection(),

              AppValues.gapL,

              const _BidsSection(),

              AppValues.gapL,

              Text(
                AppStrings.settings,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                ProfileStrings.settingsSubtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.subTextColor,
                ),
              ),
              AppValues.gapM,
              Container(
                decoration: BoxDecoration(
                  color: AppColors.lavenderBlue,
                  borderRadius: AppValues.borderRadiusM,
                ),
                child: Column(
                  children: [
                    AppListTile(
                      title: AppStrings.editProfile,
                      subtitle: ProfileStrings.editProfileSubtitle,
                      onTap: () => _showEditProfileDialog(context, ref, profile),
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    const AppListTile(title: AppStrings.notifications, subtitle: ProfileStrings.notificationSubtitle),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    const AppListTile(
                      title: AppStrings.logout,
                      hideSubtitle: true,
                      titleColor: AppColors.errorColor,
                    ),
                  ],
                ),
              ),
              AppValues.gapXXL,
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("${AppStrings.error}: $err")),
      ),
    );
  }
}

class _ListingsSection extends ConsumerWidget {
  const _ListingsSection();

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
                    displayStatus = 'Ended';
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
                  isAuction: false,
                  currentHighestBid: null,
                  soldToItem: null,
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

class _BidsSection extends ConsumerWidget {
  const _BidsSection();

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
                  MaterialPageRoute(builder: (context) => const  MyBidsScreen()),
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
