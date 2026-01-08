import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/bid/widgets/sections/bid_cash_section.dart';
import 'package:baylora_prjct/feature/bid/widgets/sections/bid_trade_section.dart';
import 'package:baylora_prjct/feature/chat/deal_chat_screen.dart';
import 'package:baylora_prjct/feature/details/constants/item_details_strings.dart';
import 'package:baylora_prjct/feature/details/provider/bid_provider.dart';
import 'package:baylora_prjct/feature/profile/widgets/management_listing_card.dart'; // Import offerSubscriptionProvider
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../sections/bid_header_section.dart';

class BidInputModal extends ConsumerStatefulWidget {
  final String listingType;
  final double currentHighest;
  final double minimumBid;
  final String itemId;
  final double? initialBidAmount;
  final Map<String, dynamic>? initialOffer;

  const BidInputModal({
    super.key,
    required this.listingType,
    required this.currentHighest,
    required this.minimumBid,
    required this.itemId,
    this.initialBidAmount,
    this.initialOffer,
  });

  @override
  ConsumerState<BidInputModal> createState() => _BidInputModalState();
}

class _BidInputModalState extends ConsumerState<BidInputModal> {
  final ImagePicker _picker = ImagePicker();
  late TextEditingController _cashController;
  late TextEditingController _titleController;

  bool get _isCash => widget.listingType == ItemDetailsStrings.typeCash;
  bool get _isTrade => widget.listingType == ItemDetailsStrings.typeTrade;
  bool get _isMix => widget.listingType == ItemDetailsStrings.typeMix;

  @override
  void initState() {
    super.initState();

    double startAmount = 0.0;

    // Only pre-fill amount if it is a CASH listing
    if (_isCash && widget.initialBidAmount != null) {
      startAmount = widget.initialBidAmount!;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(bidProvider.notifier).setCashAmount(startAmount);
      });
    }

    _cashController = TextEditingController(
      text: startAmount > 0 ? startAmount.toStringAsFixed(0) : "",
    );
    _titleController = TextEditingController(text: "");

    // Only load existing offer data from DB if it is CASH
    if (_isCash) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final user = Supabase.instance.client.auth.currentUser;
        if (user != null) {
          ref.read(bidProvider.notifier).loadExistingOffer(widget.itemId, user.id);
        }
      });
    }
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

    // Watch LIVE offer updates
    final offersAsync = ref.watch(offerSubscriptionProvider(widget.itemId));
    final userId = Supabase.instance.client.auth.currentUser?.id;

    // Determine Status
    // Start with initialOffer status
    Map<String, dynamic>? myOffer = widget.initialOffer;
    String status = (myOffer?['status'] ?? 'pending').toString().toLowerCase();

    // Update with live data if available
    final offers = offersAsync.valueOrNull;
    if (offers != null && userId != null) {
      try {
        final liveOffer = offers.firstWhere((o) => o['user_id'] == userId);
        myOffer = liveOffer;
        status = (liveOffer['status'] ?? 'pending').toString().toLowerCase();
      } catch (_) {
        // User might not have an offer yet in live data
      }
    }

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
                borderRadius: AppValues.borderRadiusCircular,
              ),
            ),
          ),

          // Header
          Padding(
            padding: AppValues.paddingH,
            child: BidHeaderSection(
              isCash: _isCash,
              isTrade: _isTrade,
              isEditing: _isCash && widget.initialBidAmount != null,
              status: status, // Pass Status
            ),
          ),

          const Divider(color: AppColors.greyLight),

          // Scrollable Body with Dynamic Layouts
          Expanded(
            child: SingleChildScrollView(
              padding: AppValues.paddingAll,
              child: _buildBodyLayout(bidState, bidNotifier, status),
            ),
          ),

          // Action Button
          Padding(
            padding: AppValues.paddingAll,
            child: _buildActionButton(context, bidState, status, myOffer),
          ),
        ],
      ),
    );
  }

  // --- Layout Selector ---
  Widget _buildBodyLayout(BidState state, BidNotifier notifier, String status) {
    if (_isMix) {
      // 1. MIX LAYOUT: Photos -> Price -> Details
      return BidTradeSection(
        state: state,
        notifier: notifier,
        titleController: _titleController,
        picker: _picker,
        status: status,
        priceSection: BidCashSection(
          currentHighest: widget.currentHighest,
          minimumBid: widget.minimumBid,
          controller: _cashController,
          onAmountChanged: notifier.setCashAmount,
          onAddAmount: notifier.addToCashAmount,
          status: status, // Pass Status
        ),
      );
    } else if (_isCash) {
      // 2. CASH LAYOUT: Price Only
      return BidCashSection(
        currentHighest: widget.currentHighest,
        minimumBid: widget.minimumBid,
        controller: _cashController,
        onAmountChanged: notifier.setCashAmount,
        onAddAmount: notifier.addToCashAmount,
        status: status, // Pass Status
      );
    } else {
      // 3. TRADE LAYOUT: Photos -> Details
      return BidTradeSection(
        state: state,
        notifier: notifier,
        titleController: _titleController,
        picker: _picker,
        status: status,
      );
    }
  }

  Widget _buildActionButton(BuildContext context, BidState bidState, String status, Map<String, dynamic>? myOffer) {
    String label = _isCash ? ItemDetailsStrings.confirmBid : ItemDetailsStrings.submitOffer;
    Color bgColor = AppColors.royalBlue;
    Color textColor = AppColors.white;
    VoidCallback? onTap = () => _handleAction(context, bidState);

    if (status == 'accepted') {
      label = "Deal Chat";
      bgColor = AppColors.successColor;
      onTap = () {
        Navigator.pop(context); // Close modal
        // Navigate to chat
        if (myOffer != null) {
          // We need to fetch the item details to get the seller name or pass it in
          // For now, we use a placeholder or check if myOffer has profile expansion
          // NOTE: The subscription provider might not expand profiles depending on query
          // Assuming we navigate to chat with offer context
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DealChatScreen(
                chatTitle: "Seller", // You might want to fetch seller name properly if needed
                itemName: "Item", // Pass item name if available
                contextId: myOffer['id'],
              ),
            ),
          );
        }
      };
    } else if (status == 'rejected') {
      label = "Rejected";
      bgColor = AppColors.greyDisabled;
      textColor = AppColors.grey400;
      onTap = null;
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          disabledBackgroundColor: AppColors.greyDisabled,
          shape: RoundedRectangleBorder(
            borderRadius: AppValues.borderRadiusCircular,
          ),
          padding: const EdgeInsets.symmetric(vertical: AppValues.spacingM),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<void> _handleAction(BuildContext context, BidState state) async {
    if (_isCash || _isMix) {
      if (state.cashAmount <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(ItemDetailsStrings.enterValidAmount)));
        return;
      }
    }
    if (_isTrade || _isMix) {
      if (state.tradeTitle.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(ItemDetailsStrings.enterTitle)));
        return;
      }
      if (state.tradeCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(ItemDetailsStrings.enterCategory)));
        return;
      }
    }

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(ItemDetailsStrings.confirmOffer),
        content: const Text(ItemDetailsStrings.areYouSure),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(ItemDetailsStrings.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext); // Close Dialog

              try {
                final user = Supabase.instance.client.auth.currentUser;
                if (user == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(ItemDetailsStrings.pleaseLogin)));
                  return;
                }

                final success = await ref.read(bidProvider.notifier).submitOffer(
                  itemId: widget.itemId,
                  userId: user.id,
                  isCash: _isCash,
                  isTrade: _isTrade,
                  isMix: _isMix,
                );

                if (success && context.mounted) {
                  Navigator.pop(context, true);
                } else if (!success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(ItemDetailsStrings.failedSubmitOffer)));
                }
              } catch (e) {
                debugPrint("${ItemDetailsStrings.errorSubmit} $e");
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
                }
              }
            },
            child: const Text(ItemDetailsStrings.yesSubmit),
          ),
        ],
      ),
    );
  }
}
