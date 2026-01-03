import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/post/widgets/shared/section_header.dart';

class ExchangePreferenceSection extends StatefulWidget {
  final TextEditingController cashController;
  final List<String> wishlistTags;
  final ValueChanged<String> onTagAdded;
  final ValueChanged<String> onTagRemoved;
  final bool showPriceInput;
  final bool showPriceError;
  final bool showWishlistError;
  final ValueChanged<String>? onPriceChanged;

  const ExchangePreferenceSection({
    super.key,
    required this.cashController,
    required this.wishlistTags,
    required this.onTagAdded,
    required this.onTagRemoved,
    this.showPriceInput = true,
    this.showPriceError = false,
    this.showWishlistError = false,
    this.onPriceChanged,
  });

  @override
  State<ExchangePreferenceSection> createState() =>
      _ExchangePreferenceSectionState();
}

class _ExchangePreferenceSectionState extends State<ExchangePreferenceSection> {
  final TextEditingController _tagController = TextEditingController();

  @override
  void dispose() {
    _tagController.dispose();
    super.dispose();
  }

  void _handleTagSubmit(String value) {
    if (value.trim().isNotEmpty) {
      widget.onTagAdded(value.trim());
      _tagController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: "Exchange Preference"),
        AppValues.gapS,
        Container(
          padding: AppValues.paddingCard,
          decoration: BoxDecoration(
            color: AppColors.greyLight,
            borderRadius: AppValues.borderRadiusM,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.showPriceInput) ...[
                // Part A: Cash Input
                Text(
                  "I want cash OR..",
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontSize: 14),
                ),
                AppValues.gapXS,
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: AppValues.borderRadiusS,
                    border: Border.all(color: AppColors.greyMedium),
                  ),
                  child: TextFormField(
                    controller: widget.cashController,
                    onChanged: widget.onPriceChanged,
                    decoration: const InputDecoration(
                      prefixText: "₱ ",
                      hintText: "0.00",
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.all(12),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                if (widget.showPriceError) ...[
                  const SizedBox(height: 4),
                  const Text(
                    "This is required",
                    style: TextStyle(
                      color: AppColors.errorColor,
                      fontSize: 12,
                    ),
                  ),
                ],
                AppValues.gapM,

                // Divider
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        "or",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: AppColors.textGrey),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                AppValues.gapM,
              ],

              // Part B: Wishlist/Tags
              Text(
                "I want to swap for (Wishlist)",
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontSize: 14),
              ),
              AppValues.gapXS,
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: AppValues.borderRadiusS,
                  border: Border.all(color: AppColors.greyMedium),
                ),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    ...widget.wishlistTags.map(
                      (tag) => Chip(
                        label: Text(
                          tag,
                          style: const TextStyle(
                            color: AppColors.royalBlue,
                            fontSize: 12,
                          ),
                        ),
                        backgroundColor:
                            AppColors.royalBlue.withValues(alpha: 0.1),
                        side: BorderSide(
                          color: AppColors.royalBlue.withValues(alpha: 0.3),
                          width: 1,
                        ),
                        deleteIcon: const Icon(
                          Icons.close,
                          size: 14,
                          color: AppColors.royalBlue,
                        ),
                        onDeleted: () => widget.onTagRemoved(tag),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppValues.borderRadiusCircular,
                        ),
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      child: TextField(
                        controller: _tagController,
                        decoration: const InputDecoration(
                          hintText: "",
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: const TextStyle(fontSize: 14),
                        onSubmitted: _handleTagSubmit,
                        onTapOutside: (_) {
                          if (_tagController.text.isNotEmpty) {
                            _handleTagSubmit(_tagController.text);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.showWishlistError) ...[
                const SizedBox(height: 4),
                const Text(
                  "This is required",
                  style: TextStyle(
                    color: AppColors.errorColor,
                    fontSize: 12,
                  ),
                ),
              ],
              AppValues.gapXS,
              Text(
                "Enter what you are looking for. Leave empty to see all items.",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: AppColors.textGrey, fontSize: 11),
              ),
              AppValues.gapM,

              // Footer Tip
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: Colors.green[600],
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      "Tip: Being specific helps you find the right trade faster.",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                            fontSize: 11,
                          ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
