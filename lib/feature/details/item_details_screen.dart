import 'dart:io';

import 'package:baylora_prjct/core/constant/app_strings.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/details/constants/item_details_strings.dart';
import 'package:baylora_prjct/feature/details/controller/item_details_controller.dart';
import 'package:baylora_prjct/feature/details/widgets/item_details_app_bar.dart';
import 'package:baylora_prjct/feature/details/widgets/item_details_body.dart';
import 'package:baylora_prjct/feature/details/widgets/item_details_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ItemDetailsScreen extends StatefulWidget {
  final String itemId;

  const ItemDetailsScreen({super.key, required this.itemId});

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  late Future<Map<String, dynamic>> _itemFuture;

  @override
  void initState() {
    super.initState();
    _itemFuture = _fetchItemDetails();
  }

  Future<Map<String, dynamic>> _fetchItemDetails() async {
    try {
      final response = await Supabase.instance.client
          .from('items')
          .select('*, profiles(*), offers(*, profiles(*))')
          .eq('id', widget.itemId)
          .single();
      return response;
    } catch (e) {
      debugPrint('${ItemDetailsStrings.errorPrefix}$e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: FutureBuilder<Map<String, dynamic>>(
        future: _itemFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return _buildErrorState(snapshot.error);
          }

          if (!snapshot.hasData) {
            return const Center(child: Text(ItemDetailsStrings.itemNotFound));
          }

          return _buildContent(context, snapshot.data!);
        },
      ),
    );
  }

  Widget _buildErrorState(Object? error) {
    final bool isNetworkError = error is SocketException ||
        (error.toString().contains('SocketException')) ||
        (error.toString().contains('Network is unreachable')) ||
        (error.toString().contains('Connection refused'));

    final String message = isNetworkError
        ? AppStrings.noInternetConnection
        : '${ItemDetailsStrings.failedToLoad} ${error.toString()}';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isNetworkError ? Icons.wifi_off : Icons.error_outline,
              color: AppColors.errorColor,
              size: 48,
            ),
            AppValues.gapM,
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textGrey),
            ),
            AppValues.gapM,
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _itemFuture = _fetchItemDetails();
                });
              },
              child: const Text(AppStrings.retry),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Map<String, dynamic> item) {
    // 1. Data Processing via Controller
    final seller = item['profiles'] ?? {};
    final rawOffers = item['offers'] ?? [];
    
    final offers = ItemDetailsController.sortOffers(rawOffers);
    final displayPrice = ItemDetailsController.calculateDisplayPrice(offers, item['price']);
    final isOwner = ItemDetailsController.isOwner(item, seller);
    
    // 2. Parsed Fields
    final images = (item['images'] as List<dynamic>?) ?? [];
    final title = item['title'] ?? ItemDetailsStrings.noTitle;
    final description = item['description'] ?? ''; 
    final type = item['type'] ?? 'sale'; 
    final category = item['category'] ?? 'General';
    final condition = item['condition'] ?? 'Used';
    final endTime = ItemDetailsController.parseEndTime(item['end_time']);
    final createdAtStr = item['created_at'];

    return Stack(
      children: [
        // 1. Scrollable Content
        ItemDetailsBody(
          item: item,
          seller: seller,
          offers: offers,
          displayPrice: displayPrice,
          images: images,
          title: title,
          description: description,
          type: type,
          category: category,
          condition: condition,
          endTime: endTime,
          createdAtStr: createdAtStr,
        ),

        // 2. Transparent App Bar
        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: ItemDetailsAppBar(),
        ),

        // 3. Bottom Action Bar
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ItemDetailsBottomBar(
            isOwner: isOwner,
            isTrade: type == 'trade',
            isMix: type == 'mix',
            onPlaceBid: () {
              // TODO: Implement Place Bid logic
            },
          ),
        ),
      ],
    );
  }
}
