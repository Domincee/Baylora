import 'package:baylora_prjct/core/constant/app_strings.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/core/widgets/text/section_header.dart';
import 'package:baylora_prjct/core/widgets/tiles/app_list_tile.dart';
import 'package:baylora_prjct/feature/home/provider/home_provider.dart';
import 'package:baylora_prjct/feature/profile/constant/profile_strings.dart';
import 'package:baylora_prjct/feature/profile/domain/user_profile.dart';
import 'package:baylora_prjct/feature/profile/provider/profile_provider.dart';
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
          padding: const EdgeInsets.all(AppValuesWidget.paddingM),
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
              AppValuesWidget.gapL,

              const SectionHeader(title: ProfileStrings.listingsTitle, subTitle: ProfileStrings.listingsSubtitle),
              AppValuesWidget.gapM,
              const _ListingsList(),

              AppValuesWidget.gapL,

              const SectionHeader(title: ProfileStrings.bidsTitle, subTitle: ProfileStrings.bidsSubtitle),
              AppValuesWidget.gapM,
              const _BidsList(),

              AppValuesWidget.gapL,

              Text(AppStrings.settings, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              Text(ProfileStrings.settingsSubtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.subTextColor)),

              AppValuesWidget.gapM,

              Container(
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppValuesWidget.radiusM)),
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
                    const AppListTile(title: AppStrings.logout, hideSubtitle: true, titleColor: AppColors.errorColor),
                  ],
                ),
              ),
              AppValuesWidget.gapXL,
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("${AppStrings.error}: $err")),
      ),
    );
  }
}

class _ListingsList extends ConsumerWidget {
  const _ListingsList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listingsAsync = ref.watch(myListingsProvider);

    return listingsAsync.when(
      data: (listings) {
        if (listings.isEmpty) return const Text(ProfileStrings.noListings);
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: listings.length,
          separatorBuilder: (context, index) => AppValuesWidget.gapM,
          itemBuilder: (context, index) {
            final item = listings[index];
            final images = item['images'] as List?;
            final tags = item['tags'] != null ? List<String>.from(item['tags']) : <String>[];

            return ListingCard(
              title: item['title'] ?? 'Untitled',
              price: item['price']?.toString(),
              subtitle: item['swap_preference'],
              tags: tags,
              offers: "${item['offer_count'] ?? 0} Offers",
              postedTime: ProfileStrings.recently,
              status: item['status'] ?? 'Active',
              imageUrl: (images != null && images.isNotEmpty) ? images[0] : null,
            );
          },
        );
      },
      loading: () => const LinearProgressIndicator(),
      error: (err, stack) => Text("${AppStrings.error}: $err"),
    );
  }
}

class _BidsList extends ConsumerWidget {
  const _BidsList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bidsAsync = ref.watch(myBidsProvider);

    return bidsAsync.when(
      data: (bids) {
        if (bids.isEmpty) return const Text(ProfileStrings.noBids);

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: bids.length,
          separatorBuilder: (context, index) => AppValuesWidget.gapM,
          itemBuilder: (context, index) {
            final bid = bids[index];

            // ✅ FIX: Safe casting for nested 'items' object
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
        );
      },
      loading: () => const LinearProgressIndicator(),
      error: (err, stack) => Text("${AppStrings.error}: $err"),
    );
  }
}
