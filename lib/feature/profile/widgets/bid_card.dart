import 'package:flutter/material.dart';

class BidCard extends StatelessWidget {
  final String title;
  final String myOffer;
  final String timer;
  final String postedTime;
  final String status;
  final String? extraStatus;
  final String? imageUrl;

  const BidCard({
    super.key,
    required this.title,
    required this.myOffer,
    required this.timer,
    required this.postedTime,
    required this.status,
    this.extraStatus,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              image: imageUrl != null ? DecorationImage(image: NetworkImage(imageUrl!), fit: BoxFit.cover) : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                RichText(text: TextSpan(
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                  children: [
                    const TextSpan(text: "You offered\n"),
                    TextSpan(text: myOffer, style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w600)),
                  ]
                )),
                if (extraStatus != null)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: extraStatus == "Winning" ? Colors.deepPurpleAccent : Colors.grey[200],
                      borderRadius: BorderRadius.circular(4)
                    ),
                    child: Text(extraStatus!, style: TextStyle(fontSize: 9, color: extraStatus == "Winning" ? Colors.white : Colors.grey)),
                  ),
                const SizedBox(height: 4),
                Text(timer, style: const TextStyle(fontSize: 10, color: Colors.red)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(8)),
                child: Text(status, style: TextStyle(color: Colors.blue[800], fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 30),
              Container(
                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                 decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
                 child: const Text("View Item", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
              )
            ],
          )
        ],
      ),
    );
  }
}
