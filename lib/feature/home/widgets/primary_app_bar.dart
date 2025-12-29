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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);

    // UPDATED: Use Model property
    final avatarUrl = profileAsync.valueOrNull?.avatarUrl;

    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 2,
              spreadRadius: -2,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Container(
          color: AppColors.primaryColor,
          padding: const EdgeInsets.all(5),
          child: AppBar(
            title: Text(
              currentIndex == 0
                  ? AppStrings.home
                  : currentIndex == 1
                      ? AppStrings.home
                      : AppStrings.profile,
              style: Theme.of(context).textTheme.titleSmall!,
            ),
            centerTitle: true,
            backgroundColor: AppColors.primaryColor,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: Padding(
              padding: AppValuesWidget.logoPadding,
              child: SvgPicture.asset(Images.logo),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined,
                    size: AppValuesWidget.iconDefaultSize,
                    color: Color.fromARGB(255, 0, 0, 0)),
                onPressed: () {},
              ),
              // Inside PrimaryAppBar build method...

              PopupMenuButton<String>(
                offset: const Offset(0, 60),
                icon: ClipOval(
                  child: _buildAvatar(avatarUrl ?? Images.defaultAvatar), // Use helper method
                ),
                // ... rest of code

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
                    const PopupMenuItem(
                      value: 'logout',
                      child: Text(AppStrings.logout, style: TextStyle(color: Colors.red)), // Use Constant
                    ),
                  ];
                },
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

