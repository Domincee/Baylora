import 'dart:io';

import 'package:baylora_prjct/core/constant/app_strings.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
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
  // Updated filter options to match requirements
  String _selectedFilter = 'All'; 
  final List<String> _filters = ['All', 'For Sale', 'For Trade', 'Expired']; // Changed 'Ended' to 'Expired'

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
          // Filter Logic
          final filteredList = listings.where((item) {
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

            switch (_selectedFilter) {
              case 'Expired': // Changed from 'Ended' to 'Expired'
                // Logic: Show items that have ended (expired or explicit status)
                // This covers items that ran out of time or were marked sold/ended/accepted
                if (dbStatus == 'ended' || dbStatus == 'sold' || dbStatus == 'accepted') return true;
                if (isExpired) return true;
                return false;

              case 'For Sale':
                // Active Cash listings
                if (dbStatus != 'active') return false;
                if (isExpired) return false;
                return type == 'cash';

              case 'For Trade':
                // Active Trade listings
                if (dbStatus != 'active') return false;
                if (isExpired) return false;
                return type == 'trade';

              case 'All':
              default:
                // Show everything (Active history)
                return true; 
            }
          }).toList();

          return Column(
            children: [
              // Filter Tabs
              Container(
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
              ),

              // Filtered List
              Expanded(
                child: filteredList.isEmpty
                    ? Center(child: Text('No $_selectedFilter items found'))
                    : ListView.separated(
                        padding: AppValues.paddingAll,
                        itemCount: filteredList.length,
                        separatorBuilder: (context, index) => AppValues.gapM,
                        itemBuilder: (context, index) {
                          final item = filteredList[index];
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

                          if (dbStatus == 'sold') {
                            displayStatus = 'Sold';
                          } else if (dbStatus == 'accepted') {
                            displayStatus = 'Accepted';
                          } else {
                            if (item['end_time'] != null) {
                              try {
                                endTime = DateTime.parse(item['end_time']);
                                if (DateTime.now().isAfter(endTime)) {
                                  displayStatus = 'Expired'; // Changed from 'Ended' to 'Expired'
                                }
                              } catch (_) {}
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
                            endTime: endTime,
                          );
                        },
                      ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) {
          final isNetworkError = err is SocketException ||
            (err.toString().contains('SocketException')) ||
            (err.toString().contains('Network is unreachable')) ||
            (err.toString().contains('Connection refused'));

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
        },
      ),
    );
  }
}
