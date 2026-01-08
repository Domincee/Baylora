import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/details/constants/item_details_strings.dart';
import 'package:flutter/material.dart';

class ListingSummaryCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final Widget? bottomAction;

  const ListingSummaryCard({
    super.key,
    required this.item,
    this.bottomAction,
  });

  @override
  Widget build(BuildContext context) {
    // Logic extraction
    final status = item['status'] ?? 'active';
    final type = item['type'] ?? ItemDetailsStrings.typeCash;
    final isTrade = type == ItemDetailsStrings.typeTrade;
    final isMix = type == ItemDetailsStrings.typeMix;

    final endTimeStr = item['end_time'];
    final endTime = endTimeStr != null ? DateTime.tryParse(endTimeStr) : null;
    final isExpired = endTime != null && DateTime.now().isAfter(endTime);

    final images = item['images'] as List<dynamic>? ?? [];
    final imageUrl = images.isNotEmpty ? images.first : '';

    return Container(
      padding: AppValues.paddingS,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppValues.borderRadiusL,
        border: Border.all(color: AppColors.greyLight),
        boxShadow: const [
          BoxShadow(color: AppColors.shadowColor, blurRadius: 8, offset: Offset(0, 4))
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: AppValues.borderRadiusM,
                child: Container(
                  width: 80, height: 80, color: AppColors.greyLight,
                  child: imageUrl.isNotEmpty
                      ? Image.network(imageUrl, fit: BoxFit.cover)
                      : const Icon(Icons.image, color: AppColors.grey400),
                ),
              ),
              AppValues.gapHS,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['title'] ?? 'No Title', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
                    AppValues.gapXS,
                    if (isMix) ...[
                      Text("Minimum to Bid: ₱${item['price'] ?? 0}", style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.black, fontSize: 14)),
                    ] else if (isTrade) ...[
                      const Text("Trade Only", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.royalBlue, fontSize: 14)),
                    ] else ...[
                      Text("Minimum to Bid: ₱${item['price'] ?? 0}", style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.royalBlue, fontSize: 16)),
                    ],
                    AppValues.gapS,
                    Row(
                      children: [
                        _buildStatusBadge(status, isExpired),
                        const SizedBox(width: 8),
                        _buildConditionBadge(item['condition'] ?? 'Used'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (bottomAction != null) ...[
            AppValues.gapM,
            SizedBox(width: double.infinity, child: bottomAction),
          ],
        ],
      ),
    );
  }

  Widget _buildConditionBadge(String condition) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: AppColors.greyLight, borderRadius: BorderRadius.circular(4)),
      child: Text(condition, style: const TextStyle(color: AppColors.textDarkGrey, fontWeight: FontWeight.bold, fontSize: 10)),
    );
  }

  Widget _buildStatusBadge(String status, bool isExpired) {
    String label = "Active";
    Color color = AppColors.successColor;

    if (status == 'sold') {
      label = "Sold";
      color = AppColors.royalBlue;
    } else if (status == 'accepted') {
      label = "Deal Pending";
      color = AppColors.royalBlue;
    } else if (isExpired) {
      label = "Time Ended";
      color = AppColors.errorColor;
    } else if (status == 'rejected') {
      label = "Rejected";
      color = AppColors.errorColor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 10),
      ),
    );
  }
}
