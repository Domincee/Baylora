import 'package:baylora_prjct/widgets/item_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1, // 2 items per row
                  childAspectRatio:
                      0.75, // Taller than wide (Standard card shape)
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: 4, // Let's test 4 cards
                itemBuilder: (context, index) {
                  // Logic to rotate through types for testing
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
                  );
                },
              ),
            ),
    );
  }

}
