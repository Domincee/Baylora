import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/details/item_details_screen.dart';
import 'package:baylora_prjct/feature/home/provider/home_provider.dart';
import 'package:baylora_prjct/feature/profile/provider/profile_provider.dart';
import 'package:baylora_prjct/core/root/main_wrapper.dart';

import '../../home/constant/home_strings.dart'; // Added for key matching

class PostSuccessScreen extends ConsumerWidget {
  final String newItemId;

  const PostSuccessScreen({super.key, required this.newItemId});

  void _refreshAllData(WidgetRef ref) {
    // FIX: Using HomeStrings.categoryAll to match the key used in HomeScreen
    // If these keys don't match exactly, Riverpod won't trigger the UI refresh
    ref.invalidate(homeItemsProvider(HomeStrings.categoryAll));
    ref.invalidate(myListingsProvider);
    ref.invalidate(userProfileProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          _refreshAllData(ref);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                const Icon(
                  Icons.check_circle_outline,
                  size: 100,
                  color: AppColors.royalBlue,
                ),
                const SizedBox(height: 24),
                const Text(
                  "Published Successfully!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Text(
                  "Your listing is now live and visible to other traders.",
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.subTextColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _refreshAllData(ref);

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ItemDetailsScreen(itemId: newItemId),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.royalBlue,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "View Listing",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _refreshAllData(ref);

                      // FIX: Navigate directly to the MainWrapper and clear the stack
                      // This avoids popping back into SplashPage or Onboarding logic
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const MainWrapper()),
                            (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.greyLight,
                      foregroundColor: AppColors.black,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Back to Home",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}