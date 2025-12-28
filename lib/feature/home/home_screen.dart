import 'package:baylora_prjct/core/constant/app_values_widget.dart';
import 'package:baylora_prjct/feature/home/mapper/item_card_mapper.dart';
import 'package:baylora_prjct/feature/home/provider/home_provider.dart';
import 'package:baylora_prjct/feature/home/util/item_filter_util.dart';
import 'package:baylora_prjct/feature/home/widgets/category.dart';
import 'package:baylora_prjct/feature/home/widgets/item_card.dart';
import 'package:baylora_prjct/feature/home/widgets/search_bar.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomeSearchBar(),
                const SizedBox(height: AppValuesWidget.sizedBoxSize),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ItemFilterUtil.categories.map((filter) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 10), 
                        child: Category(
                          label: filter,
                          isSelected: selectedFilter == filter,
                          onTap: () => _onFilterChanged(filter), 
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: AppValuesWidget.sizedBoxSize),

                Text(
                  "$selectedFilter Items",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.inbox_outlined, size: 50, color: Colors.grey),
                            const SizedBox(height: 10),
                            Text('No "$selectedFilter" items found'),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _refreshItems,
                  child: GridView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: AppValuesWidget.padding,
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 30,
                      maxCrossAxisExtent: 500,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final data = ItemCardMapper.map(item);

                      return ItemCard(
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
                      );
                    }
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
