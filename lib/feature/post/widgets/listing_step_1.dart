import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/post/widgets/shared/option_card.dart';

class ListingStep1 extends StatelessWidget {
  final int selectedType;
  final ValueChanged<int> onTypeSelected;

  const ListingStep1({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppValues.paddingH,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "What type of listing is this?",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          AppValues.gapXS,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Choose the best option for your item.",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textGrey,
                    ),
              ),
              Text(
                "1/3",
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(color: AppColors.subTextColor),
              ),
            ],
          ),
          AppValues.gapL,
          OptionCard(
            title: "Sell Item",
            subtitle: "For cash transactions only",
            icon: Icons.attach_money,
            isSelected: selectedType == 0,
            onTap: () => onTypeSelected(0),
          ),
          AppValues.gapM,
          OptionCard(
            title: "Trade Item",
            subtitle: "Exchange items with others",
            icon: Icons.swap_horiz,
            isSelected: selectedType == 1,
            onTap: () => onTypeSelected(1),
          ),
          AppValues.gapM,
          OptionCard(
            title: "Sell or Trade",
            subtitle: "Open to both cash and trades (Recommended)",
            icon: Icons.handshake_outlined,
            isRecommended: true,
            isSelected: selectedType == 2,
            onTap: () => onTypeSelected(2),
          ),
        ],
      ),
    );
  }
}
