import 'package:flutter/material.dart';

class ItemDetailsScreen extends StatelessWidget {
  final String itemId;

  const ItemDetailsScreen({super.key, required this.itemId});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text("Item Details")),
      body: Center(
        child: Text('Item Details for ID: $itemId'),
      ),
    );
  }
}