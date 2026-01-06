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

class ListingStep2 extends StatelessWidget {
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
                      const Text(
                        "Sell Item",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
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
                    onTap: onNext,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.royalBlue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Next",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
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
                    images: images,
                    onAddPhoto: onAddPhoto,
                    onRemovePhoto: onRemovePhoto,
                    showError: showImageError,
                  ),
                  AppValues.gapL,

                  // 2. Basic Info Section
                  BasicInfoSection(
                    titleController: titleController,
                    showError: showTitleError,
                    onChanged: onTitleChanged,
                  ),
                  AppValues.gapL,

                  // 3. Responsive Split Row (Duration & Category)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: DurationSection(
                          isDurationEnabled: isDurationEnabled,
                          durationController: durationController,
                          onToggleDuration: onToggleDuration,
                          onIncrement: onIncrementDuration,
                          onDecrement: onDecrementDuration,
                        ),
                      ),
                      AppValues.gapHM,
                      Expanded(
                        flex: 1,
                        child: CategorySection(
                          selectedCategory: selectedCategory,
                          onChanged: onCategoryChanged,
                          showError: showCategoryError,
                        ),
                      ),
                    ],
                  ),
                  AppValues.gapL,

                  // 4. Condition Section
                  ConditionSection(
                    selectedCondition: selectedCondition,
                    onConditionChanged: onConditionChanged,
                  ),
                  AppValues.gapL,

                  // 5. Pricing Section
                  PricingSection(
                    priceController: priceController,
                    showError: showPriceError,
                    onChanged: onPriceChanged,
                  ),
                  AppValues.gapL,

                  // 6. Description Section
                  DescriptionSection(
                    descriptionController: descriptionController,
                    showError: showDescriptionError,
                    onChanged: onDescriptionChanged,
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
