import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/details/constants/item_details_strings.dart';
import 'package:flutter/material.dart';

class ItemDetailsBottomBar extends StatelessWidget {
  final bool isOwner;
  final bool isTrade;
  final bool isMix;
  final bool hasBid;
  final String status;
  final VoidCallback onPlaceBid;
  final VoidCallback? onOwnerTap;
  final VoidCallback? onChatTap; // We keep this for now, but usage changes

  const ItemDetailsBottomBar({
    super.key,
    required this.isOwner,
    this.isTrade = false,
    this.isMix = false,
    this.hasBid = false,
    this.status = '',
    required this.onPlaceBid,
    this.onOwnerTap,
    this.onChatTap,
  });

  bool get _isPendingOffer => hasBid && (isTrade || isMix) && status != 'accepted';

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
            onPressed: _handleOnPressed(),
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

  VoidCallback? _handleOnPressed() {
    if (isOwner) {
      return onOwnerTap ?? () {};
    }
    
    // Logic: 
    // If status is accepted, we STILL use onPlaceBid (which opens the modal).
    // The Modal handles the actual chat navigation.
    // If rejected, button is disabled.
    if (hasBid && status == 'rejected') {
      return null;
    }
    
    // For pending, accepted, or no bid -> onPlaceBid opens the modal or input
    return onPlaceBid;
  }

  String _getButtonText() {
    if (isOwner) {
      return ItemDetailsStrings.yourItem; // "Manage Item"
    }

    if (hasBid) {
      if (status == 'accepted') {
        return ItemDetailsStrings.statusAccepted; // "Deal Chat"
      } else if (status == 'rejected') {
        return ItemDetailsStrings.btnRejected; // "Rejected"
      }
      
      if (isTrade || isMix) {
        return ItemDetailsStrings.btnPending; // "Pending"
      } else {
        return ItemDetailsStrings.editBid;
      }
    } else {
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

    // A.2 Accepted Style (Green)
    if (hasBid && status == 'accepted') {
       return ElevatedButton.styleFrom(
        backgroundColor: AppColors.successColor, // Green
        foregroundColor: Colors.white,
        disabledBackgroundColor: AppColors.greyDisabled,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppValues.radiusCircular),
        ),
        elevation: 0,
      );
    }
    
    // A.3 Rejected Style (Grey)
    if (hasBid && status == 'rejected') {
       return ElevatedButton.styleFrom(
        backgroundColor: AppColors.greyDisabled,
        foregroundColor: AppColors.grey400,
        disabledBackgroundColor: AppColors.greyDisabled,
        disabledForegroundColor: AppColors.grey400,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppValues.radiusCircular),
        ),
        elevation: 0,
      );
    }

    // B. Standard Style
    return ElevatedButton.styleFrom(
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

    if (hasBid && status == 'accepted') {
      return const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.chat_bubble_outline, color: AppColors.white),
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
