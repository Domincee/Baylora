import 'package:baylora_prjct/feature/home/constant/home_strings.dart';

class ItemModel {
  final String id;
  final String title;
  final String description;
  final num price;
  final String type;
  final String? swapPreference;
  final List<String> images;
  final DateTime createdAt;
  final DateTime? endTime;
  final String status;
  final ItemProfile? profile;

  ItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.type,
    this.swapPreference,
    required this.images,
    required this.createdAt,
    this.endTime,
    required this.status,
    this.profile,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? HomeStrings.noTitle,
      description: json['description'] ?? '',
      price: json['price'] ?? 0,
      type: json['type'] ?? HomeStrings.cash,
      swapPreference: json['swap_preference'],
      images: (json['images'] as List?)?.map((e) => e.toString()).toList() ?? [],
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
      endTime: json['end_time'] != null ? DateTime.tryParse(json['end_time'].toString()) : null,
      status: json['status'] ?? HomeStrings.statusActive,
      profile: json['profiles'] != null ? ItemProfile.fromJson(json['profiles']) : null,
    );
  }
}

class ItemProfile {
  final String username;
  final String? avatarUrl;
  final num rating;
  final int totalTrades;
  final bool isVerified;

  ItemProfile({
    required this.username,
    this.avatarUrl,
    required this.rating,
    required this.totalTrades,
    required this.isVerified,
  });

  factory ItemProfile.fromJson(Map<String, dynamic> json) {
    return ItemProfile(
      username: json['username'] ?? HomeStrings.unknownUser,
      avatarUrl: json['avatar_url'],
      rating: json['rating'] ?? 0.0,
      totalTrades: json['total_trades'] ?? 0,
      isVerified: json['is_verified'] ?? false,
    );
  }
}
