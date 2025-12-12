import 'package:baylora_prjct/widgets/item_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
            Padding(
              padding:
               const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
    );
  }

}
