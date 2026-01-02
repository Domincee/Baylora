import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';

class BuildPrice extends StatelessWidget {
  const BuildPrice({
    super.key,
    required this.type,
    required this.price,
    required this.swapItem,
    required this.context,
  });

  final String type;
  final String price;
  final String swapItem;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    if (type == 'cash') {
      return Text(
        "₱ $price",
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: AppColors.highLightTextColor,
        ),
      );
    } else if (type == 'trade') {
      return Row(
        children: [
          Icon(Icons.swap_horiz, size: AppValues.iconS, color: AppColors.highLightTextColor),
          AppValues.gapHXXS,
          Expanded(
            child: Text(
              swapItem.isNotEmpty ? swapItem : "Trade Only",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: AppColors.highLightTextColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Text(
            "₱ ${price.replaceAll('000', 'k')}",
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: AppColors.highLightTextColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          AppValues.gapHXXS,
          Text(
            "or",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: AppColors.subTextColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          AppValues.gapHXXS,
          Icon(Icons.swap_horiz, size: AppValues.iconM, color: AppColors.highLightTextColor),
        ],
      );
    }
  }
}