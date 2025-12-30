import 'package:baylora_prjct/core/config/routes.dart';
import 'package:baylora_prjct/core/constant/app_strings.dart';
import 'package:baylora_prjct/feature/onboarding/models/onboarding_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    super.key,
    required this.currentIndex,
    required this.data,
    required PageController pageController,
  }) : _pageController = pageController;

    final int currentIndex;
    final List<OnboardingModel> data;
    final PageController _pageController;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(20)),
                onPressed: () async {
                  if (currentIndex == data.length - 1) {
                    // LAST PAGE → GO TO MAIN
                    await EasyLoading.show(status: 'Loading...');

                    await Future.delayed(const Duration(milliseconds: 500));

                    await   EasyLoading.dismiss();

                    if (context.mounted) {
                      Navigator.pushReplacementNamed(context, AppRoutes.login);
                    }
                    
                  } else {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  }
                },
                    
      child: Text(currentIndex == data.length - 1 ? AppStrings.getStartedBtn : AppStrings.nextBtn),
    );
  }
}