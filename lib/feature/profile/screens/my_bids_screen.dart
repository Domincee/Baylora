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
    ProfileStrings.filterForSale,
    ProfileStrings.filterForTrade,
    ProfileStrings.filterAccepted, // Add this
    ProfileStrings.filterSold,     // Add this
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

      final dbItemStatus = item['status']?.toString().toLowerCase();
      final dbBidStatus = bid['status']?.toString().toLowerCase();

      // --- NEW: Filter Accepted ---
      if (_selectedFilter == ProfileStrings.filterAccepted) {
        return dbBidStatus == ProfileStrings.dbStatusAccepted;
      }

      // --- NEW: Filter Sold ---
      if (_selectedFilter == ProfileStrings.filterSold) {
        return dbItemStatus == ProfileStrings.dbStatusSold;
      }

      // --- Existing Expired Logic (Modified to be cleaner) ---
      if (_selectedFilter == ProfileStrings.filterExpired) {
        final endTimeStr = item['end_time'] as String?;
        bool isTimeExpired = false;
        if (endTimeStr != null) {
          final endTime = DateTime.tryParse(endTimeStr);
          isTimeExpired = endTime != null && DateTime.now().isAfter(endTime);
        }
        // Show if time ran out OR if it's explicitly marked as ended/rejected
        return isTimeExpired || dbBidStatus == ProfileStrings.dbStatusRejected;
      }

      // --- Existing Sale/Trade logic (ensure we only show active ones) ---
      if (_selectedFilter == ProfileStrings.filterForSale || _selectedFilter == ProfileStrings.filterForTrade) {
        // Don't show accepted/sold items in the general sale/trade tabs
        if (dbItemStatus != ProfileStrings.dbStatusActive) return false;

        final double cashOffer = (bid['cash_offer'] as num?)?.toDouble() ?? 0.0;
        final bool hasTrade = bid['swap_item_text'] != null && bid['swap_item_text']!.isNotEmpty;

        if (_selectedFilter == ProfileStrings.filterForSale) return cashOffer > 0 && !hasTrade;
        if (_selectedFilter == ProfileStrings.filterForTrade) return hasTrade;
      }

      return true; // Default: All
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

        String displayStatus = ProfileStrings.statusActive;
        final bidStatus = bid['status']?.toString().toLowerCase(); // Safe check?
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

            final itemId = item['id'].toString();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ItemDetailsScreen(itemId: itemId),
              ),
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
