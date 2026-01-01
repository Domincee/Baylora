import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/post/widgets/listing_app_bar.dart';
import 'package:baylora_prjct/feature/post/widgets/listing_step_1.dart';
import 'package:baylora_prjct/feature/post/widgets/listing_step_2.dart';
import 'package:baylora_prjct/feature/post/widgets/listing_step_3.dart';

class CreateListingScreen extends StatefulWidget {
  const CreateListingScreen({super.key});

  @override
  State<CreateListingScreen> createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends State<CreateListingScreen> {
  int _currentStep = 0;
  int _selectedType = -1;
  int _selectedCondition = 1; // 0: New, 1: Used, 2: Broken, 3: Fair

  bool _isDurationEnabled = false;
  String? _selectedCategory;

  final _titleController = TextEditingController();
  final _durationController = TextEditingController(text: '1');
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  final List<String> _wishlistTags = [];

  @override
  void dispose() {
    _titleController.dispose();
    _durationController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // ====== Logic Helpers ======
  void _incrementDuration() {
    int current = int.tryParse(_durationController.text) ?? 0;
    setState(() {
      _durationController.text = (current + 1).toString();
    });
  }

  void _decrementDuration() {
    int current = int.tryParse(_durationController.text) ?? 0;
    if (current > 1) {
      setState(() {
        _durationController.text = (current - 1).toString();
      });
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

  void _handlePublish() {
    // Dummy publish logic
    debugPrint("Listing Published!");
    debugPrint("Title: ${_titleController.text}");
    debugPrint("Type: $_selectedType");
    Navigator.pop(context);
  }

  // ====== Main Build ======
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: ListingAppBar(
        currentStep: _currentStep,
        step2Title: _getStep2Title(),
        isNextEnabled: _selectedType != -1,
        onNext: () => setState(() => _currentStep++),
        onBack: () => setState(() => _currentStep--),
        onClose: () => Navigator.pop(context),
      ),
      body: IndexedStack(
        index: _currentStep,
        children: [
          ListingStep1(
            selectedType: _selectedType,
            onTypeSelected: (val) => setState(() => _selectedType = val),
          ),
          ListingStep2(
            selectedType: _selectedType,
            titleController: _titleController,
            durationController: _durationController,
            isDurationEnabled: _isDurationEnabled,
            onToggleDuration: (val) => setState(() => _isDurationEnabled = val),
            onIncrementDuration: _incrementDuration,
            onDecrementDuration: _decrementDuration,
            selectedCategory: _selectedCategory,
            onCategoryChanged: (val) => setState(() => _selectedCategory = val),
            selectedCondition: _selectedCondition,
            onConditionChanged: (val) => setState(() => _selectedCondition = val),
            priceController: _priceController,
            descriptionController: _descriptionController,
            wishlistTags: _wishlistTags,
            onTagAdded: (tag) => setState(() => _wishlistTags.add(tag)),
            onTagRemoved: (tag) => setState(() => _wishlistTags.remove(tag)),
          ),
          ListingStep3(
            selectedType: _selectedType,
            title: _titleController.text,
            price: _priceController.text,
            description: _descriptionController.text,
            selectedCondition: _selectedCondition,
            wishlistTags: _wishlistTags,
            onPublish: _handlePublish,
          ),
        ],
      ),
    );
  }
}
