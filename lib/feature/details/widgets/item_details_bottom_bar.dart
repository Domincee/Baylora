import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/details/constants/item_details_strings.dart';
import 'package:flutter/material.dart';

class ItemDetailsBottomBar extends StatelessWidget {
  final bool isOwner;
  final bool isTrade;
  final bool isMix;
  final VoidCallback onPlaceBid;

  const ItemDetailsBottomBar({
    super.key,
    required this.isOwner,
    this.isTrade = false,
    this.isMix = false,
    required this.onPlaceBid,
  });

  @override
  Widget build(BuildContext context) {
    String buttonText;
    if (isOwner) {
      buttonText = ItemDetailsStrings.yourItem;
    } else if (isMix) {
      buttonText = "Make an Offer";
    } else if (isTrade) {
      buttonText = "Offer a Trade";
    } else {
      buttonText = ItemDetailsStrings.placeBid;
    }

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
              // FIX: Use royalBlue (or deepBlue) for primary action. 
              // 'primaryColor' was mapped to White (0xFFFFFFFF) in AppColors, causing invisible button.
              backgroundColor: isOwner 
                  ? AppColors.greyDisabled 
                  : (isTrade ? AppColors.tradeIconColor : AppColors.royalBlue),
              disabledBackgroundColor: AppColors.greyDisabled,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppValues.radiusCircular),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!isOwner) ...[
                  if (isMix) ...[
                    const Icon(Icons.handshake_outlined, color: Colors.white),
                    AppValues.gapS,
                  ] else if (isTrade) ...[
                    const Icon(Icons.swap_horiz, color: Colors.white),
                    AppValues.gapS,
                  ],
                ],
                Flexible(
                  child: Text(
                    buttonText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      height: 1.2, // Fix for text being slightly cutoff at the bottom
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
