import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/home/util/date_util.dart';
import 'package:baylora_prjct/feature/home/widgets/profile_avatar.dart';

class BidList extends StatelessWidget {
  final List<dynamic> offers;

  const BidList({super.key, required this.offers});

  @override
  Widget build(BuildContext context) {
    if (offers.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Icon(Icons.local_offer_outlined, size: 40, color: AppColors.grey300),
              AppValues.gapXS,
              Text(
                "No bids yet. Be the first!",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textGrey,
                    ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: offers.length > 5 ? 5 : offers.length, // Show max 5 recent bids
      separatorBuilder: (context, index) => const Divider(height: 16),
      itemBuilder: (context, index) {
        final offer = offers[index];
        final bidder = offer['profiles'] ?? {};
        final amount = offer['amount'] ?? 0;
        final timeAgo = DateUtil.getTimeAgo(offer['created_at']);

        return Row(
          children: [
            ProfileAvatar(imageUrl: bidder['avatar_url'] ?? '', size: 36),
            AppValues.gapHS,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "@${bidder['username'] ?? 'Unknown'}",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    timeAgo,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textGrey,
                          fontSize: 12,
                        ),
                  ),
                ],
              ),
            ),
            Text(
              "₱ $amount",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        );
      },
    );
  }
}
