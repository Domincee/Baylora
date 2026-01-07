import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/core/widgets/tag_chip.dart';
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
      spacing: AppValues.spacingXS,
      runSpacing: AppValues.spacingXS,
      children: [
        TagChip(
          label: "${ItemDetailsStrings.categoryPrefix}$category",
          backgroundColor: AppColors.greyLight,
          textColor: AppColors.textDarkGrey,
        ),
        TagChip(
          label: condition,
          backgroundColor: AppColors.greyLight,
          textColor: AppColors.textDarkGrey,
        ),
        TagChip(
          label: _getTypeLabel(type),
          backgroundColor: AppColors.tealLight,
          textColor: AppColors.tealText,
        ),
        if (remainingTime != null)
          TagChip(
            label: remainingTime,
            backgroundColor: AppColors.errorColor.withValues(alpha: 0.1),
            textColor: AppColors.errorColor,
          ),
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
}
