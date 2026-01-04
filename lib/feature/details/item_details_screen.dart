import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/core/util/uni_image.dart';
import 'package:baylora_prjct/feature/home/util/date_util.dart';
import 'package:baylora_prjct/feature/home/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ItemDetailsScreen extends StatefulWidget {
  final String itemId;

  const ItemDetailsScreen({super.key, required this.itemId});

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  late Future<Map<String, dynamic>> _itemFuture;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _itemFuture = _fetchItemDetails();
  }

  Future<Map<String, dynamic>> _fetchItemDetails() async {
    try {
      final response = await Supabase.instance.client
          .from('items')
          .select('*, profiles(*), offers(*, profiles(*))')
          .eq('id', widget.itemId)
          .single();
      return response;
    } catch (e) {
      debugPrint('Error fetching item details: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: FutureBuilder<Map<String, dynamic>>(
        future: _itemFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: AppColors.errorColor, size: 48),
                    AppValues.gapM,
                    Text(
                      'Failed to load item.\n${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.textGrey),
                    ),
                    AppValues.gapM,
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _itemFuture = _fetchItemDetails();
                        });
                      },
                      child: const Text('Retry'),
                    )
                  ],
                ),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("Item not found"));
          }

          return _buildContent(context, snapshot.data!);
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, Map<String, dynamic> item) {
    // 1. Parse Data
    final seller = item['profiles'] ?? {};
    final List<dynamic> rawOffers = item['offers'] ?? [];
    
    // Sort offers: Highest amount first
    final List<dynamic> offers = List.from(rawOffers);
    offers.sort((a, b) {
      final amtA = (a['amount'] ?? 0) as num;
      final amtB = (b['amount'] ?? 0) as num;
      return amtB.compareTo(amtA);
    });

    final highestOffer = offers.isNotEmpty ? offers.first['amount'] : null;
    final basePrice = item['price'];
    final displayPrice = highestOffer ?? basePrice;

    final List<dynamic> images = (item['images'] as List<dynamic>?) ?? [];
    final String title = item['title'] ?? 'No Title';
    final String description = item['description'] ?? '';
    final String type = item['type'] ?? 'sale'; 
    final String category = item['category'] ?? 'General';
    final String condition = item['condition'] ?? 'Used';
    final DateTime? endTime = item['end_time'] != null ? DateTime.tryParse(item['end_time']) : null;
    final String createdAtStr = item['created_at'];

    // Check Ownership
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;
    final ownerId = item['user_id'];
    final isOwner = currentUserId != null && currentUserId == ownerId;

    return Stack(
      children: [
        // --- SCROLLABLE CONTENT ---
        Positioned.fill(
          bottom: 80, // Leave space for the bottom action bar
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // A. Images Header
                _buildImageHeader(context, images),

                Padding(
                  padding: EdgeInsets.all(AppValues.spacingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // B. Seller Info
                      _buildSellerRow(context, seller, createdAtStr),
                      AppValues.gapM,

                      // C. Title & Tags
                      Text(
                        title,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                      ),
                      AppValues.gapS,
                      _buildTagsRow(context, category, condition, type, endTime),
                      AppValues.gapL,

                      // D. Description
                      Text(
                        "Description",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      AppValues.gapXS,
                      Text(
                        description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textGrey,
                              height: 1.5,
                            ),
                      ),
                      AppValues.gapL,

                      // E. Price Section
                      Text(
                        offers.isNotEmpty ? "Current Highest Bid" : "Price",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppColors.textGrey,
                            ),
                      ),
                      AppValues.gapXXS,
                      Text(
                        "₱ ${displayPrice.toString()}",
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: AppColors.highLightTextColor, // Blue
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      AppValues.gapL,

                      // F. Bid History
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Current Bids",
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            "Offers",
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textGrey,
                                ),
                          ),
                        ],
                      ),
                      AppValues.gapM,
                      _buildBidList(context, offers),
                      
                      // Extra padding at bottom for scrolling past the floating button
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // --- APP BAR (Transparent Overlay) ---
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Container(
              margin: const EdgeInsets.only(left: 8),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white54,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 8),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white54,
                ),
                child: IconButton(
                  icon: const Icon(Icons.share_outlined, color: AppColors.black),
                  onPressed: () {},
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 16),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white54,
                ),
                child: IconButton(
                  icon: const Icon(Icons.favorite_border, color: AppColors.black),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),

        // --- BOTTOM ACTION BAR ---
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.all(AppValues.spacingM),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowColor.withValues(alpha: 0.5),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isOwner 
                      ? null 
                      : () {
                          // TODO: Implement Place Bid logic
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isOwner ? AppColors.greyDisabled : AppColors.tradeIconColor, // Purple or Grey
                    disabledBackgroundColor: AppColors.greyDisabled,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppValues.radiusCircular),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    isOwner ? "Your Item" : "Place Bid",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --- WIDGET HELPERS ---

  Widget _buildImageHeader(BuildContext context, List<dynamic> images) {
    if (images.isEmpty) {
      return Container(
        height: 300,
        width: double.infinity,
        color: AppColors.greyLight,
        child: const Center(
          child: Icon(Icons.image_not_supported, size: 50, color: AppColors.textGrey),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 300,
          width: double.infinity,
          child: PageView.builder(
            itemCount: images.length,
            onPageChanged: (index) => setState(() => _currentImageIndex = index),
            itemBuilder: (context, index) {
              return UniversalImage(
                path: images[index],
                fit: BoxFit.cover,
                width: double.infinity,
              );
            },
          ),
        ),
        if (images.length > 1) ...[
          AppValues.gapS,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(images.length, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentImageIndex == index ? 20 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentImageIndex == index
                      ? AppColors.royalBlue
                      : AppColors.grey300,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }

  Widget _buildSellerRow(BuildContext context, Map<String, dynamic> seller, String createdAtStr) {
    final username = seller['username'] ?? 'Unknown';
    final avatarUrl = seller['avatar_url'] ?? '';
    final isVerified = seller['is_verified'] ?? false;
    final rating = (seller['rating'] ?? 0.0).toString();
    final trades = (seller['total_trades'] ?? 0).toString();

    return Row(
      children: [
        ProfileAvatar(imageUrl: avatarUrl, size: 48),
        AppValues.gapHM,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "@$username",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (isVerified) ...[
                    AppValues.gapHXXS,
                    const Icon(Icons.verified, size: 16, color: AppColors.blueText),
                  ],
                ],
              ),
              Text(
                DateUtil.getTimeAgo(createdAtStr),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textGrey,
                    ),
              ),
            ],
          ),
        ),
        // Rating Pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.greyLight,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const Icon(Icons.star_rounded, color: AppColors.starColor, size: 18),
              const SizedBox(width: 4),
              Text(
                "$rating · $trades trades",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDarkGrey,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTagsRow(BuildContext context, String category, String condition, String type, DateTime? endTime) {
    final remainingTime = DateUtil.getRemainingTime(endTime);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildPill(context, "Category: $category", AppColors.greyLight, AppColors.textDarkGrey),
        _buildPill(context, condition, AppColors.greyLight, AppColors.textDarkGrey),
        _buildPill(
          context,
          type == 'auction' ? 'Auction' : (type == 'trade' ? 'Trade Only' : 'Cash Only'),
          AppColors.tealLight, // Using cyan/teal-ish color
          AppColors.tealText,
        ),
        if (remainingTime != null)
          _buildPill(
            context,
            remainingTime,
            AppColors.errorColor.withValues(alpha: 0.1),
            AppColors.errorColor,
          ),
      ],
    );
  }

  Widget _buildPill(BuildContext context, String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  Widget _buildBidList(BuildContext context, List<dynamic> offers) {
    if (offers.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Icon(Icons.local_offer_outlined, size: 40, color: AppColors.grey300),
              AppValues.gapXS,
              Text(
                "No bids yet. Be the first!",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textGrey,
                    ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: offers.length > 5 ? 5 : offers.length, // Show max 5 recent bids
      separatorBuilder: (context, index) => const Divider(height: 16),
      itemBuilder: (context, index) {
        final offer = offers[index];
        final bidder = offer['profiles'] ?? {};
        final amount = offer['amount'] ?? 0;
        final timeAgo = DateUtil.getTimeAgo(offer['created_at']);

        return Row(
          children: [
            ProfileAvatar(imageUrl: bidder['avatar_url'] ?? '', size: 36),
            AppValues.gapHS,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "@${bidder['username'] ?? 'Unknown'}",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    timeAgo,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textGrey,
                          fontSize: 12,
                        ),
                  ),
                ],
              ),
            ),
            Text(
              "₱ $amount",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        );
      },
    );
  }
}
