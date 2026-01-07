import 'dart:io';

import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/core/util/network_utils.dart';
import 'package:baylora_prjct/feature/auth/services/auth_service.dart';
import 'package:baylora_prjct/feature/post/constants/post_db_values.dart';
import 'package:baylora_prjct/feature/post/constants/post_strings.dart';
import 'package:baylora_prjct/feature/post/repository/listing_repository.dart';
import 'package:baylora_prjct/feature/post/screens/post_success_screen.dart';
import 'package:baylora_prjct/feature/post/widgets/listing_app_bar.dart';
import 'package:baylora_prjct/feature/post/widgets/listing_step_1.dart';
import 'package:baylora_prjct/feature/post/widgets/listing_step_2.dart';
import 'package:baylora_prjct/feature/post/widgets/listing_step_3.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateListingScreen extends ConsumerStatefulWidget {
  const CreateListingScreen({super.key});

  @override
  ConsumerState<CreateListingScreen> createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends ConsumerState<CreateListingScreen> {
  // --- Dependencies ---
  final ListingRepository _repository = ListingRepository();

  // --- State Variables ---
  int _currentStep = 0;
  int _selectedType = -1;
  int _selectedCondition = 1; // 0: New, 1: Used, 2: Broken, 3: Fair

  bool _isDurationEnabled = false;
  String? _selectedCategory;
  bool _isLoading = false;

  final _titleController = TextEditingController();
  final _durationController = TextEditingController(text: PostDbValues.defaultDuration);
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
      if (kDebugMode) debugPrint("Picking image...");
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        if (kDebugMode) debugPrint("Image picked: ${image.path}");
        setState(() {
          _selectedImages.add(File(image.path));
          if (_selectedImages.isNotEmpty && _showImageError) {
            _showImageError = false;
          }
        });
      } else {
        if (kDebugMode) debugPrint("Image picking canceled");
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void _removePhoto(File file) {
    setState(() {
      _selectedImages.remove(file);
    });
  }

  String _getStep2Title() {
    switch (_selectedType) {
      case 0:
        return PostStrings.sellItem;
      case 1:
        return PostStrings.tradeItem;
      case 2:
        return PostStrings.sellTradeItem;
      default:
        return "";
    }
  }

  String _getConditionLabel(int conditionIndex) {
    switch (conditionIndex) {
      case 0:
        return PostStrings.labelNew;
      case 1:
        return PostStrings.labelUsed;
      case 2:
        return PostStrings.labelBroken;
      case 3:
        return PostStrings.labelFair;
      default:
        return PostStrings.labelUsed;
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // ====== Data Handling ======

  String _getTypeDbValue() {
    switch (_selectedType) {
      case 0:
        return 'cash';
      case 1:
        return 'trade';
      case 2:
        return 'mix';
      default:
        return 'cash';
    }
  }

  String _getConditionDbValue() {
    switch (_selectedCondition) {
      case 0:
        return 'new';
      case 1:
        return 'used';
      case 2:
        return 'broken';
      case 3:
        return 'fair';
      default:
        return 'used';
    }
  }

  double? _getSanitizedPrice() {
    // If trade only, price is null
    if (_selectedType == 1) return null;

    if (_priceController.text.isNotEmpty) {
      return double.tryParse(_priceController.text.replaceAll(',', ''));
    }
    return null;
  }

  String? _getSanitizedSwapPreference() {
    // If cash only, swap preference is null
    if (_selectedType == 0) return null;
    return _wishlistTags.join(', ');
  }

  String? _getEndTime() {
    if (!_isDurationEnabled) return null;

    final durationHours = int.tryParse(_durationController.text) ?? 24;
    final endTime = DateTime.now().add(Duration(hours: durationHours));
    return endTime.toIso8601String();
  }

  Future<void> _handlePublish() async {
    final user = ref.read(userProvider);
    if (user == null) {
      _showSnackBar(PostStrings.msgUserNotLoggedIn);
      return;
    }

    if (_titleController.text.trim().isEmpty) {
      _showSnackBar(PostStrings.msgTitleRequired);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final imageUrls = await _repository.uploadImages(_selectedImages, user.id);

      final insertData = {
        'owner_id': user.id,
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'type': _getTypeDbValue(),
        'price': _getSanitizedPrice(),
        'swap_preference': _getSanitizedSwapPreference(),
        'images': imageUrls,
        'condition': _getConditionDbValue(),
        'category': _selectedCategory,
        'end_time': _getEndTime(),
        'status': PostDbValues.statusActive,
      };

      final newItemId = await _repository.createListing(insertData);

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
        // Try to distinguish upload errors vs generic errors if possible,
        // or just use generic error handler.
        // Assuming NetworkUtils is a helper that can format exceptions.
        final message = NetworkUtils.getErrorMessage(e,
            prefix: PostStrings.msgPublishError);
        _showSnackBar(message);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _validateStep2() {
    bool hasError = false;

    // Check local variables to avoid multiple setStates
    bool imgErr = false;
    bool titleErr = false;
    bool catErr = false;
    bool descErr = false;
    bool priceErr = false;
    bool wishErr = false;

    // Images
    if (_selectedImages.isEmpty) {
      imgErr = true;
      hasError = true;
    }

    // Title
    if (_titleController.text.trim().isEmpty) {
      titleErr = true;
      hasError = true;
    }

    // Category
    if (_selectedCategory == null) {
      catErr = true;
      hasError = true;
    }

    // Description
    if (_descriptionController.text.trim().isEmpty) {
      descErr = true;
      hasError = true;
    }

    // Price (Sell or Both)
    if (_selectedType == 0 || _selectedType == 2) {
      double? priceVal;
      if (_priceController.text.isNotEmpty) {
        priceVal = double.tryParse(_priceController.text.replaceAll(',', ''));
      }
      if (priceVal == null || priceVal == 0) {
        priceErr = true;
        hasError = true;
      }
    }

    // Wishlist (Trade or Both)
    if (_selectedType == 1 || _selectedType == 2) {
      if (_wishlistTags.isEmpty) {
        wishErr = true;
        hasError = true;
      }
    }

    // Update state once
    setState(() {
      _showImageError = imgErr;
      _showTitleError = titleErr;
      _showCategoryError = catErr;
      _showDescriptionError = descErr;
      _showPriceError = priceErr;
      _showWishlistError = wishErr;
    });

    if (hasError) return;

    // Proceed to Step 3
    setState(() => _currentStep++);
  }

  void _nextStep() {
    if (_currentStep == 1) {
      _validateStep2();
    } else {
      setState(() => _currentStep++);
    }
  }

  void _prevStep() {
    setState(() => _currentStep--);
  }

  // ====== Main Build ======
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.white,
          appBar: _currentStep == 1
              ? null // Step 2 handles its own header
              : ListingAppBar(
                  currentStep: _currentStep,
                  step2Title: _getStep2Title(),
                  isNextEnabled: _selectedType != -1,
                  onNext: _nextStep,
                  onBack: _prevStep,
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
                onToggleDuration: (val) =>
                    setState(() => _isDurationEnabled = val),
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
                onConditionChanged: (val) =>
                    setState(() => _selectedCondition = val),
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
                onTagRemoved: (tag) =>
                    setState(() => _wishlistTags.remove(tag)),
                images: _selectedImages,
                onAddPhoto: _pickImage,
                onRemovePhoto: _removePhoto,
                onNext: _validateStep2,
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
                category: _selectedCategory ?? PostStrings.labelNA,
                condition: _getConditionLabel(_selectedCondition),
                duration: _isDurationEnabled
                    ? "${_durationController.text}${PostStrings.hoursSuffix}"
                    : null,
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
              color: AppColors.black.withValues(alpha: 0.5),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(
                      color: AppColors.royalBlue,
                    ),
                    AppValues.gapS,
                    Text(PostStrings.publishingYourListing,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: AppColors.white,
                            )),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
