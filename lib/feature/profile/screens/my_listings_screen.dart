import 'package:baylora_prjct/core/constant/app_strings.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/core/util/network_utils.dart';
import 'package:baylora_prjct/feature/profile/constant/profile_strings.dart';
import 'package:baylora_prjct/feature/profile/provider/profile_provider.dart';
import 'package:baylora_prjct/feature/profile/widgets/management_listing_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyListingsScreen extends ConsumerStatefulWidget {
  const MyListingsScreen({super.key});

  @override
  ConsumerState<MyListingsScreen> createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends ConsumerState<MyListingsScreen> {
  String _selectedFilter = ProfileStrings.filterAll;
  
  final List<String> _filters = [
    ProfileStrings.filterAll, 
    ProfileStrings.filterForSale, 
    ProfileStrings.filterForTrade, 
    ProfileStrings.filterExpired
  ];

  @override
  Widget build(BuildContext context) {
    final listingsAsync = ref.watch(myListingsProvider);

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: const Text(ProfileStrings.listingsTitle),
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.black),
        titleTextStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.black,
              fontWeight: FontWeight.w600,
            ),
        centerTitle: true,
      ),
      body: listingsAsync.when(
        data: (listings) {
          final filteredList = _getFilteredList(listings);

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

  List<Map<String, dynamic>> _getFilteredList(List<Map<String, dynamic>> listings) {
    return listings.where((item) {
      final endTimeStr = item['end_time'] as String?;
      final dbStatus = item['status']?.toString().toLowerCase();
      final type = item['type']?.toString().toLowerCase();
      bool isExpired = false;
      
      if (endTimeStr != null) {
        try {
          final endTime = DateTime.parse(endTimeStr);
          isExpired = DateTime.now().isAfter(endTime);
        } catch (_) {}
      }

      if (_selectedFilter == ProfileStrings.filterExpired) {
        if (dbStatus == ProfileStrings.dbStatusEnded || 
            dbStatus == ProfileStrings.dbStatusSold || 
            dbStatus == ProfileStrings.dbStatusAccepted) {
          return true;
        }
        if (isExpired) return true;
        return false;
      }

      if (_selectedFilter == ProfileStrings.filterForSale) {
        if (dbStatus != ProfileStrings.dbStatusActive) return false;
        if (isExpired) return false;
        return type == ProfileStrings.typeCash;
      }

      if (_selectedFilter == ProfileStrings.filterForTrade) {
        if (dbStatus != ProfileStrings.dbStatusActive) return false;
        if (isExpired) return false;
        return type == ProfileStrings.typeTrade;
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
        final item = filteredList[index];
        return _buildListItem(item);
      },
    );
  }

  Widget _buildListItem(Map<String, dynamic> item) {
    final images = item['images'] as List?;
    
    // Handle swap_preference
    final swapPref = item['swap_preference'];
    final List<String> lookingFor = (swapPref != null && swapPref.toString().isNotEmpty)
        ? swapPref.toString().split(',').map((e) => e.trim()).toList()
        : [];

    // Posted Date Parsing
    DateTime postedDate = DateTime.now();
    if (item['created_at'] != null) {
      try {
        postedDate = DateTime.parse(item['created_at']);
      } catch (_) {}
    }

    // Price Parsing
    double? price;
    if (item['price'] != null) {
      final parsedPrice = double.tryParse(item['price'].toString());
      if (parsedPrice != null && parsedPrice > 0) {
        price = parsedPrice;
      }
    }

    // Status Logic
    String displayStatus = ProfileStrings.statusActive;
    final dbStatus = item['status']?.toString().toLowerCase();
    
    DateTime? endTime;

    if (dbStatus == ProfileStrings.dbStatusSold) {
      displayStatus = ProfileStrings.statusSold;
    } else if (dbStatus == ProfileStrings.dbStatusAccepted) {
      displayStatus = ProfileStrings.statusAccepted;
    } else {
      if (item['end_time'] != null) {
        try {
          endTime = DateTime.parse(item['end_time']);
          if (DateTime.now().isAfter(endTime)) {
            displayStatus = ProfileStrings.statusExpired;
          }
        } catch (_) {}
      }
    }

    return ManagementListingCard(
      title: item['title'] ?? ProfileStrings.untitled,
      imageUrl: (images != null && images.isNotEmpty) ? images[0] : '',
      status: displayStatus,
      offerCount: item['offer_count'] ?? 0,
      postedDate: postedDate,
      price: price,
      lookingFor: lookingFor,
      endTime: endTime,
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
            onPressed: () => ref.refresh(myListingsProvider),
            child: const Text(AppStrings.retry),
          ),
        ],
      ),
    );
  }
}
