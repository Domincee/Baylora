import 'package:baylora_prjct/config/routes.dart';
import 'package:baylora_prjct/models/onboarding_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});  

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _pageController.addListener(() {
      setState(() {
        currentIndex = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = OnboardingModel.getCategories();

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(padding: EdgeInsets.all(3), child: SvgPicture.asset(item.image),),
                    Text(item.title),
                    Text(item.description),
                  ],
                );
              },
            ),
          ),

          // BOTTOM BUTTON
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () {
                if (currentIndex == data.length - 1) {
                  // LAST PAGE → GO TO MAIN
                  Navigator.pushReplacementNamed(
                      context, AppRoutes.main);
                } else {
                  // NEXT PAGE
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                }
              },
              child: Text(
                currentIndex == data.length - 1 ? "Get Started" : "Next",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
