import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/post/widgets/sections/basic_info_section.dart';
import 'package:baylora_prjct/feature/post/widgets/sections/category_section.dart';
import 'package:baylora_prjct/feature/post/widgets/sections/description_section.dart';
import 'package:baylora_prjct/feature/post/widgets/sections/pricing_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final editListingItemProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, itemId) async {
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
        loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.royalBlue)),
        error: (error, stack) => Center(
          child: Text(
            'Error loading listing: $error',
            style: const TextStyle(color: AppColors.errorColor),
          ),
        ),
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
  late TextEditingController _titleController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  String? _selectedCategory;

  // Validation flags
  bool _showTitleError = false;
  final bool _showPriceError = false;
  bool _showDescriptionError = false;
  bool _showCategoryError = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.item['title'] ?? '');
    _descriptionController =
        TextEditingController(text: widget.item['description'] ?? '');
    _selectedCategory = widget.item['category'];

    // Handle price
    final price = widget.item['price'];
    _priceController =
        TextEditingController(text: price != null ? price.toString() : '');
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
      _showDescriptionError = _descriptionController.text.trim().isEmpty;
      _showCategoryError = _selectedCategory == null;
    });

    if (_showTitleError || _showDescriptionError || _showCategoryError) {
      return;
    }

    try {
      final updates = {
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'price': double.tryParse(_priceController.text) ?? 0,
        'category': _selectedCategory,
        'updated_at': DateTime.now().toIso8601String(),
      };

      await Supabase.instance.client
          .from('items')
          .update(updates)
          .eq('id', widget.itemId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Listing updated successfully!')),
        );
        ref.invalidate(editListingItemProvider(widget.itemId));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating listing: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppValues.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BasicInfoSection(
              titleController: _titleController,
              showError: _showTitleError,
              onChanged: (val) {
                if (val.trim().isNotEmpty && _showTitleError) {
                  setState(() => _showTitleError = false);
                }
              },
            ),
            AppValues.gapL,
            CategorySection(
              selectedCategory: _selectedCategory,
              showError: _showCategoryError,
              onChanged: (val) {
                setState(() {
                  _selectedCategory = val;
                  _showCategoryError = false;
                });
              },
            ),
            AppValues.gapL,
            PricingSection(
              priceController: _priceController,
              showError: _showPriceError,
              onChanged: (val) {
                // Validation logic if needed
              },
            ),
            AppValues.gapL,
            DescriptionSection(
              descriptionController: _descriptionController,
              showError: _showDescriptionError,
              onChanged: (val) {
                if (val.trim().isNotEmpty && _showDescriptionError) {
                  setState(() => _showDescriptionError = false);
                }
              },
            ),
            AppValues.gapXXL,
            ElevatedButton(
              onPressed: _handleSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.royalBlue,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: AppValues.borderRadiusM,
                ),
              ),
              child: Text(
                'Save Changes',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
