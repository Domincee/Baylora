import 'package:baylora_prjct/core/constant/app_strings.dart';
import 'package:baylora_prjct/feature/post/widgets/sections/trade_section.dart';
import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/post/widgets/sections/basic_info_section.dart';
import 'package:baylora_prjct/feature/post/widgets/sections/category_section.dart';
import 'package:baylora_prjct/feature/post/widgets/sections/condition_section.dart';
import 'package:baylora_prjct/feature/post/widgets/sections/description_section.dart';
import 'package:baylora_prjct/feature/post/widgets/sections/duration_section.dart';
import 'package:baylora_prjct/feature/post/widgets/sections/photos_section.dart';
import 'package:baylora_prjct/feature/post/widgets/sections/pricing_section.dart';
import 'dart:io';

class ListingStep2 extends StatefulWidget {
  final int selectedType;
  final TextEditingController titleController;
  final TextEditingController durationController;
  final bool isDurationEnabled;
  final ValueChanged<bool> onToggleDuration;
  final VoidCallback onIncrementDuration;
  final VoidCallback onDecrementDuration;
  final String? selectedCategory;
  final ValueChanged<String?> onCategoryChanged;
  final int selectedCondition;
  final ValueChanged<int> onConditionChanged;
  final TextEditingController priceController;
  final TextEditingController descriptionController;
  final List<String> wishlistTags;
  final ValueChanged<String> onTagAdded;
  final ValueChanged<String> onTagRemoved;
  final List<File> images;
  final VoidCallback onAddPhoto;
  final ValueChanged<File> onRemovePhoto;
  final VoidCallback onNext;

  // Validation Flags
  final bool showImageError;
  final bool showTitleError;
  final bool showCategoryError;
  final bool showDescriptionError;
  final bool showPriceError;
  final bool showWishlistError;

  // Real-time Validation Callbacks
  final ValueChanged<String>? onTitleChanged;
  final ValueChanged<String>? onDescriptionChanged;
  final ValueChanged<String>? onPriceChanged;

  const ListingStep2({
    super.key,
    required this.selectedType,
    required this.titleController,
    required this.durationController,
    required this.isDurationEnabled,
    required this.onToggleDuration,
    required this.onIncrementDuration,
    required this.onDecrementDuration,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.selectedCondition,
    required this.onConditionChanged,
    required this.priceController,
    required this.descriptionController,
    required this.wishlistTags,
    required this.onTagAdded,
    required this.onTagRemoved,
    required this.images,
    required this.onAddPhoto,
    required this.onRemovePhoto,
    required this.onNext,
    this.showImageError = false,
    this.showTitleError = false,
    this.showCategoryError = false,
    this.showDescriptionError = false,
    this.showPriceError = false,
    this.showWishlistError = false,
    this.onTitleChanged,
    this.onDescriptionChanged,
    this.onPriceChanged,


  });

  @override
  State<ListingStep2> createState() => _ListingStep2State();

}

class _ListingStep2State extends State<ListingStep2> {
  String _getHeaderTitle() {
    // NOTICE: You must use 'widget.selectedType' now
    switch (widget.selectedType) {
      case 0:
        return "Sell Item";
      case 1:
        return "Trade Item";
      case 2:
        return "Sell & Trade";
      default:
        return "Post Item";
    }
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      color: AppColors.white,
      child: Column(
        children: [
          // Custom Header
          Container(
            padding: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
            color: AppColors.white,
            child: SafeArea(
              bottom: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                    onPressed: () => Navigator.maybePop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                       Text(
                           _getHeaderTitle(),
                        style: Theme.of(context).textTheme.titleSmall
                      ),
                      Text(
                        "2/3",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textGrey,
                            ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: widget.onNext,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppValues.spacingL, vertical: AppValues.spacingXS),
                      decoration: BoxDecoration(
                        color: AppColors.royalBlue,
                        borderRadius: AppValues.borderRadiusL,
                      ),
                      child: Text(
                       AppStrings.nextBtn,
                        style:  Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.primaryColor
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Photos Section
                  PhotosSection(
                    images: widget.images,
                    onAddPhoto: widget.onAddPhoto,
                    onRemovePhoto: widget.onRemovePhoto,
                    showError: widget.showImageError,
                  ),
                  AppValues.gapL,

                  // 2. Basic Info Section
                  BasicInfoSection(
                    titleController: widget.titleController,
                    showError: widget.showTitleError,
                    onChanged: widget.onTitleChanged,
                  ),
                  AppValues.gapL,

                  // 3. Responsive Split Row (Duration & Category)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: DurationSection(
                          isDurationEnabled: widget.isDurationEnabled,
                          durationController: widget.durationController,
                          onToggleDuration: widget.onToggleDuration,
                          onIncrement: widget.onIncrementDuration,
                          onDecrement: widget.onDecrementDuration,
                        ),
                      ),
                      AppValues.gapHM,
                      Expanded(
                        flex: 1,
                        child: CategorySection(
                          selectedCategory: widget.selectedCategory,
                          onChanged: widget.onCategoryChanged,
                          showError: widget.showCategoryError,
                        ),
                      ),
                    ],
                  ),
                  AppValues.gapL,

                  // 4. Condition Section
                  ConditionSection(
                    selectedCondition: widget.selectedCondition,
                    onConditionChanged: widget.onConditionChanged,
                  ),
                  AppValues.gapL,

                  // 5. Pricing Section
                  // 5. Dynamic Section based on Type

                  // IF SELLING (Cash) -> Show Price
                  if (widget.selectedType == 0) ...[
                    PricingSection(
                      priceController: widget.priceController,
                      showError: widget.showPriceError,
                      onChanged: widget.onPriceChanged,
                    ),
                  ],

                  // IF TRADING (Trade) -> Show Trade Section
                  if (widget.selectedType == 1) ...[
                    TradeSection(
                      tags: widget.wishlistTags,
                      onTagAdded: widget.onTagAdded,
                      onTagRemoved: widget.onTagRemoved,
                      showError: widget.showWishlistError,
                    ),
                  ],

                  // IF BOTH (Mix) -> You likely want a special widget here later
                  // For now, if you want to test, you could stack them or leave this empty
                  // until we build the specific 'SellAndTradeSection'.
                  if (widget.selectedType == 2) ...[
                    // Placeholder for the "Mix" section we discussed earlier
                    // or you can stack both temporary:
                    PricingSection(
                      priceController: widget.priceController,
                      showError: widget.showPriceError,
                      onChanged: widget.onPriceChanged,
                    ),
                    AppValues.gapM,
                    TradeSection(
                      tags: widget.wishlistTags,
                      onTagAdded: widget.onTagAdded,
                      onTagRemoved: widget.onTagRemoved,
                      showError: widget.showWishlistError,
                    ),
                  ],

                  AppValues.gapL,

                  // 6. Description Section
                  DescriptionSection(
                    descriptionController: widget.descriptionController,
                    showError: widget.showDescriptionError,
                    onChanged: widget.onDescriptionChanged,
                  ),
                  AppValues.gapXXL, // Bottom padding
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


