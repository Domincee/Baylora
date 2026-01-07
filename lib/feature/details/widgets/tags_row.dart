import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/home/util/date_util.dart';
import 'package:baylora_prjct/feature/details/constants/item_details_strings.dart';

import '../../../core/constant/app_values.dart';

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
        _buildPill(context, "${ItemDetailsStrings.categoryPrefix}$category", AppColors.greyLight, AppColors.textDarkGrey),
        _buildPill(context, condition, AppColors.greyLight, AppColors.textDarkGrey),
        _buildPill(context, _getTypeLabel(type), AppColors.tealLight, AppColors.tealText),
        if (remainingTime != null)
          _buildPill(context, remainingTime, AppColors.errorColor.withValues(alpha: 0.1), AppColors.errorColor),
      ],
    );
  }

  String _getTypeLabel(String type) {
    switch (type) {
      case 'trade':
        return ItemDetailsStrings.tradeOnly;
      case 'mix':
        return ItemDetailsStrings.mixed;
      case 'cash':
      default:
        return ItemDetailsStrings.cashOnly;
    }
  }

  Widget _buildPill(BuildContext context, String text, Color bgColor, Color textColor) {
    return Container(
      padding:  EdgeInsets.symmetric(horizontal: AppValues.spacingS, vertical: AppValues.spacingXS),
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
