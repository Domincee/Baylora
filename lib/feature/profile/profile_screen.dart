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
import 'package:baylora_prjct/feature/profile/widgets/listing_card.dart';
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
                avatarUrl: profile.avatarUrl ?? 'https://i.pravatar.cc/150?img=12',
                name: profile.fullName,
                username: profile.username.isNotEmpty ? profile.username : ProfileStrings.defaultUsername,
                bio: profile.bio ?? ProfileStrings.noBio,
                rating: profile.rating,
                onEdit: () => _showEditProfileDialog(context, ref, profile),
              ),
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
        final showSeeAll = listings.length > 3;
        final displayList = showSeeAll ? listings.take(3).toList() : listings;

        return Column(
          children: [
            SectionHeader(
              title: ProfileStrings.listingsTitle,
              subTitle: ProfileStrings.listingsSubtitle,
              showSeeAll: showSeeAll,
              onSeeAll: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyListingsScreen()),
                );
              },
            ),
            AppValues.gapM,
            if (displayList.isEmpty)
              const Text(ProfileStrings.noListings)
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: displayList.length,
                separatorBuilder: (context, index) => AppValues.gapM,
                itemBuilder: (context, index) {
                  final item = displayList[index];
                  final images = item['images'] as List?;
                  final tags = item['tags'] != null ? List<String>.from(item['tags']) : <String>[];
                  
                  // Logic to determine display status
                  String displayStatus = item['status'] ?? 'Active';
                  if (item['end_time'] != null) {
                    try {
                      final endTime = DateTime.parse(item['end_time']);
                      if (DateTime.now().isAfter(endTime)) {
                        displayStatus = 'Ended';
                      }
                    } catch (_) {}
                  }

                  return ListingCard(
                    title: item['title'] ?? 'Untitled',
                    price: item['price']?.toString(),
                    subtitle: item['swap_preference'],
                    tags: tags,
                    offers: "${item['offer_count'] ?? 0} Offers",
                    postedTime: ProfileStrings.recently,
                    status: displayStatus,
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
