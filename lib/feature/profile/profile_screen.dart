import 'dart:io';

import 'package:baylora_prjct/core/assets/images.dart';
import 'package:baylora_prjct/core/constant/app_strings.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/core/widgets/text/section_header.dart';
import 'package:baylora_prjct/feature/home/provider/home_provider.dart';
import 'package:baylora_prjct/feature/profile/constant/profile_strings.dart';
import 'package:baylora_prjct/feature/profile/domain/user_profile.dart';
import 'package:baylora_prjct/feature/profile/provider/profile_provider.dart';
import 'package:baylora_prjct/feature/profile/widgets/edit_profile_dialog.dart';
import 'package:baylora_prjct/feature/profile/widgets/profile_header.dart';
import 'package:baylora_prjct/feature/profile/widgets/sections/profile_bids_section.dart';
import 'package:baylora_prjct/feature/profile/widgets/sections/profile_listings_section.dart';
import 'package:baylora_prjct/feature/profile/widgets/sections/profile_settings_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  void _showEditProfileDialog(BuildContext context, WidgetRef ref, UserProfile profile) {
    showDialog(
      context: context,
      builder: (context) => EditProfileDialog(
        username: profile.username,
        bio: profile.bio ?? '',
        onSave: ({required username, required bio}) async {
          final profileService = ref.read(profileServiceProvider);
          await profileService.updateProfile(username: username, bio: bio);

          ref.invalidate(userProfileProvider);
          // Invalidate home providers to reflect name changes if necessary
          ref.invalidate(homeItemsProvider("All"));
        },
      ),
    );
  }

  void _handleLogout(BuildContext context, WidgetRef ref) {
    // Implement logout logic here
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: profileAsync.when(
        data: (profile) => SingleChildScrollView(
          padding: AppValues.paddingAll,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileHeader(
                avatarUrl: (profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty)
                    ? profile.avatarUrl!
                    : Images.defaultAvatar,
                name: profile.fullName,
                username: profile.username.isNotEmpty ? profile.username : ProfileStrings.defaultUsername,
                bio: profile.bio ?? ProfileStrings.noBio,
                rating: profile.rating,
                totalTrades: profile.totalTrades.toString(),
                isVerified: profile.isVerified,
                onEdit: () => _showEditProfileDialog(context, ref, profile),
              ),
              AppValues.gapL,
              SectionHeader(title: ProfileStrings.listingsTitle, subTitle: ProfileStrings.listingsSubtitle),
              AppValues.gapL,

              const ProfileListingsSection(),

              AppValues.gapL,

              const ProfileBidsSection(),

              AppValues.gapL,

              ProfileSettingsSection(
                onEditProfile: () => _showEditProfileDialog(context, ref, profile),
                onLogout: () => _handleLogout(context, ref),
              ),
              
              AppValues.gapXXL,
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) {
          final isNetworkError = err is SocketException ||
            (err.toString().contains('SocketException')) ||
            (err.toString().contains('Network is unreachable')) ||
            (err.toString().contains('Connection refused'));

          final String message = isNetworkError
            ? AppStrings.noInternetConnection
            : "${AppStrings.error}: $err";
          
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isNetworkError ? Icons.wifi_off : Icons.error_outline,
                  color: AppColors.errorColor,
                  size: 48,
                ),
                AppValues.gapM,
                Text(message, textAlign: TextAlign.center),
                AppValues.gapM,
                ElevatedButton(
                  onPressed: () => ref.refresh(userProfileProvider),
                  child: const Text(AppStrings.retry),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
