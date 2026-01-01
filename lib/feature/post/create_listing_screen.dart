import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';

class CreateListingScreen extends StatefulWidget {
  const CreateListingScreen({super.key});

  @override
  State<CreateListingScreen> createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends State<CreateListingScreen> {
  int _currentStep = 0;
  int _selectedType = -1;
  int _selectedCondition = 1; // 0: New, 1: Used, 2: Broken
  bool _isNegotiable = true;

  final _titleController = TextEditingController();
  final _durationController = TextEditingController(text: '1');
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _durationController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  PreferredSizeWidget _buildAppBar() {
    if (_currentStep == 0) {
      return AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppValues.spacingM),
            child: TextButton(
              onPressed: _selectedType != -1
                  ? () => setState(() => _currentStep++)
                  : null,
              child: Text(
                "Next",
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: _selectedType != -1
                          ? AppColors.royalBlue
                          : Colors.grey,
                    ),
              ),
            ),
          ),
        ],
      );
    } else {
      return AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.black),
          onPressed: () => setState(() => _currentStep--),
        ),
        centerTitle: true,
        title: Text(
          _getStep2Title(),
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold, color: AppColors.black),
        ),
      );
    }
  }

  String _getStep2Title() {
    switch (_selectedType) {
      case 0:
        return "Sell Item";
      case 1:
        return "Trade Item";
      case 2:
        return "Sell or Trade";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(),
      body: IndexedStack(
        index: _currentStep,
        children: [
          _buildStep1UI(),
          _buildStep2UI(),
        ],
      ),
    );
  }

  // ====== Step 1 ======
  Widget _buildStep1UI() {
    return Padding(
      padding: AppValues.paddingH,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "What type of listing is this?",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          AppValues.gapXS,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Choose the best option for your item.",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textGrey,
                    ),
              ),
              Text(
                "1/3",
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(color: AppColors.subTextColor),
              ),
            ],
          ),
          AppValues.gapL,
          _buildOptionCard(
            index: 0,
            title: "Sell Item",
            subtitle: "For cash transactions only",
            icon: Icons.attach_money,
          ),
          AppValues.gapM,
          _buildOptionCard(
            index: 1,
            title: "Trade Item",
            subtitle: "Exchange items with others",
            icon: Icons.swap_horiz,
          ),
          AppValues.gapM,
          _buildOptionCard(
            index: 2,
            title: "Sell or Trade",
            subtitle: "Open to both cash and trades (Recommended)",
            icon: Icons.handshake_outlined,
            isRecommended: true,
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard(
      {required int index,
      required String title,
      required String subtitle,
      required IconData icon,
      bool isRecommended = false}) {
    final isSelected = _selectedType == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedType = index),
      child: Container(
        padding: AppValues.paddingCard,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.royalBlue.withOpacity(0.05)
              : AppColors.white,
          border: Border.all(
            color: isSelected ? AppColors.royalBlue : AppColors.greyMedium,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: AppValues.borderRadiusM,
        ),
        child: Row(children: [
          Container(
              padding: AppValues.paddingSmall,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.royalBlue : AppColors.greyLight,
                shape: BoxShape.circle,
              ),
              child: Icon(icon,
                  color: isSelected ? AppColors.white : AppColors.textDarkGrey,
                  size: AppValues.iconM)),
          AppValues.gapHM,
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Row(children: [
                  Text(title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color:
                              isSelected ? AppColors.royalBlue : AppColors.black)),
                  if (isRecommended) ...[
                    AppValues.gapHXS,
                    Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                            color: AppColors.recommendedColor.withOpacity(0.1),
                            borderRadius: AppValues.borderRadiusS),
                        child: Text("Recommended",
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.recommendedColor)))
                  ]
                ]),
                AppValues.gapXXS,
                Text(subtitle,
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(color: AppColors.textDarkGrey))
              ])),
          Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: isSelected
                          ? AppColors.royalBlue
                          : AppColors.greyDisabled,
                      width: 2)),
              child: isSelected
                  ? Center(
                      child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                              color: AppColors.royalBlue,
                              shape: BoxShape.circle)))
                  : null)
        ]),
      ),
    );
  }

  // ====== Step 2 ======
  Widget _buildStep2UI() {
    switch (_selectedType) {
      case 0:
        return _buildSellItemForm();
      case 1:
      case 2:
        return Center(child: Text(_getStep2Title()));
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
          // Photos
          _buildSectionHeader("Photos", "2/3"),
          AppValues.gapS,
          Row(
            children: [
              _buildPhotoUploader(),
              AppValues.gapHS,
              _buildPhotoPlaceholder(),
              AppValues.gapHS,
              _buildPhotoPlaceholder(),
            ],
          ),
          AppValues.gapL,

          // Basic Info & Duration
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader("Basic info"),
                    AppValues.gapS,
                    TextFormField(
                      controller: _titleController,
                      decoration:
                          const InputDecoration(hintText: "What are you selling?"),
                    ),
                  ],
                ),
              ),
              AppValues.gapHM,
              SizedBox(
                width: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader("Set Duration"),
                    AppValues.gapS,
                    TextFormField(
                      controller: _durationController,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        suffixText: "hr +",
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          AppValues.gapL,

          // Category & Condition
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader("Category"),
                    AppValues.gapS,
                    _buildCategorySelector(),
                  ],
                ),
              ),
              AppValues.gapHM,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader("Condition"),
                    AppValues.gapS,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildConditionChip("New", 0),
                        _buildConditionChip("Used", 1),
                        _buildConditionChip("Broken", 2),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
          AppValues.gapL,

          // Pricing
          _buildSectionHeader("Pricing"),
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
                const Text("Asking Price"),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    prefixText: "₱ ",
                    hintText: "4,500",
                  ),
                  keyboardType: TextInputType.number,
                ),
                AppValues.gapS,
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Price is negotiable"),
                    Switch(
                      value: _isNegotiable,
                      onChanged: (val) => setState(() => _isNegotiable = val),
                    )
                  ],
                )
              ],
            ),
          ),
          AppValues.gapL,

          // Description
          _buildSectionHeader("Description & Details"),
          AppValues.gapS,
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              hintText:
                  "Describe the item, its condition and what buyers should know...",
            ),
            maxLines: 5,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, [String? trailing]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        if (trailing != null)
          Text(
            trailing,
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(color: AppColors.textGrey),
          ),
      ],
    );
  }

  Widget _buildPhotoUploader() {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.royalBlue.withOpacity(0.05),
            borderRadius: AppValues.borderRadiusM,
            border: Border.all(color: AppColors.royalBlue.withOpacity(0.2)),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.camera_alt, color: AppColors.royalBlue),
              Text("Add photos", style: TextStyle(color: AppColors.royalBlue)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoPlaceholder() {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.greyLight,
            borderRadius: AppValues.borderRadiusM,
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.greyLight,
        borderRadius: AppValues.borderRadiusM,
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Select Category"),
          Icon(Icons.arrow_drop_down, color: AppColors.textGrey),
        ],
      ),
    );
  }

  Widget _buildConditionChip(String label, int index) {
    final isSelected = _selectedCondition == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedCondition = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.royalBlue : AppColors.greyLight,
          borderRadius: AppValues.borderRadiusCircular,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: isSelected ? AppColors.white : AppColors.textDarkGrey,
              ),
        ),
      ),
    );
  }
}
