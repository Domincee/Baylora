import 'package:baylora_prjct/feature/home/provider/home_provider.dart';
import 'package:baylora_prjct/feature/profile/provider/profile_provider.dart';
import 'package:baylora_prjct/feature/profile/widgets/bid_card.dart';
import 'package:baylora_prjct/feature/profile/widgets/edit_profile_dialog.dart';
import 'package:baylora_prjct/feature/profile/widgets/listing_card.dart';
import 'package:baylora_prjct/feature/profile/widgets/profile_header.dart';
import 'package:baylora_prjct/feature/profile/widgets/section_header.dart';
import 'package:baylora_prjct/feature/profile/widgets/settings_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  void _showEditProfileDialog(BuildContext context, WidgetRef ref, Map<String, dynamic> profile) {
    showDialog(
      context: context,
      builder: (context) => EditProfileDialog(
        username: profile['username'] ?? '',
        bio: profile['bio'] ?? '',
        onSave: ({required username, required bio}) async {
           final profileService = ref.read(profileServiceProvider);
           
           await profileService.updateProfile(
             username: username,
             bio: bio,
           );

           // Invalidate the provider to force a refresh
           ref.invalidate(userProfileProvider);
           
           // Also invalidate the Home items so they reflect the new username/avatar immediately
           // Invalidating the provider family ensures all filters (All, Hot, etc.) get refreshed.
           // However, since we don't know the exact filter key, we can iterate or use a simpler approach.
           // Since 'All' is the default, let's at least refresh that.
           // Better yet, just invalidate the whole provider if possible, but for family providers we specific args.
           // Let's invalidate the most common one.
           ref.invalidate(homeItemsProvider("All")); 
           ref.invalidate(homeItemsProvider("New"));
           ref.invalidate(homeItemsProvider("Hot"));
           ref.invalidate(homeItemsProvider("Ending"));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: profileAsync.when(
        data: (profile) => SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileHeader(
                avatarUrl: profile['avatar_url'] ?? 'https://i.pravatar.cc/150?img=12',
                name: profile['full_name'] ?? 'User',
                username: profile['username'] ?? '@username',
                bio: profile['bio'] ?? 'No bio yet.',
                rating: (profile['rating'] ?? 0.0).toDouble(),
                onEdit: () => _showEditProfileDialog(context, ref, profile),
              ),
              const SizedBox(height: 24),

              const SectionHeader(title: "Listings", subTitle: "Items you are selling"),
              const SizedBox(height: 12),
              const _ListingsList(),

              const SizedBox(height: 24),

              const SectionHeader(title: "Bids", subTitle: "Items you are Bidding on"),
              const SizedBox(height: 12),
              const _BidsList(),
              
              const SizedBox(height: 24),

              const Text("Settings", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Text("Control your Profile and Alerts.", style: TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 16),
              
              Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    SettingsTile(
                      title: "Edit Profile", 
                      subtitle: "Update your name, bio and photo.",
                      onTap: () => _showEditProfileDialog(context, ref, profile),
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    const SettingsTile(title: "Notification", subtitle: "Choose what you want to be notified about."),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    const SettingsTile(title: "Log out", hideSubtitle: true),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Error: $err")),
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
        if (listings.isEmpty) return const Text("No items listed yet.");

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: listings.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
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
              postedTime: "Recently", 
              status: item['status'] ?? 'Active',
              imageUrl: (images != null && images.isNotEmpty) ? images[0] : null,
            );
          },
        );
      },
      loading: () => const LinearProgressIndicator(),
      error: (err, stack) => Text("Error loading listings: $err"),
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
        if (bids.isEmpty) return const Text("You haven't placed any bids.");

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: bids.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final bid = bids[index];
            final item = bid['items'];
            final images = item != null ? item['images'] as List? : null;

            String myOfferText = "Unknown Offer";
            if (bid['cash_offer'] != null) {
               myOfferText = "P${bid['cash_offer']}";
            } else if (bid['swap_item_text'] != null) {
               myOfferText = bid['swap_item_text'];
            }

            return BidCard(
              title: item != null ? item['title'] : 'Unknown Item',
              myOffer: myOfferText,
              timer: "Ends soon",
              postedTime: "Recently",
              status: item != null ? (item['status'] ?? 'Active') : 'Active',
              extraStatus: bid['status'],
              imageUrl: (images != null && images.isNotEmpty) ? images[0] : null,
            );
          },
        );
      },
      loading: () => const LinearProgressIndicator(),
      error: (err, stack) => Text("Error loading bids: $err"),
    );
  }
}
