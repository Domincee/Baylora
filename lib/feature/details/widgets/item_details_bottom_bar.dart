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
    return Container(
      padding: const EdgeInsets.all(AppValues.spacingM),
      decoration: _buildContainerDecoration(),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: AppValues.buttonHeight,
          child: ElevatedButton(
            onPressed: isOwner ? null : onPlaceBid,
            style: _buildButtonStyle(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!isOwner) _buildButtonIcon(),
                Flexible(
                  child: Text(
                    _getButtonText(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
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

  String _getButtonText() {
    if (isOwner) {
      return ItemDetailsStrings.yourItem;
    } else if (isMix) {
      return ItemDetailsStrings.makeAnOffer;
    } else if (isTrade) {
      return ItemDetailsStrings.offerATrade;
    } else {
      return ItemDetailsStrings.placeBid;
    }
  }

  BoxDecoration _buildContainerDecoration() {
    return BoxDecoration(
      color: AppColors.white,
      boxShadow: [
        BoxShadow(
          color: AppColors.shadowColor.withValues(alpha: 0.5),
          blurRadius: 10,
          offset: const Offset(0, -4),
        ),
      ],
    );
  }

  ButtonStyle _buildButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: isOwner
          ? AppColors.greyDisabled
          : (isTrade ? AppColors.tradeIconColor : AppColors.royalBlue),
      disabledBackgroundColor: AppColors.greyDisabled,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppValues.radiusCircular),
      ),
      elevation: 0,
    );
  }

  Widget _buildButtonIcon() {
    if (isMix) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.handshake_outlined, color: AppColors.white),
          AppValues.gapHS,
        ],
      );
    } else if (isTrade) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.swap_horiz, color: AppColors.white),
          AppValues.gapHS,
        ],
      );
    } else if (!isOwner) {
      // Bid case
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.gavel_outlined, color: AppColors.white), // bid icon
          AppValues.gapHS,
        ],
      );
    }

    return const SizedBox.shrink();
  }
}
