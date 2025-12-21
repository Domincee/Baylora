import 'package:baylora_prjct/core/constant/app_values_widget.dart';
import 'package:baylora_prjct/feature/home/mapper/item_card_mapper.dart';
import 'package:baylora_prjct/feature/home/util/item_filter_util.dart'; // <--- IMPORT NEW HELPER
import 'package:baylora_prjct/feature/home/widgets/category.dart';
import 'package:baylora_prjct/feature/home/widgets/item_card.dart';
import 'package:baylora_prjct/feature/home/widgets/search_bar.dart'; 
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedFilter = "All";
  late Stream<List<Map<String, dynamic>>> _itemsStream;

  @override
  void initState() {
    super.initState();
    // Use the helper to get the stream
    _itemsStream = ItemFilterUtil.buildQueryStream(selectedFilter);
  }

  void _onFilterChanged(String newFilter) {
    if (selectedFilter == newFilter) return;
    setState(() {
      selectedFilter = newFilter;
      // Use the helper to update the stream
      _itemsStream = ItemFilterUtil.buildQueryStream(selectedFilter); 
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    // Use the helper list instead of hardcoding it here
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
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _itemsStream, 
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                   return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  debugPrint('Error loading items: ${snapshot.error}');
                  return const Center(child: Text('Something went wrong.'));
                }

                final items = snapshot.data ?? []; 
                
                if (items.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      setState(() {
                         _itemsStream = ItemFilterUtil.buildQueryStream(selectedFilter);
                      });
                      await _itemsStream.first;
                    },
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
                  onRefresh: () async {
                    setState(() {
                      _itemsStream = ItemFilterUtil.buildQueryStream(selectedFilter);
                    });
                    try { await _itemsStream.first; } catch (_) {}
                  },
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