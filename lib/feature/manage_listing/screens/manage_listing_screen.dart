import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/details/provider/item_details_provider.dart';
import 'package:baylora_prjct/feature/post/screens/edit_listing_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ManageListingScreen extends ConsumerWidget {
  final String itemId;

  const ManageListingScreen({super.key, required this.itemId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemAsync = ref.watch(itemDetailsProvider(itemId));

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text("Manage Listing", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.white,
        elevation: 0,
        foregroundColor: AppColors.black,
      ),
      body: itemAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Error: $err")),
        data: (item) {
          return _buildDashboard(context, ref, item);
        },
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, WidgetRef ref, Map<String, dynamic> item) {
    // 1. Extract Data
    final offers = List<Map<String, dynamic>>.from(item['offers'] ?? []);
    final status = item['status'] ?? 'active';
    final type = item['type'] ?? 'cash';
    final endTime = item['end_time'] != null ? DateTime.parse(item['end_time']) : null;

    // Sort offers: Pending first, then by amount/date
    offers.sort((a, b) {
      if (a['status'] == 'pending' && b['status'] != 'pending') return -1;
      if (b['status'] == 'pending' && a['status'] != 'pending') return 1;
      return 0;
    });

    // Auction Logic: Check Expiry
    bool isExpired = false;
    if (endTime != null && DateTime.now().isAfter(endTime)) {
      isExpired = true;
    }

    return SingleChildScrollView(
      padding: AppValues.paddingAll,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // A. Header Section (Your Item)
          _buildItemHeader(context, item, isExpired, status),

          AppValues.gapL,

          // B. Offers Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Offers (${offers.length})",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              // Optional: Filter Icon could go here
            ],
          ),
          AppValues.gapM,

          // C. Offers List
          if (offers.isEmpty)
            _buildEmptyState()
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: offers.length,
              separatorBuilder: (_, __) => const Divider(height: 24),
              itemBuilder: (context, index) {
                final offer = offers[index];
                return _OfferRowItem(
                  offer: offer,
                  isExpiredAuction: isExpired && type == 'cash',
                  isWinningBid: index == 0 && isExpired && type == 'cash', // Logic: Top bid wins if expired
                  onAccept: () => _handleAcceptOffer(context, ref, offer['id']),
                  onReject: () => _handleRejectOffer(context, ref, offer['id']),
                );
              },
            ),

          // Extra padding for safe area
          AppValues.gapXXL,
        ],
      ),
    );
  }

  Widget _buildItemHeader(BuildContext context, Map<String, dynamic> item, bool isExpired, String status) {
    final images = item['images'] as List<dynamic>? ?? [];
    final imageUrl = images.isNotEmpty ? images.first : '';

    return Container(
      padding: AppValues.paddingS,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppValues.borderRadiusL,
        border: Border.all(color: AppColors.greyLight),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 8,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // 1. Item Image
              ClipRRect(
                borderRadius: AppValues.borderRadiusM,
                child: Container(
                  width: 80,
                  height: 80,
                  color: AppColors.greyLight,
                  child: imageUrl.isNotEmpty
                      ? Image.network(imageUrl, fit: BoxFit.cover)
                      : const Icon(Icons.image, color: AppColors.grey400),
                ),
              ),
              AppValues.gapM,

              // 2. Title & Price
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'] ?? 'No Title',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    AppValues.gapXS,
                    Text(
                      "₱${item['price']}",
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.royalBlue, fontSize: 16),
                    ),
                    AppValues.gapS,
                    // Status Badge
                    _buildStatusBadge(status, isExpired),
                  ],
                ),
              ),
            ],
          ),

          AppValues.gapM,

          // 3. Edit Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditListingScreen(itemId: item['id']),
                  ),
                );
              },
              icon: const Icon(Icons.edit, size: 16),
              label: const Text("Edit Item Details"),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.black,
                side: const BorderSide(color: AppColors.greyMedium),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status, bool isExpired) {
    String label = "Active";
    Color color = AppColors.successColor;

    if (status == 'sold' || status == 'accepted') {
      label = "Completed";
      color = AppColors.royalBlue;
    } else if (isExpired) {
      label = "Time Ended";
      color = AppColors.errorColor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 10),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Icon(Icons.inbox, size: 48, color: AppColors.greyMedium),
            AppValues.gapS,
            Text("No offers yet", style: TextStyle(color: AppColors.textGrey)),
          ],
        ),
      ),
    );
  }

  // --- ACTIONS ---

  Future<void> _handleAcceptOffer(BuildContext context, WidgetRef ref, String offerId) async {
    // 1. Show Confirmation
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Accept Offer?"),
        content: const Text("This will automatically reject all other offers. This action cannot be undone."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancel")),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Confirm")),
        ],
      ),
    );

    if (confirm != true) return;

    // 2. Call Supabase Logic
    // In a real app, do this in a controller. Here is the logic:
    // UPDATE offers SET status = 'accepted' WHERE id = offerId
    // UPDATE offers SET status = 'rejected' WHERE item_id = itemId AND id != offerId
    // UPDATE items SET status = 'sold' WHERE id = itemId

    // Simulating refresh for UI
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Offer Accepted!")));
    ref.invalidate(itemDetailsProvider(itemId));
  }

  Future<void> _handleRejectOffer(BuildContext context, WidgetRef ref, String offerId) async {
    // UPDATE offers SET status = 'rejected' WHERE id = offerId
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Offer Rejected")));
    ref.invalidate(itemDetailsProvider(itemId));
  }
}

// =========================================================
// WIDGET: INDIVIDUAL OFFER ROW
// =========================================================

class _OfferRowItem extends StatelessWidget {
  final Map<String, dynamic> offer;
  final bool isExpiredAuction;
  final bool isWinningBid;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const _OfferRowItem({
    required this.offer,
    required this.isExpiredAuction,
    required this.isWinningBid,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final bidder = offer['profiles'] ?? {};
    final username = bidder['username'] ?? 'User';
    final avatarUrl = bidder['avatar_url'];

    final cashAmount = (offer['cash_offer'] ?? 0).toDouble();
    final tradeImages = offer['swap_item_images'] as List<dynamic>? ?? [];
    final tradeImage = tradeImages.isNotEmpty ? tradeImages.first : null;
    final hasTrade = tradeImage != null;

    final status = offer['status'] ?? 'pending';
    final isRejected = status == 'rejected';
    final isAccepted = status == 'accepted';

    // AUCTION LOGIC: If expired, disable buttons unless it's the winner
    // If it is the winner, show "Deal Chat" button instead of accept/reject

    return Opacity(
      opacity: isRejected ? 0.5 : 1.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Avatar
          CircleAvatar(
            radius: 20,
            backgroundImage: (avatarUrl != null) ? NetworkImage(avatarUrl) : null,
            backgroundColor: AppColors.greyLight,
            child: (avatarUrl == null) ? const Icon(Icons.person, color: AppColors.grey400) : null,
          ),
          AppValues.gapM,

          // 2. Content (Name + Offer)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(username, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                AppValues.gapXS,

                // THE OFFER PAYLOAD
                if (hasTrade)
                  _buildTradePreview(context, tradeImage, cashAmount) // Trade/Mix
                else
                  Text( // Cash Only
                    "₱${cashAmount.toStringAsFixed(0)}",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.royalBlue),
                  ),

                if (isRejected)
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text("Rejected", style: TextStyle(color: AppColors.errorColor, fontSize: 12)),
                  ),
              ],
            ),
          ),

          // 3. Actions (Buttons)
          if (!isRejected && !isAccepted) ...[
            if (isExpiredAuction) ...[
              // AUCTION TIMEOUT STATE
              if (isWinningBid)
                ElevatedButton(
                  onPressed: () {}, // Navigate to Chat
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.royalBlue, padding: const EdgeInsets.symmetric(horizontal: 12)),
                  child: const Text("Deal Chat", style: TextStyle(color: Colors.white, fontSize: 12)),
                )
              else
                const Text("Lost", style: TextStyle(color: AppColors.textGrey, fontSize: 12))
            ] else ...[
              // STANDARD ACTIVE STATE
              IconButton(
                onPressed: onReject,
                icon: const Icon(Icons.close, color: AppColors.errorColor),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              AppValues.gapM,
              IconButton(
                onPressed: onAccept,
                icon: const Icon(Icons.check, color: AppColors.successColor),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ]
          ] else if (isAccepted) ...[
            // ALREADY ACCEPTED STATE
            ElevatedButton(
              onPressed: () {}, // Navigate to Chat
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.royalBlue, padding: const EdgeInsets.symmetric(horizontal: 12)),
              child: const Text("Deal Chat", style: TextStyle(color: Colors.white, fontSize: 12)),
            )
          ]
        ],
      ),
    );
  }

  // --- Trade Image Preview with Fullscreen Logic ---
  Widget _buildTradePreview(BuildContext context, String imageUrl, double cash) {
    return GestureDetector(
      onTap: () => _showFullScreenImage(context, imageUrl),
      child: Row(
        children: [
          Hero(
            tag: imageUrl, // For smooth animation
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
          ),
          if (cash > 0) ...[
            AppValues.gapS,
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.royalBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                "+ ₱${cash.toStringAsFixed(0)}",
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.royalBlue, fontSize: 12),
              ),
            )
          ]
        ],
      ),
    );
  }

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    Navigator.of(context).push(PageRouteBuilder(
      opaque: false,
      pageBuilder: (_, __, ___) => Scaffold(
        backgroundColor: Colors.black.withOpacity(0.9),
        body: Stack(
          children: [
            Center(
              child: Hero(
                tag: imageUrl,
                child: Image.network(imageUrl),
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}