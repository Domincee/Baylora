import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ManagementListingCard extends StatelessWidget {
  final String title;
  final String imageUrl; // Pass the FIRST image from the list here. If empty, pass ''.
  final String status; // 'active', 'sold', 'accepted', 'expired'
  final double? price;
  final List<String> lookingFor;
  final int offerCount;
  final DateTime postedDate;
  final DateTime? endTime;
  final VoidCallback? onAction;

  const ManagementListingCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.status,
    this.price,
    this.lookingFor = const [],
    required this.offerCount,
    required this.postedDate,
    this.endTime,
    this.onAction,
  });

  bool get isCash => price != null && lookingFor.isEmpty;
  bool get isTrade => price == null && lookingFor.isNotEmpty;
  bool get isMix => price != null && lookingFor.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppValues.paddingSmall,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppValues.borderRadiusL,
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: AppValues.borderRadiusM,
            child: Container(
              width: 80,
              height: 80,
              color: AppColors.greyLight,
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(
                        child: Icon(Icons.image_not_supported,
                            color: AppColors.grey400),
                      ),
                    )
                  : const Center(
                      child: Icon(Icons.image_not_supported,
                          color: AppColors.grey400),
                    ),
            ),
          ),
          AppValues.gapHS,
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                AppValues.gapXXS,
                _buildVariantContent(context),
                AppValues.gapXS,
                _buildFooter(context),
              ],
            ),
          ),
          AppValues.gapHS,
          // Status & Action
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildStatusBadge(context),
              AppValues.gapL,
              if (onAction != null || status != 'expired')
                _buildActionButton(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVariantContent(BuildContext context) {
    if (isCash) {
      return Text(
        "₱${price!.toStringAsFixed(0)}",
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.highLightTextColor,
              fontWeight: FontWeight.bold,
            ),
      );
    } else if (isTrade) {
      return _buildLookingFor(context);
    } else if (isMix) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "₱${price!.toStringAsFixed(0)}",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.highLightTextColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            "or trade for:",
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.subTextColor,
                  fontSize: 10,
                ),
          ),
          const SizedBox(height: 2),
          _buildLookingFor(context),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildLookingFor(BuildContext context) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: lookingFor.take(2).map((item) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.lavenderBlue,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            item,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.tealText,
                  fontSize: 10,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          offerCount == 0 ? "No offers yet" : "$offerCount Offers",
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textDarkGrey,
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
        ),
        Text(
          "Posted ${_getRelativeTime(postedDate)}",
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.subTextColor,
                fontSize: 10,
              ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    String text = status;
    Color bgColor = AppColors.tealLight.withOpacity(0.5);
    Color textColor = AppColors.tealText;

    final s = status.toLowerCase();

    if (s == 'sold') {
      text = 'Sold';
      bgColor = AppColors.statusSoldBg;
      textColor = AppColors.statusSoldText;
    } else if (s == 'accepted') {
      text = 'Accepted';
      bgColor = AppColors.statusAcceptedBg;
      textColor = Colors.white;
    } else {
      final now = DateTime.now();

      if (endTime != null && endTime!.isBefore(now)) {
        // Case: Expired
        text = 'Expired';
        bgColor = AppColors.grey200;
        textColor = AppColors.textDarkGrey;
      } else if (endTime != null && endTime!.isAfter(now)) {
        // Case: Time-Sensitive
        text = 'Ends in ${_formatDuration(endTime!.difference(now))}';
        bgColor = const Color(0xFFFFEBEE);
        textColor = AppColors.errorColor;
      } else {
        // Case: Active (Default)
        text = 'Active';
        bgColor = AppColors.tealLight.withOpacity(0.5);
        textColor = AppColors.tealText;
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppValues.borderRadiusCircular,
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    String label = 'Manage';
    Color bgColor = AppColors.grey200;
    Color textColor = AppColors.textDarkGrey;
    
    final s = status.toLowerCase();

    if (s == 'accepted') {
      label = 'Deal Chat';
      bgColor = AppColors.selectedColor;
      textColor = AppColors.white;
    } else if (s == 'sold') {
      label = 'Review';
      bgColor = const Color(0xFFFFEBEE);
      textColor = AppColors.successColor;
    }

    return InkWell(
      onTap: onAction,
      borderRadius: AppValues.borderRadiusM,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: AppValues.borderRadiusM,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
        ),
      ),
    );
  }

  String _getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inDays == 0) return 'today';
    if (difference.inDays == 1) return '1 day ago';
    return '${difference.inDays} days ago';
  }

  String _formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h';
    } else {
      return '${duration.inMinutes}m';
    }
  }
}
