import 'package:baylora_prjct/core/constant/app_strings.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/profile/constant/profile_strings.dart';
import 'package:baylora_prjct/feature/profile/provider/profile_provider.dart';
import 'package:baylora_prjct/feature/profile/widgets/listing_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyListingsScreen extends ConsumerStatefulWidget {
  const MyListingsScreen({super.key});

  @override
  ConsumerState<MyListingsScreen> createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends ConsumerState<MyListingsScreen> {
  String _selectedFilter = 'All'; // 'All', 'Active', 'Ended'
  final List<String> _filters = ['All', 'Active', 'Ended'];

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
        titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
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
            bool isExpired = false;
            
            if (endTimeStr != null) {
              try {
                final endTime = DateTime.parse(endTimeStr);
                isExpired = DateTime.now().isAfter(endTime);
              } catch (_) {}
            }

            if (_selectedFilter == 'Active') {
              return !isExpired;
            } else if (_selectedFilter == 'Ended') {
              return isExpired;
            }
            return true; // 'All'
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
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
                          final tags = item['tags'] != null
                              ? List<String>.from(item['tags'])
                              : <String>[];

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
                            imageUrl: (images != null && images.isNotEmpty)
                                ? images[0]
                                : null,
                          );
                        },
                      ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("${AppStrings.error}: $err")),
      ),
    );
  }
}
