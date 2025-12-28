import 'package:baylora_prjct/feature/profile/service/profile_service.dart';
import 'package:baylora_prjct/feature/profile/widgets/bid_card.dart';
import 'package:baylora_prjct/feature/profile/widgets/listing_card.dart';
import 'package:baylora_prjct/feature/profile/widgets/profile_header.dart';
import 'package:baylora_prjct/feature/profile/widgets/section_header.dart';
import 'package:baylora_prjct/feature/profile/widgets/settings_tile.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileService _profileService = ProfileService();

  // --- EDIT DIALOG ---
  void _showEditProfileDialog(BuildContext context, String currentBio, String currentFirst, String currentLast) {
    final firstController = TextEditingController(text: currentFirst);
    final lastController = TextEditingController(text: currentLast);
    final bioController = TextEditingController(text: currentBio);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Edit Profile"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: firstController,
              decoration: const InputDecoration(labelText: "First Name"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: lastController,
              decoration: const InputDecoration(labelText: "Last Name"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: bioController,
              decoration: const InputDecoration(labelText: "Bio / Tagline"),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final fName = firstController.text;
              final lName = lastController.text;
              final bioText = bioController.text;

              await _profileService.updateProfile(
                firstName: fName,
                lastName: lName,
                bio: bioText,
              );
              
              if (dialogContext.mounted) {
                Navigator.pop(dialogContext);
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            // --- 1. PROFILE HEADER ---
            StreamBuilder<Map<String, dynamic>>(
              stream: _profileService.myProfileStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final profile = snapshot.data!;
                
                return ProfileHeader(
                  avatarUrl: profile['avatar_url'] ?? 'https://i.pravatar.cc/150?img=12',
                  name: profile['full_name'] ?? 'User',
                  username: profile['username'] ?? '@username',
                  bio: profile['bio'] ?? 'No bio yet.',
                  rating: (profile['rating'] ?? 0.0).toDouble(),
                  onEdit: () => _showEditProfileDialog(
                    context, 
                    profile['bio'] ?? '', 
                    profile['first_name'] ?? '',
                    profile['last_name'] ?? ''
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // --- 2. LISTINGS SECTION ---
            const SectionHeader(title: "Listings", subTitle: "Items you are selling"),
            const SizedBox(height: 12),
            
            StreamBuilder<List<Map<String, dynamic>>>(
              stream: _profileService.myListingsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LinearProgressIndicator();
                }
                final listings = snapshot.data ?? [];
                if (listings.isEmpty) return const Text("No items listed yet.");

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: listings.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = listings[index];
                    
                    // Handle image array safely
                    String? imageUrl;
                    if (item['images'] != null && (item['images'] as List).isNotEmpty) {
                      imageUrl = item['images'][0]; 
                    }

                    // Parse tags safely
                    List<String> tags = [];
                    if (item['tags'] != null) {
                      tags = List<String>.from(item['tags']);
                    }

                    return ListingCard(
                      title: item['title'] ?? 'Untitled',
                      price: item['price']?.toString(),
                      subtitle: item['swap_preference'], // Matches "Looking for..."
                      tags: tags,
                      offers: "${item['offer_count'] ?? 0} Offers",
                      postedTime: "Recently", 
                      status: item['status'] ?? 'Active',
                      imageUrl: imageUrl,
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 24),

            // --- 3. BIDS SECTION ---
            const SectionHeader(title: "Bids", subTitle: "Items you are Bidding on"),
            const SizedBox(height: 12),

            StreamBuilder<List<Map<String, dynamic>>>(
              stream: _profileService.myBidsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LinearProgressIndicator();
                }
                final bids = snapshot.data ?? [];
                if (bids.isEmpty) return const Text("You haven't placed any bids.");

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: bids.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final bid = bids[index];
                    final item = bid['items']; // The joined item data

                    // Determine what to show: Cash or Trade Text
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
                      extraStatus: bid['status'], // e.g. "Winning"
                      imageUrl: (item != null && item['images'] != null && (item['images'] as List).isNotEmpty) 
                          ? item['images'][0] 
                          : null,
                    );
                  },
                );
              },
            ),
            
            const SizedBox(height: 24),

            // --- 4. SETTINGS SECTION ---
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
                    onTap: () {
                      // Trigger edit dialog manually if needed
                      // Note: We need profile data here to prepopulate, which is inside StreamBuilder above.
                      // Ideally, store profile data in state or use a provider.
                    }
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
    );
  }
}
