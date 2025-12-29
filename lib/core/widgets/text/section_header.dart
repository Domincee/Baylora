import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String subTitle;
  const SectionHeader({super.key, required this.title, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: const [
                  Text("All", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                  Icon(Icons.keyboard_arrow_down, color: Colors.blue, size: 16)
                ],
              ),
            )
          ],
        ),
        Text(subTitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}
