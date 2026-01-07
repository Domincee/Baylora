import 'dart:io';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/details/constants/item_details_strings.dart';
import 'package:baylora_prjct/feature/details/provider/bid_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BidInputModal extends ConsumerStatefulWidget {
  final String listingType;
  final double currentHighest;
  final double minimumBid;
  final String itemId; // Need itemId to insert into DB
  final double? initialBidAmount;

  const BidInputModal({
    super.key,
    required this.listingType,
    required this.currentHighest,
    required this.minimumBid,
    required this.itemId,
    this.initialBidAmount,
  });

  @override
  ConsumerState<BidInputModal> createState() => _BidInputModalState();
}

class _BidInputModalState extends ConsumerState<BidInputModal> {
  final ImagePicker _picker = ImagePicker();
  late TextEditingController _cashController;
  late TextEditingController _titleController;
  final List<String> _categories = ['Electronics', 'Clothing', 'Furniture', 'Other'];

  // Added repository instance

  bool get _isCash => widget.listingType == ItemDetailsStrings.typeCash;
  bool get _isTrade => widget.listingType == ItemDetailsStrings.typeTrade;
  bool get _isMix => widget.listingType == ItemDetailsStrings.typeMix;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current state or initial amount
    
    // Check if we need to prefill
    double startAmount = 0.0;
    if (widget.initialBidAmount != null) {
      startAmount = widget.initialBidAmount!;
      // Important: update the provider state too so it matches immediately
      // We do this in post frame callback to avoid provider modification during build/init
       WidgetsBinding.instance.addPostFrameCallback((_) {
         ref.read(bidProvider.notifier).setCashAmount(startAmount);
       });
    } else {
      final state = ref.read(bidProvider);
      startAmount = state.cashAmount;
    }

    _cashController = TextEditingController(
      text: startAmount > 0 ? startAmount.toStringAsFixed(0) : "",
    );
    _titleController = TextEditingController(text: ref.read(bidProvider).tradeTitle);

    // Load existing offer fully (images, trade details) if any
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        ref.read(bidProvider.notifier).loadExistingOffer(widget.itemId, user.id);
      }
    });
  }

  @override
  void dispose() {
    _cashController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bidState = ref.watch(bidProvider);
    final bidNotifier = ref.read(bidProvider.notifier);

    // Sync controllers with state for external changes (like Chips or Load Existing)
    ref.listen(bidProvider, (prev, next) {
      if (next.cashAmount != (double.tryParse(_cashController.text) ?? 0.0)) {
        final newText = next.cashAmount > 0 ? next.cashAmount.toStringAsFixed(0) : "";
        if (_cashController.text != newText) {
          _cashController.text = newText;
          _cashController.selection = TextSelection.fromPosition(
            TextPosition(offset: _cashController.text.length),
          );
        }
      }
      if (next.tradeTitle != _titleController.text) {
         _titleController.text = next.tradeTitle;
         _titleController.selection = TextSelection.fromPosition(
            TextPosition(offset: _titleController.text.length),
          );
      }
    });

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppValues.radiusXL)),
      ),
      child: Column(
        children: [
          // Handle
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: AppValues.spacingS),
              width: AppValues.spacingXXL,
              height: AppValues.spacingXXS,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(AppValues.radiusXXS),
              ),
            ),
          ),
          
          // Header
          Padding(
            padding: AppValues.paddingH,
            child: _buildHeader(bidState),
          ),
          
          const Divider(color: AppColors.greyLight),

          // Scrollable Body
          Expanded(
            child: SingleChildScrollView(
              padding: AppValues.paddingAll,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_isCash || _isMix) ...[
                    _buildCashSection(bidState, bidNotifier),
                    if (_isMix) const Divider(height: AppValues.spacingXL),
                  ],
                  if (_isTrade || _isMix) ...[
                    _buildTradeSection(bidState, bidNotifier),
                  ],
                ],
              ),
            ),
          ),

          // Action Button
          Padding(
            padding: AppValues.paddingAll,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _handleAction(context, bidState),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.royalBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppValues.radiusCircular),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: AppValues.spacingM),
                ),
                child: Text(
                  _isCash ? ItemDetailsStrings.confirmBid : ItemDetailsStrings.submitOffer,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BidState state) {
    String title = "";
    String? subtitle;
    

    bool isEditing = state.existingImageUrls.isNotEmpty || widget.initialBidAmount != null; 
    // Note: Checking initialBidAmount here is a quick way to know if we started in 'edit' mode for cash too.


    if (isEditing) {
       title = "Edit your Offer";
    } else {
      if (_isCash) {
        title = ItemDetailsStrings.placeYourBid;
      } else if (_isTrade) {
        title = "Place a Trade"; 
      } else {
        title = ItemDetailsStrings.placeYourOffer;
        subtitle = "Offer cash, trade an item, or combine both";
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        if (subtitle != null && !isEditing) ...[
          AppValues.gapXS,
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textGrey,
            ),
          ),
        ],
        AppValues.gapS,
      ],
    );
  }

  Widget _buildCashSection(BidState state, BidNotifier notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Stats Row
        Row(
          children: [
            Text(
              "Current Highest: ${ItemDetailsStrings.currencySymbol}${widget.currentHighest.toStringAsFixed(0)}",
              style: const TextStyle(color: AppColors.textGrey, fontSize: 12),
            ),
            AppValues.gapHM,
            Text(
              "Minimum Bid: ${ItemDetailsStrings.currencySymbol}${widget.minimumBid.toStringAsFixed(0)}",
              style: const TextStyle(color: AppColors.errorColor, fontSize: 12),
            ),
          ],
        ),
        AppValues.gapM,

        // Input
        TextField(
          keyboardType: TextInputType.number,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          decoration: const InputDecoration(
            prefixText: ItemDetailsStrings.currencySymbol,
            border: InputBorder.none,
            hintText: "0",
          ),
          onChanged: (value) {
            final val = double.tryParse(value) ?? 0.0;
            notifier.setCashAmount(val);
          },
          controller: _cashController,
        ),
        
        // Quick Add Chips
        Row(
          children: [100, 500, 1000].map((amount) {
            return Padding(
              padding: const EdgeInsets.only(right: AppValues.spacingS),
              child: ActionChip(
                label: Text("+${ItemDetailsStrings.currencySymbol}$amount"),
                backgroundColor: AppColors.greyLight,
                onPressed: () => notifier.addToCashAmount(amount.toDouble()),
                shape: const StadiumBorder(side: BorderSide.none),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTradeSection(BidState state, BidNotifier notifier) {
    int totalImages = state.existingImageUrls.length + state.tradeImages.length;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Photos
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Photos", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("$totalImages/3", style: const TextStyle(color: AppColors.textGrey)),
          ],
        ),
        AppValues.gapS,
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // Camera Button
              if (totalImages < 3)
                GestureDetector(
                  onTap: () async {
                    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
                    if (photo != null) {
                      notifier.addPhoto(File(photo.path));
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
                        Text("Add photos", style: TextStyle(fontSize: 10, color: AppColors.textGrey)),
                      ],
                    ),
                  ),
                ),
              
              // Existing Images (Network)
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

              // New Images (File)
              ...state.tradeImages.map((file) {
                return Stack(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      margin: const EdgeInsets.only(right: AppValues.spacingS),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppValues.radiusM),
                        image: DecorationImage(
                          image: FileImage(file),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 12,
                      child: GestureDetector(
                        onTap: () => notifier.removePhoto(file),
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
        AppValues.gapM,

        // Item Title
        const Text("Item title", style: TextStyle(fontWeight: FontWeight.bold)),
        AppValues.gapS,
        TextField(
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.greyLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppValues.radiusM),
              borderSide: BorderSide.none,
            ),
            hintText: "e.g. Nike Air Max",
          ),
          onChanged: notifier.setTradeTitle,
          controller: _titleController,
        ),
        AppValues.gapM,

        // Category
        const Text("Category", style: TextStyle(fontWeight: FontWeight.bold)),
        AppValues.gapS,
        DropdownButtonFormField<String>(
          value: state.tradeCategory,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.greyLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppValues.radiusM),
              borderSide: BorderSide.none,
            ),
            hintText: "Select Category",
          ),
          items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
          onChanged: (val) {
            if (val != null) notifier.setTradeCategory(val);
          },
        ),
        AppValues.gapM,

        // Condition
        const Text("Condition", style: TextStyle(fontWeight: FontWeight.bold)),
        AppValues.gapS,
        Row(
          children: ['New', 'Used', 'Broken'].map((cond) {
            final isSelected = state.tradeCondition == cond;
            return Padding(
              padding: const EdgeInsets.only(right: AppValues.spacingS),
              child: ChoiceChip(
                label: Text(cond),
                selected: isSelected,
                selectedColor: AppColors.royalBlue, 
                backgroundColor: AppColors.greyLight,
                labelStyle: TextStyle(
                  color: isSelected ? AppColors.white : AppColors.textGrey,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                onSelected: (val) {
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
      ],
    );
  }

  Future<void> _handleAction(BuildContext context, BidState state) async {
    // Validate
    if (_isCash || _isMix) {
      if (state.cashAmount <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter a valid amount")));
        return;
      }
    }
    if (_isTrade || _isMix) {
      if (state.tradeTitle.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter item title")));
        return;
      }
      if (state.tradeCategory == null) {

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select a category")));
        return;
      }
    }

    // Show Confirmation Modal
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Confirm Offer?"),
        content: const Text("Are you sure you want to submit this offer?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              // Confirm Logic
              Navigator.pop(dialogContext); // Close Dialog
              
              try {
                final user = Supabase.instance.client.auth.currentUser;
                if (user == null) {
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please login to submit an offer")));
                   return;
                }

                // Call submitOffer which handles upload and upsert
                final success = await ref.read(bidProvider.notifier).submitOffer(
                  itemId: widget.itemId,
                  userId: user.id,
                  isCash: _isCash,
                  isTrade: _isTrade,
                  isMix: _isMix,
                );

                if (success && context.mounted) {
                  Navigator.pop(context, true); // Close Input Modal with success
                } else if (!success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to submit offer")));
                }
              } catch (e) {
                debugPrint("Error submitting offer: $e");
                if (context.mounted) {
                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
                }
              }
            },
            child: const Text("Yes, Submit"),
          ),
        ],
      ),
    );
  }
}
