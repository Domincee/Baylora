import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/details/item_details_screen.dart';
import 'package:baylora_prjct/feature/home/mapper/item_card_mapper.dart';
import 'package:baylora_prjct/feature/home/provider/home_provider.dart';
import 'package:baylora_prjct/feature/home/util/item_filter_util.dart';
import 'package:baylora_prjct/feature/home/widgets/category.dart';
import 'package:baylora_prjct/feature/home/widgets/item_card.dart';
import 'package:baylora_prjct/feature/home/widgets/search_bar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String selectedFilter = "All";

  void _onFilterChanged(String newFilter) {
    if (selectedFilter == newFilter) return;
    setState(() {
      selectedFilter = newFilter;
    });
  }

  Future<void> _refreshItems() async {
    ref.invalidate(homeItemsProvider(selectedFilter));
    try {
      await ref.read(homeItemsProvider(selectedFilter).future);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final itemsAsync = ref.watch(homeItemsProvider(selectedFilter));

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: EdgeInsets.all(AppValues.spacingM),
              child: const CustomSearchBar(),
            ),

            // Category Filters
            CategoryFilter(
              categories: ItemFilterUtil.categories,
              selectedCategory: selectedFilter,
              onSelect: _onFilterChanged,
            ),

            AppValues.gapXS,

            // Items List
            Expanded(
              child: itemsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) {
                  debugPrint('Error loading items: $err');
                  return const Center(child: Text('Something went wrong.'));
                },
                data: (items) {
                  if (items.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: _refreshItems,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.inbox_outlined,
                                size: AppValues.iconXL,
                                color: AppColors.textGrey,
                              ),
                              AppValues.gapXS,
                              Text('No "$selectedFilter" items found'),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: _refreshItems,
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.all(AppValues.spacingM),
                      itemCount: items.length,
                      separatorBuilder: (context, index) => AppValues.gapM,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        final data = ItemCardMapper.map(item);

                        return GestureDetector(
                          onTap: () async {
                            EasyLoading.show(maskType: EasyLoadingMaskType.black);
                            // Brief delay to ensure smooth transition transition/feedback
                            await Future.delayed(const Duration(milliseconds: 300));
                            EasyLoading.dismiss();
                            
                            if (context.mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ItemDetailsScreen(
                                    itemId: item['id'].toString(),
                                  ),
                                ),
                              );
                            }
                          },
                          child: ItemCard(
                            title: data['title'],
                            description: data['description'],
                            price: data['price'],
                            type: data['type'],
                            swapItem: data['swapItem'],
                            imagePath: data['imagePath'],
                            postedTime: data['postedTime'],
                            isVerified: data['isVerified'],
                            sellerName: data['sellerName'],
                            sellerImage: data['sellerImage'],
                            rating: data['rating'],
                            totalTrade: data['totalTrade'],
                            timeRemaining: data['timeRemaining'],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
