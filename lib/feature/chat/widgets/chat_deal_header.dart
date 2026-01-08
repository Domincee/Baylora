import 'package:flutter/material.dart';
import '../../../core/constant/app_values.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/listing_summary_card.dart';
import '../constant/chat_strings.dart';

class ChatDealHeader extends StatelessWidget {
  final Map<String, dynamic> item;
  final bool isUpdating;
  final VoidCallback onCancel;
  final VoidCallback onDone;

  const ChatDealHeader({
    super.key,
    required this.item,
    required this.isUpdating,
    required this.onCancel,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    final String itemStatus = item[ChatStrings.colStatus]?.toString().toLowerCase() ?? '';
    final bool showActions = itemStatus == ChatStrings.statusAccepted;

    return Column(
      children: [
        Container(
          color: AppColors.greyLight.withValues(alpha: 0.3),
          padding: const EdgeInsets.all(AppValues.spacingS),
          child: ListingSummaryCard(item: item, bottomAction: null),
        ),
        if (showActions)
          Padding(
            padding: const EdgeInsets.fromLTRB(AppValues.spacingM, 0, AppValues.spacingM, AppValues.spacingS),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: isUpdating ? null : onCancel,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.errorColor,
                      side: const BorderSide(color: AppColors.errorColor),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text(ChatStrings.cancelDealButton),
                  ),
                ),
                AppValues.gapHM,
                Expanded(
                  child: ElevatedButton(
                    onPressed: isUpdating ? null : onDone,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.successColor,
                      foregroundColor: AppColors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: isUpdating
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.white))
                        : const Text(ChatStrings.markAsDoneButton),
                  ),
                ),
              ],
            ),
          ),
        const Divider(height: 1, color: AppColors.greyLight),
      ],
    );
  }
}