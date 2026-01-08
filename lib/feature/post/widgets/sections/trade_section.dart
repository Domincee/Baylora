import 'package:baylora_prjct/feature/post/constants/post_strings.dart';
import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';

class TradeSection extends StatefulWidget {
  final List<String> tags;
  final ValueChanged<String> onTagAdded;
  final ValueChanged<String> onTagRemoved;
  final bool showError;

  const TradeSection({
    super.key,
    required this.tags,
    required this.onTagAdded,
    required this.onTagRemoved,
    this.showError = false,
  });

  @override
  State<TradeSection> createState() => _TradeSectionState();
}

class _TradeSectionState extends State<TradeSection> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  void _handleSubmitted(String value) {
    if (value.trim().isNotEmpty) {
      widget.onTagAdded(value.trim());
      _controller.clear();
      // Keep focus to allow typing multiple tags quickly
      _focusNode.requestFocus();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppValues.paddingAll,
      decoration: BoxDecoration(
        color: AppColors.greyLight,
        borderRadius: AppValues.borderRadiusL,
        border: widget.showError
            ? Border.all(color: AppColors.errorColor, width: 1)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Title
          Text(
            PostStrings.lookingFor,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          AppValues.gapS,


          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: AppValues.borderRadiusCircular,
            ),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ...widget.tags.map((tag) => _buildChip(context, tag)),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.blueLight,
                    borderRadius:AppValues.borderRadiusCircular,
                    border: Border.all(
                      color: AppColors.blueLight,
                      width: 1,
                    ),
                  ),
                  child: ConstrainedBox(

                    constraints: const BoxConstraints(minWidth: 50, maxWidth: 200),
                    child: IntrinsicWidth(
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        cursorColor: AppColors.royalBlue,
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.zero,

                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          filled: true,
                          fillColor: Colors.transparent,
                          hintText: "",
                        ),
                        onSubmitted: _handleSubmitted,
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          AppValues.gapS,

          // 3. Helper Text
          Text(
           PostStrings.helperTextLookingFor,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textGrey,
            ),
          ),

          AppValues.gapXS,

          // 4. Tip Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.lightbulb_outline,
                size: AppValues.iconS,
                color: AppColors.successColor, // Using success color (green) for the bulb
              ),
              AppValues.gapHXS,
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: PostStrings.tip,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textGrey,
                        ),
                      ),
                      TextSpan(
                        text:
                        PostStrings.helperTextLookingFor2nd,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChip(BuildContext context, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        // Light Blue background for chip
        color: AppColors.blueLight,
        borderRadius: AppValues.borderRadiusCircular,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              // Royal Blue text color
              color: AppColors.royalBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () => widget.onTagRemoved(label),
            child: const Icon(
              Icons.close,
              size: AppValues.iconS,
              color: AppColors.royalBlue,
            ),
          ),
        ],
      ),
    );
  }
}