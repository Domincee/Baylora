import 'package:baylora_prjct/core/constant/app_strings.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/profile/constant/profile_strings.dart';
import 'package:baylora_prjct/feature/profile/provider/profile_provider.dart';
import 'package:baylora_prjct/feature/profile/widgets/listing_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyListingsScreen extends ConsumerWidget {
  const MyListingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listingsAsync = ref.watch(myListingsProvider);

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: const Text(ProfileStrings.listingsTitle),
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.black),
        titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.black,
              fontWeight: FontWeight.w600,
            ),
      ),
      body: listingsAsync.when(
        data: (listings) {
          if (listings.isEmpty) {
            return const Center(child: Text(ProfileStrings.noListings));
          }
          return ListView.separated(
            padding: AppValues.paddingAll,
            itemCount: listings.length,
            separatorBuilder: (context, index) => AppValues.gapM,
            itemBuilder: (context, index) {
              final item = listings[index];
              final images = item['images'] as List?;
              final tags =
                  item['tags'] != null ? List<String>.from(item['tags']) : <String>[];

              // Logic to determine display status
              String displayStatus = item['status'] ?? 'Active';
              if (item['end_time'] != null) {
                try {
                  final endTime = DateTime.parse(item['end_time']);
                  if (DateTime.now().isAfter(endTime)) {
                    displayStatus = 'Ended';
                  }
                } catch (_) {}
              }

              return ListingCard(
                title: item['title'] ?? 'Untitled',
                price: item['price']?.toString(),
                subtitle: item['swap_preference'],
                tags: tags,
                offers: "${item['offer_count'] ?? 0} Offers",
                postedTime: ProfileStrings.recently,
                status: displayStatus,
                imageUrl: (images != null && images.isNotEmpty) ? images[0] : null,
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("${AppStrings.error}: $err")),
      ),
    );
  }
}
