import 'dart:io';

import 'package:baylora_prjct/core/assets/images.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/constant/app_strings.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/auth/pages/login.dart';
import 'package:baylora_prjct/feature/home/widgets/profile_avatar.dart';
import 'package:baylora_prjct/feature/profile/constant/profile_strings.dart';
import 'package:baylora_prjct/feature/profile/provider/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PrimaryAppBar extends ConsumerWidget {
  const PrimaryAppBar({
    super.key,
    required this.currentIndex,
  });

  final int currentIndex;

  String _getTitle() {
    switch (currentIndex) {
      case 0:
        return AppStrings.home;
      case 1:
        return "Post Item";
      case 2:
        return AppStrings.profile;
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    final avatarUrl = profileAsync.valueOrNull?.avatarUrl;

    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: SafeArea(
        child: Container(
          color: AppColors.white,
          padding: EdgeInsets.symmetric(
            horizontal: AppValues.spacingM,
            vertical: AppValues.spacingXS,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Logo (Left)
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      Images.logo,
                    ),
                  ),
                ),
              ),

              // Title (Center)
              Text(
                _getTitle(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Actions (Right)
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Notification Icon
                    IconButton(
                      icon: const Icon(
                        Icons.notifications_outlined,
                        size: 28,
                        color: AppColors.black,
                      ),
                      onPressed: () {
                        // Handle notifications
                      },
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                    ),
                    
                    AppValues.gapHXS,
                    
                    // Profile Avatar with Menu
                    GestureDetector(
                      onTap: () {
                        // Show menu or navigate
                      },
                      child: PopupMenuButton<String>(
                        offset: const Offset(0, 50),
                        child: ProfileAvatar(
                          imageUrl: avatarUrl ?? "",
                          size: 32,
                        ),
                        onSelected: (value) async {
                          if (value == 'my_items') {
                            // Navigate to My Items
                          } else if (value == 'settings') {
                            // Navigate to Settings
                          } else if (value == 'logout') {
                            // 1. Show Loading first
                            await EasyLoading.show(status: 'Signing out...');
                            
                            try {
                              // 2. Clear Supabase Session
                              await Supabase.instance.client.auth.signOut();
                            } catch (e) {
                              if (!context.mounted) return;
                              
                              final isNetworkError = e is SocketException ||
                                (e.toString().contains('SocketException')) ||
                                (e.toString().contains('Network is unreachable')) ||
                                (e.toString().contains('Connection refused'));

                              if (isNetworkError) {
                                 await EasyLoading.dismiss();
                                 if (context.mounted) {
                                   ScaffoldMessenger.of(context).showSnackBar(
                                     const SnackBar(content: Text(AppStrings.noInternetConnection)),
                                   );
                                 }
                                 return;
                              }
                            }
                            

                            if (context.mounted) {
                              await EasyLoading.dismiss();
                              
                              if (context.mounted) {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => const LoginScreen()),
                                    (route) => false);
                              }
                            }
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          return [
                            const PopupMenuItem(
                              value: 'my_items',
                              child: Text(ProfileStrings.myItems),
                            ),
                            const PopupMenuItem(
                              value: 'settings',
                              child: Text(ProfileStrings.settings),
                            ),
                            PopupMenuItem(
                              value: 'logout',
                              child: Text(
                                AppStrings.logout,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.errorColor,
                                ),
                              ),
                            ),
                          ];
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
