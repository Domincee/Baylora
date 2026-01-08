import 'package:baylora_prjct/core/constant/app_strings.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/core/util/network_utils.dart';
import 'package:baylora_prjct/feature/details/item_details_screen.dart';
import 'package:baylora_prjct/feature/profile/constant/profile_strings.dart';
import 'package:baylora_prjct/feature/profile/provider/profile_provider.dart';
import 'package:baylora_prjct/feature/profile/widgets/management_listing_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyBidsScreen extends ConsumerStatefulWidget {
  const MyBidsScreen({super.key});

  @override
  ConsumerState<MyBidsScreen> createState() => _MyBidsScreenState();
}

class _MyBidsScreenState extends ConsumerState<MyBidsScreen> {
  String _selectedFilter = ProfileStrings.filterAll;
  
  final List<String> _filters = [
    ProfileStrings.filterAll, 
    ProfileStrings.filterForSale, // Represents items I bid cash on
    ProfileStrings.filterForTrade, // Represents items I offered a trade for
    ProfileStrings.filterExpired
  ];

  @override
  Widget build(BuildContext context) {
    final bidsAsync = ref.watch(myBidsProvider);

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: const Text(ProfileStrings.bidsTitle),
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.black),
        titleTextStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.black,
              fontWeight: FontWeight.w600,
            ),
        centerTitle: true,
      ),
      body: bidsAsync.when(
        data: (bids) {
          final filteredList = _getFilteredList(bids);

          return Column(
            children: [
              _buildFilterTabs(context),
              Expanded(
                child: filteredList.isEmpty
                    ? _buildEmptyState()
                    : _buildList(filteredList),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => _buildErrorState(err),
      ),
    );
  }

  // --- Logic Helpers ---

  List<Map<String, dynamic>> _getFilteredList(List<Map<String, dynamic>> bids) {
    return bids.where((bid) {
      final item = bid['items'] as Map<String, dynamic>?;
      if (item == null) return false;

      final endTimeStr = item['end_time'] as String?;
      final dbStatus = item['status']?.toString().toLowerCase();


      final double cashOffer = (bid['cash_offer'] as num?)?.toDouble() ?? 0.0;
      final String? swapText = bid['swap_item_text'];
      final bool hasCash = cashOffer > 0;
      final bool hasTrade = swapText != null && swapText.isNotEmpty;

      bool isExpired = false;
      if (endTimeStr != null) {
        try {
          final endTime = DateTime.parse(endTimeStr);
          isExpired = DateTime.now().isAfter(endTime);
        } catch (_) {}
      }

      if (_selectedFilter == ProfileStrings.filterExpired) {
        // Check if item status is ended/sold or time expired
        if (dbStatus == ProfileStrings.dbStatusEnded || 
            dbStatus == ProfileStrings.dbStatusSold || 
            dbStatus == ProfileStrings.dbStatusAccepted) {
          return true;
        }
        if (isExpired) return true;
        return false;
      }

      if (_selectedFilter == ProfileStrings.filterForSale) {
        // Show bids where I offered Cash (even if mixed)
        if (dbStatus != ProfileStrings.dbStatusActive) return false;
        if (isExpired) return false;
        return hasCash && !hasTrade; 
      }

      if (_selectedFilter == ProfileStrings.filterForTrade) {
        // Show bids where I offered Trade Item
        if (dbStatus != ProfileStrings.dbStatusActive) return false;
        if (isExpired) return false;
        return hasTrade && !hasCash;
      }

      // Default: All
      return true;
    }).toList();
  }

  // --- UI Builders ---

  Widget _buildFilterTabs(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.bgColor,
      padding: const EdgeInsets.symmetric(
        vertical: AppValues.spacingS, 
        horizontal: AppValues.spacingM
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _filters.map((filter) {
            final isSelected = _selectedFilter == filter;

            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ChoiceChip(
                label: Text(filter),
                selected: isSelected,
                onSelected: (bool selected) {
                  if (selected) {
                    setState(() {
                      _selectedFilter = filter;
                    });
                  }
                },
                backgroundColor: AppColors.white,
                selectedColor: AppColors.blueLight,
                labelStyle: TextStyle(
                  color: isSelected ? AppColors.blueText : AppColors.textGrey,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected ? AppColors.blueText : AppColors.grey300,
                  ),
                ),
                showCheckmark: false,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text('${ProfileStrings.noItemsFoundPrefix} $_selectedFilter ${ProfileStrings.noItemsFoundSuffix}'),
    );
  }

  Widget _buildList(List<Map<String, dynamic>> filteredList) {
    return ListView.separated(
      padding: AppValues.paddingAll,
      itemCount: filteredList.length,
      separatorBuilder: (context, index) => AppValues.gapM,
      itemBuilder: (context, index) {
        final bid = filteredList[index];
        final item = bid['items'] as Map<String, dynamic>; // Non-null checked in filter
        
        final images = item['images'] as List?;
        
        // Determine offer text & type
        double? price;
        List<String> lookingFor = [];
        
        final double cash = (bid['cash_offer'] as num?)?.toDouble() ?? 0.0;
        final String? swap = bid['swap_item_text'];
        
        // Map Offer data to ManagementListingCard format
        if (cash > 0) {
          price = cash;
        }
        
        if (swap != null && swap.isNotEmpty) {
          // If swap item has format "Title (Condition)", just show Title
          final cleanTitle = swap.split('(').first.trim();
          lookingFor = [cleanTitle];
        }

        // Determine Status based on BID status, not just ITEM status
        // bid['status'] could be pending, accepted, rejected
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

        // Date posted (using bid creation date to show when I placed bid)
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
          offerCount: 0, // Not relevant for my bids usually, or could be total offers on item
          postedDate: postedDate,
          price: price,
          lookingFor: lookingFor,
          endTime: endTime,
          onAction: () {
            // Navigate to Item Details Screen
            final itemId = item['id'].toString();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ItemDetailsScreen(itemId: itemId)),
            );
          }, 
          isMyBid: true,
        );
      },
    );
  }

  Widget _buildErrorState(Object err) {
    final isNetworkError = NetworkUtils.isNetworkError(err);

    final String message = isNetworkError
      ? AppStrings.noInternetConnection
      : "${AppStrings.error}: $err";

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isNetworkError ? Icons.wifi_off : Icons.error_outline,
            color: AppColors.errorColor,
            size: 48,
          ),
          AppValues.gapM,
          Text(message, textAlign: TextAlign.center),
          AppValues.gapM,
          ElevatedButton(
            onPressed: () => ref.refresh(myBidsProvider),
            child: const Text(AppStrings.retry),
          ),
        ],
      ),
    );
  }
}
