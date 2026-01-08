import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/post/widgets/sections/basic_info_section.dart';
import 'package:baylora_prjct/feature/post/widgets/sections/category_section.dart';
import 'package:baylora_prjct/feature/post/widgets/sections/description_section.dart';
import 'package:baylora_prjct/feature/post/widgets/sections/pricing_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
        title: const Text('Edit Listing'),
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        titleTextStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: AppColors.black,
          fontWeight: FontWeight.bold,
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
  late TextEditingController _swapPrefController; // NEW: For Trade/Mix

  // State Variables
  String? _selectedCategory;
  String? _selectedCondition; // NEW: Condition
  late String _listingType;   // 'cash', 'trade', or 'mix'

  // Validation
  bool _showTitleError = false;
  bool _showPriceError = false;
  bool _showDescriptionError = false;
  bool _showCategoryError = false;

  @override
  void initState() {
    super.initState();
    // 1. Initialize Basic Info
    _titleController = TextEditingController(text: widget.item['title'] ?? '');
    _descriptionController = TextEditingController(text: widget.item['description'] ?? '');

    // 2. Initialize Price (Safe Parsing)
    final priceVal = widget.item['price'];
    _priceController = TextEditingController(
        text: (priceVal != null) ? priceVal.toString() : ''
    );

    // 3. Initialize Type & Extras
    _listingType = widget.item['type'] ?? 'cash';
    _selectedCategory = widget.item['category'];
    _selectedCondition = widget.item['condition'] ?? 'Used'; // Default to Used if null

    // 4. Initialize Swap Preference (For Trade/Mix)
    // Note: Ensure your DB column is named 'swap_preference' or 'looking_for'
    _swapPrefController = TextEditingController(text: widget.item['swap_preference'] ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _swapPrefController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    // 1. Basic Validation
    setState(() {
      _showTitleError = _titleController.text.trim().isEmpty;
      _showCategoryError = _selectedCategory == null;
      _showDescriptionError = _descriptionController.text.trim().isEmpty;

      // Only validate price if it's Cash or Mix
      if (_listingType != 'trade') {
        _showPriceError = _priceController.text.trim().isEmpty;
      }
    });

    if (_showTitleError || _showCategoryError || _showDescriptionError || (_showPriceError && _listingType != 'trade')) {
      return;
    }

    try {
      // 2. Prepare Updates
      final Map<String, dynamic> updates = {
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'category': _selectedCategory,
        'condition': _selectedCondition,
        'updated_at': DateTime.now().toIso8601String(),
      };

      // Add Price only for Cash/Mix
      if (_listingType != 'trade') {
        updates['price'] = double.tryParse(_priceController.text) ?? 0;
      }

      // Add Swap Preference only for Trade/Mix
      if (_listingType != 'cash') {
        updates['swap_preference'] = _swapPrefController.text.trim();
      }

      // 3. Update Supabase
      await Supabase.instance.client
          .from('items')
          .update(updates)
          .eq('id', widget.itemId);

      // Invalidate providers
      ref.invalidate(editListingItemProvider(widget.itemId));
      ref.invalidate(itemDetailsProvider(widget.itemId));
      ref.invalidate(myListingsProvider);
      
      // Removed manageListingProvider invalidation as it has been consolidated into itemDetailsProvider

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
    // Helper booleans for UI logic
    final isTrade = _listingType == 'trade';
    final isMix = _listingType == 'mix';
    final showPrice = !isTrade; // Show price for Cash & Mix
    final showSwap = isTrade || isMix; // Show swap text for Trade & Mix

    return Container(
      color: AppColors.white,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppValues.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- SECTION: IMAGES (Placeholder for now) ---
            _buildImagePreview(),
            AppValues.gapL,

            // --- SECTION: BASIC INFO ---
            BasicInfoSection(
              titleController: _titleController,
              showError: _showTitleError,
              onChanged: (val) {},
            ),
            AppValues.gapL,

            // --- SECTION: CONDITION (New) ---
            const Text("Condition", style: TextStyle(fontWeight: FontWeight.bold)),
            AppValues.gapS,
            DropdownButtonFormField<String>(
              value: _selectedCondition,
              decoration: _inputDecoration(),
              items: [PostStrings.labelNew,
                PostStrings.labelUsed,
                PostStrings.labelBroken,
                PostStrings.labelFair
                 ].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (val) => setState(() => _selectedCondition = val),
            ),
            AppValues.gapL,

            // --- SECTION: CATEGORY ---
            CategorySection(
              selectedCategory: _selectedCategory,
              showError: _showCategoryError,
              onChanged: (val) => setState(() => _selectedCategory = val),
            ),
            AppValues.gapL,

            // --- SECTION: PRICE (Conditional) ---
            if (showPrice) ...[
              PricingSection(
                priceController: _priceController,
                showError: _showPriceError,
                onChanged: (val) {},
              ),
              AppValues.gapL,
            ],

            // --- SECTION: SWAP PREFERENCE (Conditional) ---
            if (showSwap) ...[
              const Text("Looking For (Swap Items)", style: TextStyle(fontWeight: FontWeight.bold)),
              AppValues.gapS,
              TextField(
                controller: _swapPrefController,
                decoration: _inputDecoration(hint: "e.g. iPhone 13, Gaming Laptop"),
              ),
              AppValues.gapL,
            ],

            // --- SECTION: DESCRIPTION ---
            DescriptionSection(
              descriptionController: _descriptionController,
              showError: _showDescriptionError,
              onChanged: (val) {},
            ),
            AppValues.gapXXL,

            // --- SAVE BUTTON ---
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

  // Helper for Styling inputs
  InputDecoration _inputDecoration({String? hint}) {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.greyLight,
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppValues.radiusM),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  // Helper for Image Preview (You can expand this later)
  Widget _buildImagePreview() {
    final images = widget.item['images'] as List<dynamic>? ?? [];
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length + 1, // +1 for "Add" button
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
