import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/post/widgets/sections/basic_info_section.dart';
import 'package:baylora_prjct/feature/post/widgets/sections/category_section.dart';
import 'package:baylora_prjct/feature/post/widgets/sections/description_section.dart';
import 'package:baylora_prjct/feature/post/widgets/sections/pricing_section.dart';
import 'package:baylora_prjct/feature/post/widgets/sections/trade_section.dart'; // Ensure this is imported
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/constant/listing_constants.dart';
import '../constants/post_strings.dart';
import 'package:baylora_prjct/feature/details/provider/item_details_provider.dart';
import 'package:baylora_prjct/feature/profile/provider/profile_provider.dart';

final editListingItemProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, itemId) async {
  final response = await Supabase.instance.client
      .from('items')
      .select()
      .eq('id', itemId)
      .single();
  return response;
});

class EditListingScreen extends ConsumerWidget {
  final String itemId;

  const EditListingScreen({super.key, required this.itemId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemAsyncValue = ref.watch(editListingItemProvider(itemId));

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text('Edit Listing', style: Theme.of(context).textTheme.titleSmall),
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: itemAsyncValue.when(
        data: (item) => _EditListingForm(item: item, itemId: itemId),
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.royalBlue)),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}

class _EditListingForm extends ConsumerStatefulWidget {
  final Map<String, dynamic> item;
  final String itemId;

  const _EditListingForm({required this.item, required this.itemId});

  @override
  ConsumerState<_EditListingForm> createState() => _EditListingFormState();
}

class _EditListingFormState extends ConsumerState<_EditListingForm> {
  // Controllers
  late TextEditingController _titleController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;

  // State Variables
  String? _selectedCategory;
  String? _selectedCondition;
  late String _listingType;
  List<String> _swapTags = []; // ✅ Properly declared list

  // Validation
  bool _showTitleError = false;
  bool _showPriceError = false;
  bool _showDescriptionError = false;
  bool _showCategoryError = false;

  @override
  void initState() {
    super.initState();

    // 1. Basic Info
    _titleController = TextEditingController(text: widget.item['title'] ?? '');
    _descriptionController = TextEditingController(text: widget.item['description'] ?? '');

    // 2. Price
    final priceVal = widget.item['price'];
    _priceController = TextEditingController(
        text: (priceVal != null) ? priceVal.toString() : ''
    );

    // 3. Category Guard
    final String? dbCategory = widget.item['category'];
    if (ListingConstants.categories.contains(dbCategory)) {
      _selectedCategory = dbCategory;
    } else {
      _selectedCategory = null;
    }

    // 4. Listing Type & Condition
    _listingType = widget.item['type'] ?? 'cash';
    _selectedCondition = widget.item['condition'] ?? 'Used';

    // 5. ✅ CORRECTED: Tag Parsing inside initState
    final String rawSwap = widget.item['swap_preference'] ?? '';
    if (rawSwap.isNotEmpty) {
      _swapTags = rawSwap
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    } else {
      _swapTags = [];
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    setState(() {
      _showTitleError = _titleController.text.trim().isEmpty;
      _showCategoryError = _selectedCategory == null;
      _showDescriptionError = _descriptionController.text.trim().isEmpty;
      if (_listingType != 'trade') {
        _showPriceError = _priceController.text.trim().isEmpty;
      }
    });

    if (_showTitleError || _showCategoryError || _showDescriptionError || (_showPriceError && _listingType != 'trade')) {
      return;
    }

    try {
      final Map<String, dynamic> updates = {
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'category': _selectedCategory,
        'condition': _selectedCondition,
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (_listingType != 'trade') {
        updates['price'] = double.tryParse(_priceController.text) ?? 0;
      }

      // ✅ Join tags back to a string for Supabase
      if (_listingType != 'cash') {
        updates['swap_preference'] = _swapTags.join(', ');
      }

      await Supabase.instance.client
          .from('items')
          .update(updates)
          .eq('id', widget.itemId);

      ref.invalidate(editListingItemProvider(widget.itemId));
      ref.invalidate(itemDetailsProvider(widget.itemId));
      ref.invalidate(myListingsProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved!')));
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTrade = _listingType == 'trade';
    final isMix = _listingType == 'mix';
    final showPrice = !isTrade;
    final showSwap = isTrade || isMix;

    return Container(
      color: AppColors.white,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppValues.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildImagePreview(),
            AppValues.gapL,

            BasicInfoSection(
              titleController: _titleController,
              showError: _showTitleError,
              onChanged: (val) {},
            ),
            AppValues.gapL,

            Text("Condition", style: Theme.of(context).textTheme.titleSmall),
            AppValues.gapS,
            DropdownButtonFormField<String>(
              value: _selectedCondition,
              decoration: _inputDecoration(),
              items: [
                PostStrings.labelNew,
                PostStrings.labelUsed,
                PostStrings.labelBroken,
                PostStrings.labelFair
              ].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (val) => setState(() => _selectedCondition = val),
            ),
            AppValues.gapL,

            CategorySection(
              selectedCategory: _selectedCategory,
              showError: _showCategoryError,
              onChanged: (val) => setState(() => _selectedCategory = val),
            ),
            AppValues.gapL,

            if (showPrice) ...[
              PricingSection(
                priceController: _priceController,
                showError: _showPriceError,
                onChanged: (val) {},
              ),
              AppValues.gapL,
            ],

            // ✅ Using your reusable TradeSection for Pills
            if (showSwap) ...[
              TradeSection(
                tags: _swapTags,
                onTagAdded: (newTag) {
                  if (!_swapTags.contains(newTag)) {
                    setState(() => _swapTags.add(newTag));
                  }
                },
                onTagRemoved: (tagToRemove) {
                  setState(() => _swapTags.remove(tagToRemove));
                },
                showError: false,
              ),
              AppValues.gapL,
            ],

            DescriptionSection(
              descriptionController: _descriptionController,
              showError: _showDescriptionError,
              onChanged: (val) {},
            ),
            AppValues.gapXXL,

            ElevatedButton(
              onPressed: _handleSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.royalBlue,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: AppValues.borderRadiusM),
              ),
              child: const Text('Save Changes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.greyLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppValues.radiusM),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  Widget _buildImagePreview() {
    final images = widget.item['images'] as List<dynamic>? ?? [];
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Container(
              width: 100,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: AppColors.greyLight,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.greyMedium),
              ),
              child: const Icon(Icons.add_a_photo, color: AppColors.royalBlue),
            );
          }
          final url = images[index - 1];
          return Container(
            width: 100,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
            ),
          );
        },
      ),
    );
  }
}