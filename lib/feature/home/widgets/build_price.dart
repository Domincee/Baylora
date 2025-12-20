import 'package:baylora_prjct/core/constant/app_values_widget.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
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
        style: 
        Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: AppColors.highLightTextColor,
        )
      );
    }
     else if (type == 'trade') {
      return Row(
        children: [
          const Icon(Icons.swap_horiz, size: 16, color: Color(0xFF8B5CF6)),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              swapItem.isNotEmpty ? swapItem : "Trade Only",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: AppColors.highLightTextColor,
              ) 
              
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Text(
            "₱ ${price.replaceAll('000', 'k')}",
          style:
              Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: AppColors.highLightTextColor,
              ), 
          ),
          const SizedBox(width: 4),
           Text("or", style: 
          Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: AppColors.subTextColor,
          )
          ),
          const SizedBox(width: 4),
          const Icon(Icons.swap_horiz, size: AppValuesWidget.iconDefaultSize, color: Color(0xFF8B5CF6)),
        ],
      );
    }
  }
}