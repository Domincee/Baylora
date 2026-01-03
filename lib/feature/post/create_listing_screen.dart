import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/feature/post/widgets/listing_app_bar.dart';
import 'package:baylora_prjct/feature/post/widgets/listing_step_1.dart';
import 'package:baylora_prjct/feature/post/widgets/listing_step_2.dart';
import 'package:baylora_prjct/feature/post/widgets/listing_step_3.dart';
import 'package:baylora_prjct/feature/post/screens/post_success_screen.dart';
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

  // Validation State
  bool _showImageError = false;
  bool _showTitleError = false;
  bool _showCategoryError = false;
  bool _showDescriptionError = false;
  bool _showPriceError = false;
  bool _showWishlistError = false;

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
          if (_selectedImages.isNotEmpty && _showImageError) {
            _showImageError = false;
          }
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

  Future<List<String>> _uploadImages(List<File> images) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return [];

    List<String> uploadedUrls = [];

    for (var image in images) {
      try {
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final name = image.path.split(Platform.pathSeparator).last;
        final path = '${user.id}/${timestamp}_$name';

        await Supabase.instance.client.storage
            .from('item_images')
            .upload(path, image);

        final url = Supabase.instance.client.storage
            .from('item_images')
            .getPublicUrl(path);

        uploadedUrls.add(url);
      } catch (e) {
        debugPrint("Error uploading image: $e");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to upload an image: $e")),
          );
        }
      }
    }
    return uploadedUrls;
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
      // 1. Upload Images
      final imageUrls = await _uploadImages(_selectedImages);

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

      // --- DATA SANITIZATION START ---

      // Parse Price
      double? priceVal;
      // ONLY parse price if type is NOT Trade-only (so 0 or 2)
      if (_selectedType != 1) { 
        if (_priceController.text.isNotEmpty) {
           priceVal = double.tryParse(_priceController.text.replaceAll(',', ''));
        }
      } else {
        // Force null if it's Trade Only
        priceVal = null;
      }

      // Swap Preference
      String? swapPref;
      // ONLY use swap tags if type is NOT Cash-only (so 1 or 2)
      if (_selectedType != 0) {
        swapPref = _wishlistTags.join(', ');
      } else {
        // Force null/empty if it's Cash Only
        swapPref = null; 
      }
      
      // --- DATA SANITIZATION END ---

      // Calculate End Time
      final durationHours = int.tryParse(_durationController.text) ?? 24;
      final endTime = DateTime.now().add(Duration(hours: durationHours));


      final response = await Supabase.instance.client.from('items').insert({
        'owner_id': user.id,
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'type': typeStr,
        'price': priceVal, // Uses sanitized value
        'swap_preference': swapPref, // Uses sanitized value
        'images': imageUrls, 
        'condition': conditionStr,
        'category': _selectedCategory,
        'end_time': endTime.toIso8601String(),
        'status': 'active', 
      }).select().single();

      final newItemId = response['id'].toString();

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PostSuccessScreen(newItemId: newItemId),
          ),
        );
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

  void _validateStep2() {
    bool hasError = false;

    // Reset errors
    setState(() {
      _showImageError = false;
      _showTitleError = false;
      _showCategoryError = false;
      _showDescriptionError = false;
      _showPriceError = false;
      _showWishlistError = false;
    });

    // Images
    if (_selectedImages.isEmpty) {
      _showImageError = true;
      hasError = true;
    }

    // Title
    if (_titleController.text.trim().isEmpty) {
      _showTitleError = true;
      hasError = true;
    }

    // Category
    if (_selectedCategory == null) {
      _showCategoryError = true;
      hasError = true;
    }

    // Description
    if (_descriptionController.text.trim().isEmpty) {
      _showDescriptionError = true;
      hasError = true;
    }

    // Price (Sell or Both)
    if (_selectedType == 0 || _selectedType == 2) {
      double? priceVal;
      if (_priceController.text.isNotEmpty) {
        priceVal = double.tryParse(_priceController.text.replaceAll(',', ''));
      }
      if (priceVal == null || priceVal == 0) {
        _showPriceError = true;
        hasError = true;
      }
    }

    // Wishlist (Trade or Both)
    if (_selectedType == 1 || _selectedType == 2) {
      if (_wishlistTags.isEmpty) {
        _showWishlistError = true;
        hasError = true;
      }
    }

    if (hasError) {
      setState(() {}); // Trigger rebuild to show errors
      return;
    }

    // Proceed to Step 3
    setState(() => _currentStep++);
  }

  // ====== Main Build ======
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.white,
          appBar: ListingAppBar(
            currentStep: _currentStep,
            step2Title: _getStep2Title(),
            isNextEnabled: _selectedType != -1,
            onNext: () {
              if (_currentStep == 1) {
                _validateStep2();
              } else {
                setState(() => _currentStep++);
              }
            },
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
                onCategoryChanged: (val) {
                  setState(() {
                    _selectedCategory = val;
                    if (_selectedCategory != null && _showCategoryError) {
                      _showCategoryError = false;
                    }
                  });
                },
                selectedCondition: _selectedCondition,
                onConditionChanged: (val) => setState(() => _selectedCondition = val),
                priceController: _priceController,
                descriptionController: _descriptionController,
                wishlistTags: _wishlistTags,
                onTagAdded: (tag) {
                  setState(() {
                    _wishlistTags.add(tag);
                    if (_wishlistTags.isNotEmpty && _showWishlistError) {
                      _showWishlistError = false;
                    }
                  });
                },
                onTagRemoved: (tag) => setState(() => _wishlistTags.remove(tag)),
                images: _selectedImages,
                onAddPhoto: _pickImage,
                showImageError: _showImageError,
                showTitleError: _showTitleError,
                showCategoryError: _showCategoryError,
                showDescriptionError: _showDescriptionError,
                showPriceError: _showPriceError,
                showWishlistError: _showWishlistError,
                onTitleChanged: (val) {
                  if (val.trim().isNotEmpty && _showTitleError) {
                    setState(() => _showTitleError = false);
                  }
                },
                onDescriptionChanged: (val) {
                  if (val.trim().isNotEmpty && _showDescriptionError) {
                    setState(() => _showDescriptionError = false);
                  }
                },
                onPriceChanged: (val) {
                  if (val.trim().isNotEmpty && _showPriceError) {
                    setState(() => _showPriceError = false);
                  }
                },
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
        ),

        // Loading Overlay
        if (_isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.5),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(
                      color: AppColors.royalBlue,
                    ),
                    AppValues.gapS,
                    const Text(
                      "Publishing your listing...",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
