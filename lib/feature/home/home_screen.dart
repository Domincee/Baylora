import 'package:baylora_prjct/core/constant/app_values_widget.dart';
import 'package:baylora_prjct/feature/home/widgets/category.dart';
import 'package:baylora_prjct/feature/home/widgets/item_card.dart';
import 'package:baylora_prjct/feature/home/widgets/search_bar.dart'; 
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Import Supabase

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  // State for filters
  String selectedFilter = "All";
  final List<String> filters = ["All", "Hot", "New", "Ending", "Near"];

  // --- CHANGED: This is now a getter (function) instead of a final variable ---
  // It runs every time the UI rebuilds, checking 'selectedFilter'
  Stream<List<Map<String, dynamic>>> get _itemsStream {
    
    // 1. Start the query
    var query = Supabase.instance.client
        .from('items')
        .select('*, profiles:owner_id(username, avatar_url, rating, total_trades)');

    // 2. Apply Filters based on the button clicked
    switch (selectedFilter) {
      case 'Ending':
        // Show items that HAVE an end_time, and order by which ends soonest
        return query
            .not('end_time', 'is', null) // Must have a timer
            .gt('end_time', DateTime.now().toIso8601String()) // Must not be expired
            .order('end_time', ascending: true)
            .asStream();
      
      case 'Hot':
        // Placeholder: Show most expensive items first
        // (In future, you can change this to sort by 'views' or 'offer_count')
        return query.order('price', ascending: false).asStream();

      case 'Near':
        // Placeholder: We don't have GPS data yet, so just return default
        return query.order('created_at', ascending: false).asStream();

      case 'New':
      case 'All':
      default:
        // Default: Show newest items first
        return query.order('created_at', ascending: false).asStream();
    }
  }

  // Helper to calculate time ago
  String _getTimeAgo(String? dateString) {
    if (dateString == null) return 'Just now';
    final date = DateTime.parse(dateString).toLocal();
    final difference = DateTime.now().difference(date);

    if (difference.inDays > 1) return '${difference.inDays} days ago';
    if (difference.inDays == 1) return 'Yesterday';
    if (difference.inHours >= 1) return '${difference.inHours}h ago';
    if (difference.inMinutes >= 1) return '${difference.inMinutes}m ago';
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
                // A. Search Bar
                const CustomeSearchBar(),
                const SizedBox(height: AppValuesWidget.sizedBoxSize),

                // B. Filters
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: filters.map((filter) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 10), 
                        child: Category(
                          label: filter,
                          isSelected: selectedFilter == filter,
                          onTap: () {
                            setState(() {
                              selectedFilter = filter;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: AppValuesWidget.sizedBoxSize),

                // C. Header Text
                Text(
                  "$selectedFilter Items",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // --- MAIN CONTENT ---
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              // IMPORTANT: We use the getter here. 
              // When setState is called above, this getter runs again with the new filter.
              stream: _itemsStream, 
              builder: (context, snapshot) {
                
                // 1. Loading State
                if (snapshot.connectionState == ConnectionState.waiting) {
                   return const Center(child: CircularProgressIndicator());
                }

                // 2. Error State
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                // 3. Empty State
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

                // 4. Success Grid
                return GridView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppValuesWidget.appbarHorPad, 
                    vertical: AppValuesWidget.appbarVertPad
                  ),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 30,
                    maxCrossAxisExtent: 500,
                    childAspectRatio: 0.7, 
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