import 'package:baylora_prjct/config/routes.dart';
import 'package:baylora_prjct/models/onboarding_model.dart';
import 'package:baylora_prjct/utils/constant.dart';
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
                              const SizedBox(height: 10),

                              GradientText(
                                "Baylora",
                                style: Theme.of(context).textTheme.titleLarge!,
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xffFFFFFF),
                                    Color(0xffA293FF),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.topRight,
                                ),
                              )
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

                              Align(
                                alignment: Alignment.center,
                                child: GradientText(
                                  item.title,
                                  style:
                                  Theme.of(context).textTheme.titleMedium!,

                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xffFFFFFF),
                                      Color(0xffA293FF),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.topRight,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 4),

                              Center(
                                child: GradientText(
                                  item.description,
                                  style:
                                  Theme.of(context).textTheme.titleMedium!,

                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xffFFFFFF),
                                      Color(0xffA293FF),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.topRight,
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),


   Padding(padding: EdgeInsets.all(10),
     child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    data.length, // FIXED
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(right: 5),
                      height: 8,
                      width: currentIndex == index ? 16 : 8, // FIXED
                      decoration: BoxDecoration(
                        color: currentIndex == index ? Colors.white : Colors.white38,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
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
