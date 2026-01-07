import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/details/constants/item_details_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class BidCashSection extends StatelessWidget {
  final double currentHighest;
  final double minimumBid;
  final TextEditingController controller;
  final ValueChanged<double> onAmountChanged;
  final ValueChanged<double> onAddAmount;

  const BidCashSection({
    super.key,
    required this.currentHighest,
    required this.minimumBid,
    required this.controller,
    required this.onAmountChanged,
    required this.onAddAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "${ItemDetailsStrings.currentHighest}: ${ItemDetailsStrings.currencySymbol}${currentHighest.toStringAsFixed(0)}",
              style: const TextStyle(color: AppColors.textGrey, fontSize: 12),
            ),
            AppValues.gapHM,
            Text(
              "${ItemDetailsStrings.miniMumBid}:  ${ItemDetailsStrings.currencySymbol}${minimumBid.toStringAsFixed(0)}",
              style: const TextStyle(color: AppColors.errorColor, fontSize: 12),
            ),
          ],
        ),
        AppValues.gapM,

        TextField(
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          decoration: const InputDecoration(

            prefixText: ItemDetailsStrings.currencySymbol,
            border: InputBorder.none,
            hintText: ItemDetailsStrings.hint0,
          ),
          onChanged: (value) {
            final val = double.tryParse(value) ?? 0.0;
            onAmountChanged(val);
          },
          controller: controller,
        ),
        AppValues.gapM,

        Row(
          children: [100, 500, 1000].map((amount) {
            return Padding(
              padding: const EdgeInsets.only(right: AppValues.spacingS),
              child: ActionChip(
                label: Text("+${ItemDetailsStrings.currencySymbol}$amount"),
                backgroundColor: AppColors.greyLight,
                onPressed: () => onAddAmount(amount.toDouble()),
                shape: const StadiumBorder(side: BorderSide.none),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
