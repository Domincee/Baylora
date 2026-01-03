import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/post/widgets/listing_app_bar.dart';
import 'package:baylora_prjct/feature/post/widgets/listing_step_1.dart';
import 'package:baylora_prjct/feature/post/widgets/listing_step_2.dart';
import 'package:baylora_prjct/feature/post/widgets/listing_step_3.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
  bool _isLoading = false;

  final _titleController = TextEditingController();
  final _durationController = TextEditingController(text: '1');
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  final List<String> _wishlistTags = [];
  
  // Image selection
  final ImagePicker _picker = ImagePicker();
  final List<File> _selectedImages = [];

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
  
  Future<void> _pickImage() async {
    if (_selectedImages.length >= 3) return;
    
    try {
      debugPrint("Picking image...");
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        debugPrint("Image picked: ${image.path}");
        setState(() {
          _selectedImages.add(File(image.path));
        });
      } else {
        debugPrint("Image picking canceled");
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
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

  String _getConditionLabel(int conditionIndex) {
    switch (conditionIndex) {
      case 0:
        return "New";
      case 1:
        return "Used";
      case 2:
        return "Broken";
      case 3:
        return "Fair";
      default:
        return "Used";
    }
  }

  Future<void> _handlePublish() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not logged in")),
      );
      return;
    }

    if (_titleController.text.trim().isEmpty) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Title is required")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Map Type
      String typeStr;
      switch (_selectedType) {
        case 0:
          typeStr = 'cash';
          break;
        case 1:
          typeStr = 'trade';
          break;
        case 2:
          typeStr = 'mix';
          break;
        default:
          typeStr = 'cash';
      }

      // Map Condition (for DB - lowercase)
      String conditionStr = 'used';
      switch (_selectedCondition) {
        case 0:
          conditionStr = 'new';
          break;
        case 1:
          conditionStr = 'used';
          break;
        case 2:
          conditionStr = 'broken';
          break;
        case 3:
          conditionStr = 'fair'; // Changed from 'good' to 'fair'
          break;
      }

      // Parse Price
      double? priceVal;
      if (_selectedType != 1 && _priceController.text.isNotEmpty) {
        priceVal = double.tryParse(_priceController.text.replaceAll(',', ''));
      }

      // Calculate End Time
      final durationHours = int.tryParse(_durationController.text) ?? 24;
      final endTime = DateTime.now().add(Duration(hours: durationHours));

      // Swap Preference
      final swapPref = _wishlistTags.join(', ');

      await Supabase.instance.client.from('items').insert({
        'owner_id': user.id,
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'type': typeStr,
        'price': priceVal,
        'swap_preference': swapPref,
        'images': [], // Images are currently sent as an empty list []. Image upload logic must be implemented in the next step.
        'condition': conditionStr,
        'category': _selectedCategory,
        'end_time': endTime.toIso8601String(),
        'status': 'active', 
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Listing Published!")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error publishing listing: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // ====== Main Build ======
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
            images: _selectedImages,
            onAddPhoto: _pickImage,
          ),
          ListingStep3(
            images: _selectedImages,
            title: _titleController.text,
            category: _selectedCategory ?? "N/A",
            condition: _getConditionLabel(_selectedCondition),
            duration: _isDurationEnabled ? "${_durationController.text} hrs" : null,
            description: _descriptionController.text,
            price: _priceController.text,
            wishlistTags: _wishlistTags,
            selectedType: _selectedType,
            onPost: _handlePublish,
          ),
        ],
      ),
    );
  }
}
