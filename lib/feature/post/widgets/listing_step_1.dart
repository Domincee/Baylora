import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/post/widgets/shared/option_card.dart';

import '../constants/post_strings.dart';

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
            PostStrings.whatTypeOfListing,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          AppValues.gapXS,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                PostStrings.chooseOptionItem,
                style: Theme.of(context).textTheme.titleSmall
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
            title:  PostStrings.sellItem,
            subtitle: PostStrings.forTransaction,
            icon: Icons.attach_money,
            isSelected: selectedType == 0,
            onTap: () => onTypeSelected(0),
          ),
          AppValues.gapM,
          OptionCard(
            title: PostStrings.tradeItem,
            subtitle: PostStrings.forExchange,
            icon: Icons.swap_horiz,
            isSelected: selectedType == 1,
            onTap: () => onTypeSelected(1),
          ),
          AppValues.gapM,
          OptionCard(
            title: PostStrings.sellTradeItem,
            subtitle: PostStrings.forBothItem,

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
