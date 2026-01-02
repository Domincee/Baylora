import 'package:baylora_prjct/core/assets/images.dart';
import 'package:baylora_prjct/core/constant/app_values.dart'; // Changed import
import 'package:baylora_prjct/core/constant/app_strings.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/auth/pages/login.dart';
import 'package:baylora_prjct/feature/profile/provider/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PrimaryAppBar extends ConsumerWidget { // Renamed Class
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
        return "Post Item"; // Placeholder until string is added or if it's dynamic
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
          child: Stack( // Changed Row to Stack for centering
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
                        child: ClipOval(
                          child: _buildAvatar(avatarUrl ?? Images.defaultAvatar),
                        ),

                      onSelected: (value) async {
                        if (value == 'my_items') {
                        } else if (value == 'settings') {
                        } else if (value == 'logout') {
                          await Supabase.instance.client.auth.signOut();

                          if (context.mounted) {
                            await EasyLoading.show(status: 'Signing out...');

                            if (context.mounted) {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => const LoginScreen()),
                                  (route) => false);
                            }
                            EasyLoading.dismiss();
                          }
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return [
                          const PopupMenuItem(
                            value: 'my_items',
                            child: Text('My Items'),
                          ),
                          const PopupMenuItem(
                            value: 'settings',
                            child: Text(AppStrings.settings), // Use Constant
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

Widget _buildAvatar(String url) {
  // 1. If it's an SVG (Network or Asset)
  if (url.toLowerCase().endsWith('.svg')) {
    return SvgPicture.network(
      url,
      width: 32,
      height: 32,
      fit: BoxFit.cover,
      // Fix for "unhandled element <filter/>":
      placeholderBuilder: (context) => const Icon(Icons.person),
    );
  }

  // 2. If it's a standard image
  return Image.network(
    url,
    width: 32,
    height: 32,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) {
      return const Icon(Icons.person); // Fallback if image fails
    },
  );
}
