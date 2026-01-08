import 'dart:io';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/constant/listing_constants.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/details/constants/item_details_strings.dart';
import 'package:baylora_prjct/feature/details/provider/bid_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BidTradeSection extends StatelessWidget {
  final BidState state;
  final BidNotifier notifier;
  final TextEditingController titleController;
  final ImagePicker picker;
  final Widget? priceSection;
  final String status; // Added status

  const BidTradeSection({
    super.key,
    required this.state,
    required this.notifier,
    required this.titleController,
    required this.picker,
    this.priceSection,
    this.status = '', // Default to empty
  });

  @override
  Widget build(BuildContext context) {
    bool isReadOnly = status == 'accepted' || status == 'rejected';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPhotosPart(isReadOnly),
        if (priceSection != null) ...[
          AppValues.gapL,
          priceSection!,
        ],
        AppValues.gapL,
        _buildTradeDetailsPart(isReadOnly),
      ],
    );
  }

  Widget _buildPhotosPart(bool isReadOnly) {
    int totalImages = state.existingImageUrls.length + state.tradeImages.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(ItemDetailsStrings.photos, style: TextStyle(fontWeight: FontWeight.bold)),
            if (!isReadOnly)
              Text("$totalImages${ItemDetailsStrings.over3}", style: const TextStyle(color: AppColors.textGrey)),
          ],
        ),
        AppValues.gapS,
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // Add Photo Button (Only if not read-only and limit not reached)
              if (!isReadOnly && totalImages < 3)
                GestureDetector(
                  onTap: () async {
                    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
                    if (photo != null) {
                      notifier.addPhoto(photo);
                    }
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    margin: const EdgeInsets.only(right: AppValues.spacingS),
                    decoration: BoxDecoration(
                      color: AppColors.greyLight,
                      borderRadius: BorderRadius.circular(AppValues.radiusM),
                      border: Border.all(color: AppColors.greyMedium, style: BorderStyle.solid),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt, color: AppColors.royalBlue),
                        Text(ItemDetailsStrings.addPhotos, style: TextStyle(fontSize: 10, color: AppColors.textGrey)),
                      ],
                    ),
                  ),
                ),

              // Existing Images
              ...state.existingImageUrls.map((url) {
                return Stack(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      margin: const EdgeInsets.only(right: AppValues.spacingS),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppValues.radiusM),
                        image: DecorationImage(
                          image: NetworkImage(url),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    if (!isReadOnly)
                      Positioned(
                        top: 4,
                        right: 12,
                        child: GestureDetector(
                          onTap: () => notifier.removeExistingImage(url),
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: AppColors.errorColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close, size: 12, color: AppColors.white),
                          ),
                        ),
                      ),
                  ],
                );
              }),

              // New Trade Images
              ...state.tradeImages.map((xFile) {
                return Stack(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      margin: const EdgeInsets.only(right: AppValues.spacingS),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppValues.radiusM),
                        image: DecorationImage(
                          image: kIsWeb 
                              ? NetworkImage(xFile.path) 
                              : FileImage(File(xFile.path)) as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    if (!isReadOnly)
                      Positioned(
                        top: 4,
                        right: 12,
                        child: GestureDetector(
                          onTap: () => notifier.removePhoto(xFile),
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: AppColors.errorColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close, size: 12, color: AppColors.white),
                          ),
                        ),
                      ),
                  ],
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTradeDetailsPart(bool isReadOnly) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(ItemDetailsStrings.itemTitle, style: TextStyle(fontWeight: FontWeight.bold)),
        AppValues.gapS,
        IgnorePointer(
          ignoring: isReadOnly,
          child: TextField(
            readOnly: isReadOnly,
            decoration: InputDecoration(
              filled: true,
              fillColor: isReadOnly ? AppColors.greyLight.withValues(alpha: 0.5) : AppColors.greyLight,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppValues.radiusM),
                borderSide: BorderSide.none,
              ),
              hintText: ItemDetailsStrings.hintTextTitle,
            ),
            onChanged: notifier.setTradeTitle,
            controller: titleController,
          ),
        ),
        AppValues.gapM,

        const Text(ItemDetailsStrings.categoryPrefix, style: TextStyle(fontWeight: FontWeight.bold)),
        AppValues.gapS,
        IgnorePointer(
          ignoring: isReadOnly,
          child: DropdownButtonFormField<String>(
            initialValue: state.tradeCategory,
            decoration: InputDecoration(
              filled: true,
              fillColor: isReadOnly ? AppColors.greyLight.withValues(alpha: 0.5) : AppColors.greyLight,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppValues.radiusM),
                borderSide: BorderSide.none,
              ),
              hintText: ItemDetailsStrings.hintTextCategory,
            ),
            items: ListingConstants.categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
            onChanged: (val) {
              if (val != null) notifier.setTradeCategory(val);
            },
          ),
        ),
        AppValues.gapM,

        const Text(ItemDetailsStrings.condition, style: TextStyle(fontWeight: FontWeight.bold)),
        AppValues.gapS,
        IgnorePointer(
          ignoring: isReadOnly,
          child: Row(
            children: [ItemDetailsStrings.labelNew,
                       ItemDetailsStrings.labelFair,
                        ItemDetailsStrings.labelUsed,
                        ItemDetailsStrings.labelBroken,
            ].map((cond) {
              final isSelected = state.tradeCondition == cond;
              // If read-only, only show the selected one, or dim unselected? 
              // Usually showing all but disabled is fine, or just selected.
              // Let's keep all but disabled.
              
              return Padding(
                padding: const EdgeInsets.only(right: AppValues.spacingS),
                child: ChoiceChip(
                  label: Text(cond),
                  selected: isSelected,
                  selectedColor: AppColors.royalBlue,
                  backgroundColor: AppColors.greyLight,
                  disabledColor: isSelected ? AppColors.royalBlue.withValues(alpha: 0.5) : AppColors.greyLight.withValues(alpha: 0.5),
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.white : AppColors.textGrey,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: isReadOnly ? null : (val) {
                    if (val) notifier.setTradeCondition(cond);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppValues.radiusCircular),
                    side: BorderSide.none,
                  ),
                  showCheckmark: false,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
