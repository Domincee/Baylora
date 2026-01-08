import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/details/constants/item_details_strings.dart';
import 'package:flutter/material.dart';

class ItemDetailsBottomBar extends StatelessWidget {
  final bool isOwner;
  final bool isTrade;
  final bool isMix;
  final bool hasBid;
  final VoidCallback onPlaceBid;
  final VoidCallback? onOwnerTap; // 1. NEW: Callback for owner actions

  const ItemDetailsBottomBar({
    super.key,
    required this.isOwner,
    this.isTrade = false,
    this.isMix = false,
    this.hasBid = false,
    required this.onPlaceBid,
    this.onOwnerTap, // Optional: Pass this from parent when you are ready to implement nav
  });

  bool get _isPendingOffer => hasBid && (isTrade || isMix);

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
            // 2. UPDATED: Enable click for owner (executes onOwnerTap or empty function)
            onPressed: isOwner
                ? (onOwnerTap ?? () {})
                : onPlaceBid,
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
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: _isPendingOffer ? AppColors.royalBlue : AppColors.white,
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
      return "Manage Item"; // Changed from "Your Item" to "Manage Item"
    }
    if (hasBid) {
      if (isTrade || isMix) {
        return ItemDetailsStrings.pendingOffer;
      } else {
        return ItemDetailsStrings.editBid;
      }
    }
    else {
      if (isTrade || isMix) {
        return ItemDetailsStrings.makeAnOffer;
      } else {
        return ItemDetailsStrings.placeBid;
      }
    }
  }

  BoxDecoration _buildContainerDecoration() {
    return BoxDecoration(
      color: AppColors.white,
      boxShadow: [
        BoxShadow(
          color: AppColors.shadowColor.withValues(alpha: 0.5),
          blurRadius: AppValues.spacingS,
          offset: const Offset(0, -AppValues.elevationMedium),
        ),
      ],
    );
  }

  ButtonStyle _buildButtonStyle() {
    // A. Pending Offer Style (Outline Blue)
    if (_isPendingOffer) {
      return ElevatedButton.styleFrom(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.royalBlue,
        disabledBackgroundColor: AppColors.greyDisabled,
        shadowColor: Colors.transparent,
        side: const BorderSide(color: AppColors.royalBlue, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppValues.radiusCircular),
        ),
        elevation: 0,
      );
    }

    // B. Standard Style
    return ElevatedButton.styleFrom(
      // 3. UPDATED: Use royalBlue for owner so it looks active/clickable
      backgroundColor: isOwner
          ? AppColors.royalBlue
          : (isTrade ? AppColors.tradeIconColor : AppColors.royalBlue),
      disabledBackgroundColor: AppColors.greyDisabled,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppValues.radiusCircular),
      ),
      elevation: 0,
    );
  }

  Widget _buildButtonIcon() {
    if (_isPendingOffer) {
      return const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.hourglass_empty_rounded, color: AppColors.royalBlue),
          AppValues.gapHS,
        ],
      );
    }

    if (isMix) {
      return const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.handshake_outlined, color: AppColors.white),
          AppValues.gapHS,
        ],
      );
    } else if (isTrade) {
      return const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.swap_horiz, color: AppColors.white),
          AppValues.gapHS,
        ],
      );
    } else {
      return const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.gavel_outlined, color: AppColors.white),
          AppValues.gapHS,
        ],
      );
    }
  }
}
