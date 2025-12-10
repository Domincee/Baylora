import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  final String postedTime;
  /* seller info */
  final String sellerName;
  final String sellerImage;

  final bool isVerified;
  final String totalTrade;

  final String rating;
  final bool isRated;
  /* item info */
  final String type;

  final String price;
  final String swapItem;

  final String title;
  final String description;
  final String imagePath;

  const ItemCard({
    super.key,
    required this.postedTime,

    required this.sellerName,
    required this.sellerImage,

    this.isRated = false,
    this.isVerified = false,

    this.rating = "0.0",
    this.totalTrade = "0.0",

    required this.type,

    this.price = "0.0",
    this.swapItem = "",

    required this.title,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // LEFT GROUP: Avatar + name + time
                Row(
                  spacing: 20,
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: AssetImage(sellerImage),
                    ),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("@ $sellerName"),
                        Text("$postedTime ago"),
                      ],
                    ),
                  ],
                ),
                // RATING
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  spacing: 20,
                  children: [
                      Text(rating),
                      // TOTAL TRADE
                      Text(totalTrade),
                  ],
                )
            
              ],
            ),
          ),

          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Title
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(description),
                  _buildPriceRow(),
                ],
              ),
            ),
          ),

          // IMAGE SECTION (Unchanged)
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                imagePath,
                width: double.infinity,
                fit: BoxFit.fill,
              ),
            ),
          ),

          // DETAILS SECTION
        ],
      ),
    );
  }

  // This function decides what to show based on the type
  Widget _buildPriceRow() {
    // 1. CASH Style
    if (type == 'cash') {
      return Text(
        "₱ $price",
        style: TextStyle(
          color: Color(0xFF8B5CF6),
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      );
    }
    // 2. TRADE Style
    else if (type == 'trade') {
      return Row(
        children: [
          Icon(
            Icons.swap_horiz,
            size: 16,
            color: Color(0xFF8B5CF6),
          ), // Purple Icon
          SizedBox(width: 4),
          Expanded(
            child: Text(
              swapItem.isNotEmpty
                  ? swapItem
                  : "Trade Only", // Show item name if available
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Color(0xFF8B5CF6),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      );
    }
    // 3. MIX Style (Cash OR Trade)
    else {
      return Row(
        children: [
          Text(
            "₱ ${price.replaceAll('000', 'k')}", // Shorten "45,000" to "45k" for space
            style: TextStyle(
              color: Color(0xFF8B5CF6),
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          SizedBox(width: 4),
          Text("or", style: TextStyle(fontSize: 10, color: Colors.grey)),
          SizedBox(width: 4),
          Icon(Icons.swap_horiz, size: 16, color: Color(0xFF8B5CF6)),
        ],
      );
    }
  }
}
