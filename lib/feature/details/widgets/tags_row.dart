import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/home/util/date_util.dart';

class TagsRow extends StatelessWidget {
  final String category;
  final String condition;
  final String type;
  final DateTime? endTime;

  const TagsRow({
    super.key,
    required this.category,
    required this.condition,
    required this.type,
    this.endTime,
  });

  @override
  Widget build(BuildContext context) {
    final remainingTime = DateUtil.getRemainingTime(endTime);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildPill(context, "Category: $category", AppColors.greyLight, AppColors.textDarkGrey),
        _buildPill(context, condition, AppColors.greyLight, AppColors.textDarkGrey),
        _buildPill(
          context,
          type == 'auction' ? 'Auction' : (type == 'trade' ? 'Trade Only' : 'Cash Only'),
          AppColors.tealLight, // Using cyan/teal-ish color
          AppColors.tealText,
        ),
        if (remainingTime != null)
          _buildPill(
            context,
            remainingTime,
            AppColors.errorColor.withValues(alpha: 0.1),
            AppColors.errorColor,
          ),
      ],
    );
  }

  Widget _buildPill(BuildContext context, String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
