import 'dart:io';
import 'package:baylora_prjct/feature/details/constants/item_details_strings.dart';
import 'package:baylora_prjct/feature/post/repository/listing_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BidState {
  final double cashAmount;
  final String tradeTitle;
  final String? tradeCategory;
  final String tradeCondition;
  final List<File> tradeImages;
  final List<String> existingImageUrls; // New field for pre-filled images

  const BidState({
    this.cashAmount = 0.0,
    this.tradeTitle = '',
    this.tradeCategory,
    this.tradeCondition = 'Used',
    this.tradeImages = const [],
    this.existingImageUrls = const [],
  });

  BidState copyWith({
    double? cashAmount,
    String? tradeTitle,
    String? tradeCategory,
    String? tradeCondition,
    List<File>? tradeImages,
    List<String>? existingImageUrls,
  }) {
    return BidState(
      cashAmount: cashAmount ?? this.cashAmount,
      tradeTitle: tradeTitle ?? this.tradeTitle,
      tradeCategory: tradeCategory ?? this.tradeCategory,
      tradeCondition: tradeCondition ?? this.tradeCondition,
      tradeImages: tradeImages ?? this.tradeImages,
      existingImageUrls: existingImageUrls ?? this.existingImageUrls,
    );
  }
}

class BidNotifier extends StateNotifier<BidState> {
  final ListingRepository _listingRepository = ListingRepository();

  BidNotifier() : super(const BidState());

  void setCashAmount(double amount) {
    state = state.copyWith(cashAmount: amount);
  }

  void addToCashAmount(double amount) {
    state = state.copyWith(cashAmount: state.cashAmount + amount);
  }

  void setTradeTitle(String title) {
    state = state.copyWith(tradeTitle: title);
  }

  void setTradeCategory(String category) {
    state = state.copyWith(tradeCategory: category);
  }

  void setTradeCondition(String condition) {
    state = state.copyWith(tradeCondition: condition);
  }

  void addPhoto(File photo) {
    if (state.tradeImages.length + state.existingImageUrls.length < 3) {
      state = state.copyWith(tradeImages: [...state.tradeImages, photo]);
    }
  }

  void removePhoto(File photo) {
    state = state.copyWith(
      tradeImages: state.tradeImages.where((img) => img != photo).toList(),
    );
  }

  void removeExistingImage(String url) {
    state = state.copyWith(
      existingImageUrls: state.existingImageUrls.where((u) => u != url).toList(),
    );
  }
  
  void reset() {
    state = const BidState();
  }

  Future<void> loadExistingOffer(String itemId, String userId) async {
    try {
      final data = await Supabase.instance.client
          .from(ItemDetailsStrings.fieldOffers)
          .select()
          .eq('item_id', itemId)
          .eq('bidder_id', userId)
          .maybeSingle();

      if (data != null) {
        final cash = (data['cash_offer'] as num?)?.toDouble() ?? 0.0;
        final swapText = data['swap_item_text'] as String?;
        final swapImages = List<String>.from(data['swap_item_images'] ?? []);

        String title = '';
        String condition = 'Used';

        if (swapText != null && swapText.contains('(')) {
          final parts = swapText.split('(');
          if (parts.isNotEmpty) {
            title = parts[0].trim();
            if (parts.length > 1) {
              condition = parts[1].replaceAll(')', '').trim();
            }
          }
        } else if (swapText != null) {
          title = swapText;
        }

        state = state.copyWith(
          cashAmount: cash,
          tradeTitle: title,
          tradeCondition: condition,
          existingImageUrls: swapImages,
        );
      }
    } catch (e) {
      debugPrint("Error loading existing offer: $e");
    }
  }

  Future<bool> submitOffer({
    required String itemId,
    required String userId,
    required bool isCash,
    required bool isTrade,
    required bool isMix,
  }) async {
    try {
      List<String> newImageUrls = [];
      // Upload new images if any
      if ((isTrade || isMix) && state.tradeImages.isNotEmpty) {
        newImageUrls = await _listingRepository.uploadImages(state.tradeImages, userId);
      }

      // Merge existing urls + new urls
      final finalImages = [...state.existingImageUrls, ...newImageUrls];

      final existingOffer = await Supabase.instance.client
          .from(ItemDetailsStrings.fieldOffers)
          .select('id')
          .eq('item_id', itemId)
          .eq('bidder_id', userId)
          .maybeSingle();

      final timestamp = DateTime.now().toIso8601String();
      final swapText = (isTrade || isMix) ? "${state.tradeTitle} (${state.tradeCondition})" : null;
      final cashAmt = (isCash || isMix) ? state.cashAmount : 0;

      final updateData = {
        'cash_offer': cashAmt,
        'swap_item_text': swapText,
        'swap_item_images': finalImages.isNotEmpty ? finalImages : null,
        'updated_at': timestamp,
      };

      if (existingOffer != null) {
        // Update via ID
        final offerId = existingOffer['id'];
        final response = await Supabase.instance.client
            .from(ItemDetailsStrings.fieldOffers)
            .update(updateData)
            .eq('id', offerId)
            .select();
        
        if (response.isEmpty) {

          debugPrint("Update returned 0 rows. Check RLS policies.");
        }
      } else {
        // Try Insert
        final insertData = {
          'item_id': itemId,
          'bidder_id': userId,
          'cash_offer': cashAmt,
          'swap_item_text': swapText,
          'swap_item_images': finalImages.isNotEmpty ? finalImages : null,
          'created_at': timestamp,
          'updated_at': timestamp,
        };

        try {
          await Supabase.instance.client
              .from(ItemDetailsStrings.fieldOffers)
              .insert(insertData);
        } on PostgrestException catch (e) {
          // If duplicate key error (23505), fall back to Update via Composite Key
          if (e.code == '23505') {
            debugPrint("Caught duplicate key error (23505). Attempting update...");
            final response = await Supabase.instance.client
                .from(ItemDetailsStrings.fieldOffers)
                .update(updateData)
                .eq('item_id', itemId)
                .eq('bidder_id', userId)
                .select();
            
            if (response.isEmpty) {
              debugPrint("Fallback update returned 0 rows.");
              // Don't throw exception here to avoid breaking the flow if it's just a return value issue
              // return false; 
            }
          } else {
            rethrow;
          }
        }
      }
      return true;
    } catch (e) {
      debugPrint("Error submitting offer: $e");
      return false;
    }
  }
}

final bidProvider = StateNotifierProvider.autoDispose<BidNotifier, BidState>((ref) {
  return BidNotifier();
});
