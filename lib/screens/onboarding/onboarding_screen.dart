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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/onboarding_images/onboarding_bg1.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // PAGEVIEW
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      child: Column(
                        children: [
                          // Logo + App Name
                          Column(
                            children: [
                              SvgPicture.asset(item.logo, height: 50),
                              const SizedBox(height: 8),
                              Text(
                                "Baylora",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Main image
                          Expanded(
                            child: item.image.toLowerCase().endsWith('.svg')
                                ? SvgPicture.asset(
                                    item.image,
                                    fit: BoxFit.contain,
                                    width: double.infinity,
                                  )
                                : Image.asset(
                                    item.image,
                                    fit: BoxFit.contain,
                                    width: double.infinity,
                                  ),
                          ),

                          const SizedBox(height: 16),

                          Column(
                            children: [
                              Text(
                                item.title,
                                style: Theme.of(context).textTheme.titleMedium,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.description,
                                style: Theme.of(context).textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // BOTTOM BUTTON
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (currentIndex == data.length - 1) {
                        // LAST PAGE → GO TO MAIN
                        Navigator.pushReplacementNamed(context, AppRoutes.main);
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
