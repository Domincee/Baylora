import 'package:baylora_prjct/core/constant/app_values_widget.dart';
import 'package:baylora_prjct/feature/home/widgets/category.dart';
import 'package:baylora_prjct/feature/home/widgets/item_card.dart';
import 'package:baylora_prjct/feature/home/widgets/search_bar.dart'; 
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // State for filters
  String selectedFilter = "All";
  final List<String> filters = ["All", "Hot", "New", "Ending", "Near"];

  // Stream state variable to prevent re-creation on every build
  late Stream<List<Map<String, dynamic>>> _itemsStream;

  @override
  void initState() {
    super.initState();
    // Initialize the stream once
    _itemsStream = _buildQueryStream();
  }

  // Logic to build the stream based on selectedFilter
  Stream<List<Map<String, dynamic>>> _buildQueryStream() {
    var query = Supabase.instance.client
        .from('items')
        .select('*, profiles:owner_id(username, avatar_url, rating, total_trades)');

    switch (selectedFilter) {
      case 'Ending':
        return query
            .not('end_time', 'is', null)
            .gt('end_time', DateTime.now().toIso8601String())
            .order('end_time', ascending: true)
            .asStream();
      
      case 'Hot':
        return query.order('price', ascending: false).asStream();

      case 'Near':
        return query.order('created_at', ascending: false).asStream();

      case 'New':
      case 'All':
      default:
        return query.order('created_at', ascending: false).asStream();
    }
  }

  // Called when a filter category is tapped
  void _onFilterChanged(String newFilter) {
    if (selectedFilter == newFilter) return;
    
    setState(() {
      selectedFilter = newFilter;
      _itemsStream = _buildQueryStream(); // Update the stream
    });
  }

  String _getTimeAgo(String? dateString) {
    if (dateString == null) return 'Just now';
    final date = DateTime.parse(dateString).toLocal();
    final difference = DateTime.now().difference(date);

    if (difference.inDays > 1) return '${difference.inDays} days ';
    if (difference.inDays == 1) return 'Yesterday';
    if (difference.inHours >= 1) return '${difference.inHours}h ';
    if (difference.inMinutes >= 1) return '${difference.inMinutes}m ';
    return 'Just now';
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
                    children: filters.map((filter) {
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
                  // Log error for debugging
                  debugPrint('Error loading items: ${snapshot.error}');
                  return Center(child: Text('Something went wrong.'));
                }

                final items = snapshot.data ?? []; 
                if (items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.inbox_outlined, size: 50, color: Colors.grey),
                        const SizedBox(height: 10),
                        Text('No "$selectedFilter" items found'),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  padding: AppValuesWidget.padding,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 30,
                    maxCrossAxisExtent: 500,
                    childAspectRatio: 1.5, 
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final profile = item['profiles'] ?? {}; 
                    final List<dynamic> images = item['images'] ?? [];
                    final String firstImage = images.isNotEmpty 
                        ? images[0] 
                        : 'https://via.placeholder.com/300'; 

                    return ItemCard(
                      title: item['title'] ?? 'No Title',
                      description: item['description'] ?? '',
                      price: (item['price'] ?? 0).toString(),
                      type: item['type'] ?? 'cash',
                      swapItem: item['swap_preference'] ?? '',
                      imagePath: firstImage,
                      postedTime: _getTimeAgo(item['created_at']),
                      isVerified: item['is_verified'] ?? false,
                      sellerName: profile['username'] ?? 'Unknown',
                      sellerImage: profile['avatar_url'] ?? 'https://i.pravatar.cc/150',
                      rating: (profile['rating'] ?? 0.0).toString(),
                      totalTrade: (profile['total_trades'] ?? 0).toString(),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
