import 'package:baylora_prjct/core/assets/images.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AuthLayout extends StatelessWidget {
  final Widget child;

  const AuthLayout({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Background Image
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Images.onBoardingBg1),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: AppValues.paddingScreen,
                  child: Container(
                    constraints:  BoxConstraints(
                      maxWidth: AppValues.maxContentWidth,
                    ),
                    child: Card(
                      color: AppColors.white.withValues(alpha: 0.95),
                      shape:  RoundedRectangleBorder(
                        borderRadius: AppValues.borderRadiusXL,
                      ),
                      elevation: 8,
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: AppValues.paddingLarge,
                        child: child,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
