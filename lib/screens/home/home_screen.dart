import 'package:baylora_prjct/constant/app_values_widget.dart';
import 'package:baylora_prjct/constant/app_strings.dart';
import 'package:baylora_prjct/theme/app_colors.dart';
import 'package:baylora_prjct/widgets/category.dart';
import 'package:baylora_prjct/widgets/item_card.dart'; 
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // State for filters
  String selectedFilter = "All";
  final List<String> filters = ["All", "Hot", "New", "Ending","Near"];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
            Column(
              children: [
               Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // A. Search Bar

                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadowColor,
                              blurRadius: AppValuesWidget.borderRadius,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        
                        child: const TextField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search, color: Colors.grey),
                            hintText: AppStrings.searchText,
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 15),
                          ),
                        ),
                      ),

                      const SizedBox(height: AppValuesWidget.sizedBoxSize,),

                      // B. Filters
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: 
                              filters.map((filter) {
                                
                                // This assumes you have the Category/FilterPill widget defined
                                return Category(
                                  label: filter,
                                  isSelected: selectedFilter == filter,
                                  onTap: () {
                                    setState(() {
                                      selectedFilter = filter;
                                    });
                                  },
                                );
                              }).toList(),
                            ),

                            SizedBox(height: AppValuesWidget.sizedBoxSize,),
                                // C. Header Text
                           Text(
                            "$selectedFilter Items" ,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding:
                     const EdgeInsets.symmetric(horizontal: AppValuesWidget.appbarHorPad, vertical: AppValuesWidget.appbarVertPad),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                       // 2 items per row
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 30,
                        maxCrossAxisExtent: 500,
                      ),
                      itemCount: 4, // 4 cards
                      itemBuilder: (context, index) {
                     
                        String currentType = 'cash';
                        if (index % 3 == 1) currentType = 'trade';
                        if (index % 3 == 2) currentType = 'mix';
                    
                        return ItemCard(
                          title: "Item #$index title test",
                          sellerName: "FAfa",
                          price: "45,000",
                          swapItem: "Macbook Pro", // Only used if type is trade/mix
                          type: currentType, // <--- Passes 'cash', 'trade', or 'mix'
                          imagePath: "https://picsum.photos/200",
                          sellerImage: "https://i.pravatar.cc/150",
                          rating: " 4.5",
                          postedTime: "2 hours ago",
                          description: "This is a description test item",
                          isVerified: (index % 2 == 0),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }

}
