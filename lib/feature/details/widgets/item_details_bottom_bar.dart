import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/details/constants/item_details_strings.dart';
import 'package:flutter/material.dart';

class ItemDetailsBottomBar extends StatelessWidget {
  final bool isOwner;
  final VoidCallback onPlaceBid;

  const ItemDetailsBottomBar({
    super.key,
    required this.isOwner,
    required this.onPlaceBid,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppValues.spacingM),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.5),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: isOwner ? null : onPlaceBid,
            style: ElevatedButton.styleFrom(
              backgroundColor: isOwner ? AppColors.greyDisabled : AppColors.tradeIconColor,
              disabledBackgroundColor: AppColors.greyDisabled,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppValues.radiusCircular),
              ),
              elevation: 0,
            ),
            child: Text(
              isOwner ? ItemDetailsStrings.yourItem : ItemDetailsStrings.placeBid,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
