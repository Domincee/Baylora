import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/feature/post/widgets/sections/basic_info_section.dart';
import 'package:baylora_prjct/feature/post/widgets/sections/category_section.dart';
import 'package:baylora_prjct/feature/post/widgets/sections/condition_section.dart';
import 'package:baylora_prjct/feature/post/widgets/sections/description_section.dart';
import 'package:baylora_prjct/feature/post/widgets/sections/duration_section.dart';
import 'package:baylora_prjct/feature/post/widgets/sections/exchange_preference_section.dart';
import 'package:baylora_prjct/feature/post/widgets/sections/photos_section.dart';
import 'package:baylora_prjct/feature/post/widgets/sections/pricing_section.dart';

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
  });

  @override
  Widget build(BuildContext context) {
    switch (selectedType) {
      case 0:
        return _buildSellItemForm();
      case 1:
        return _buildTradeItemForm();
      case 2:
        return _buildSellOrTradeItemForm();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildSellItemForm() {
    return SingleChildScrollView(
      padding: AppValues.paddingH.copyWith(bottom: AppValues.spacingXXL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PhotosSection(),
          AppValues.gapL,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: BasicInfoSection(titleController: titleController)),
              AppValues.gapHM,
              SizedBox(
                width: 150,
                child: DurationSection(
                  isDurationEnabled: isDurationEnabled,
                  durationController: durationController,
                  onToggleDuration: onToggleDuration,
                  onIncrement: onIncrementDuration,
                  onDecrement: onDecrementDuration,
                ),
              ),
            ],
          ),
          AppValues.gapL,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CategorySection(
                  selectedCategory: selectedCategory,
                  onChanged: onCategoryChanged,
                ),
              ),
              AppValues.gapHM,
              Expanded(
                child: ConditionSection(
                  selectedCondition: selectedCondition,
                  onConditionChanged: onConditionChanged,
                ),
              ),
            ],
          ),
          AppValues.gapL,
          PricingSection(priceController: priceController),
          AppValues.gapL,
          DescriptionSection(descriptionController: descriptionController),
        ],
      ),
    );
  }

  Widget _buildTradeItemForm() {
    return SingleChildScrollView(
      padding: AppValues.paddingH.copyWith(bottom: AppValues.spacingXXL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PhotosSection(),
          AppValues.gapL,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: BasicInfoSection(titleController: titleController)),
              AppValues.gapHM,
              SizedBox(
                width: 150,
                child: DurationSection(
                  isDurationEnabled: isDurationEnabled,
                  durationController: durationController,
                  onToggleDuration: onToggleDuration,
                  onIncrement: onIncrementDuration,
                  onDecrement: onDecrementDuration,
                ),
              ),
            ],
          ),
          AppValues.gapL,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CategorySection(
                  selectedCategory: selectedCategory,
                  onChanged: onCategoryChanged,
                ),
              ),
              AppValues.gapHM,
              Expanded(
                child: ConditionSection(
                  selectedCondition: selectedCondition,
                  onConditionChanged: onConditionChanged,
                ),
              ),
            ],
          ),
          AppValues.gapL,
          ExchangePreferenceSection(
            cashController: priceController,
            wishlistTags: wishlistTags,
            onTagAdded: onTagAdded,
            onTagRemoved: onTagRemoved,
            showPriceInput: false,
          ),
          AppValues.gapL,
          DescriptionSection(descriptionController: descriptionController),
        ],
      ),
    );
  }

  Widget _buildSellOrTradeItemForm() {
    return SingleChildScrollView(
      padding: AppValues.paddingH.copyWith(bottom: AppValues.spacingXXL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PhotosSection(),
          AppValues.gapL,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: BasicInfoSection(titleController: titleController)),
              AppValues.gapHM,
              SizedBox(
                width: 150,
                child: DurationSection(
                  isDurationEnabled: isDurationEnabled,
                  durationController: durationController,
                  onToggleDuration: onToggleDuration,
                  onIncrement: onIncrementDuration,
                  onDecrement: onDecrementDuration,
                ),
              ),
            ],
          ),
          AppValues.gapL,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CategorySection(
                  selectedCategory: selectedCategory,
                  onChanged: onCategoryChanged,
                ),
              ),
              AppValues.gapHM,
              Expanded(
                child: ConditionSection(
                  selectedCondition: selectedCondition,
                  onConditionChanged: onConditionChanged,
                ),
              ),
            ],
          ),
          AppValues.gapL,
          ExchangePreferenceSection(
            cashController: priceController,
            wishlistTags: wishlistTags,
            onTagAdded: onTagAdded,
            onTagRemoved: onTagRemoved,
          ),
          AppValues.gapL,
          DescriptionSection(descriptionController: descriptionController),
        ],
      ),
    );
  }
}
