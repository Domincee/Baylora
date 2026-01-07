import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BidState {
  final double cashAmount;
  final String tradeTitle;
  final String? tradeCategory;
  final String tradeCondition;
  final List<File> tradeImages;

  const BidState({
    this.cashAmount = 0.0,
    this.tradeTitle = '',
    this.tradeCategory,
    this.tradeCondition = 'Used',
    this.tradeImages = const [],
  });

  BidState copyWith({
    double? cashAmount,
    String? tradeTitle,
    String? tradeCategory,
    String? tradeCondition,
    List<File>? tradeImages,
  }) {
    return BidState(
      cashAmount: cashAmount ?? this.cashAmount,
      tradeTitle: tradeTitle ?? this.tradeTitle,
      tradeCategory: tradeCategory ?? this.tradeCategory,
      tradeCondition: tradeCondition ?? this.tradeCondition,
      tradeImages: tradeImages ?? this.tradeImages,
    );
  }
}

class BidNotifier extends StateNotifier<BidState> {
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
    if (state.tradeImages.length < 3) {
      state = state.copyWith(tradeImages: [...state.tradeImages, photo]);
    }
  }

  void removePhoto(File photo) {
    state = state.copyWith(
      tradeImages: state.tradeImages.where((img) => img != photo).toList(),
    );
  }
  
  void reset() {
    state = const BidState();
  }
}

final bidProvider = StateNotifierProvider.autoDispose<BidNotifier, BidState>((ref) {
  return BidNotifier();
});
