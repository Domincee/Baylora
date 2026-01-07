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
        // ... styling ...
      ),
      body: itemAsyncValue.when(
        data: (item) => _EditListingForm(item: item, itemId: itemId),
        loading: () =>
        const Center(
            child: CircularProgressIndicator(color: AppColors.royalBlue)),
        error: (error, stack) =>
            Center(
              child: Text('Error loading listing: $error'),
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

  // ... (validation flags) ...

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.item['title'] ?? '');
    _descriptionController =
        TextEditingController(text: widget.item['description'] ?? '');
    _selectedCategory = widget.item['category'];
    final price = widget.item['price'];
    _priceController =
        TextEditingController(text: price != null ? price.toString() : '');
  }

  // ... (dispose) ...

  Future<void> _handleSave() async {
    // ... (Validation logic) ...

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
      // ... (Form Layout: BasicInfoSection, CategorySection, PricingSection, DescriptionSection, Save Button) ...
    );
  }
} // ... imports ...

import 'package:baylora_prjct/feature/manage_listing/screens/manage_listing_screen.dart';

class ProfileListingsSection extends ConsumerWidget {
  const ProfileListingsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listingsAsync = ref.watch(myListingsProvider);

    return listingsAsync.when(
      data: (listings) {
        // ... (data processing) ...

        return Column(
          children: [
            ListView.separated(
              // ...
              itemBuilder: (context, index) {
                // ... (item extraction) ...

                return ManagementListingCard(
                  // ... (props) ...
                  onAction: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ManageListingScreen(itemId: item['id'].toString()),
                      ),
                    );
                  },
                );
              },
            ),
            // ...
          ],
        );
      },
      // ... (loading/error states) ...
    );
  }
}