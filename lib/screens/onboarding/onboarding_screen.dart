import 'package:baylora_prjct/assets/images.dart';
import 'package:baylora_prjct/config/routes.dart';
import 'package:baylora_prjct/models/onboarding_model.dart';
import 'package:baylora_prjct/widgets/gradiant_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _pageController.addListener(() {
      setState(() {
        _currentIndex = _pageController.page?.round() ?? 0;
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
            image: AssetImage(
              Images.obBoardingBg1,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // PAGEVIEW
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 20,
                      ),
                      child: Column(
                        children: [
                          // Logo + App Name
                          LogoName(item: item),

                          const SizedBox(height: 16),

                          // Main image
                          MainImg(item: item),

                          const SizedBox(height: 16),

                          Column(
                            children: [
                              Title(item: item),

                              const SizedBox(height: 4),

                              Description(item: item),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(10),
                child: Pagination(data: data, currentIndex: _currentIndex),
              ),
              // BOTTOM BUTTON
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ButtonWidget(
                    currentIndex: _currentIndex,
                    data: data,
                    pageController: _pageController,
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

class LogoName extends StatelessWidget {
  const LogoName({super.key, required this.item});

  final OnboardingModel item;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(item.logo, height: 50),
        const SizedBox(height: 10),
        GradientText(
          "Baylora",
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFFFFF), // Baylora Purple
              Color(0xffA293FF), // Secondary Color
            ],
            begin: Alignment.topLeft,
            end: Alignment.topRight,
          ),

          // 3. Define the font weight or font family here
          style: Theme.of(context).textTheme.titleLarge!,
        ),
      ],
    );
  }
}

class MainImg extends StatelessWidget {
  const MainImg({super.key, required this.item});

  final OnboardingModel item;

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
    );
  }
}


class Title extends StatelessWidget {
  const Title({super.key, required this.item});

  final OnboardingModel item;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: GradientText(
        item.title,
        style: Theme.of(context).textTheme.titleSmall!,

        gradient: const LinearGradient(
          colors: [Color(0xffFFFFFF), Color(0xffA293FF)],
          begin: Alignment.topLeft,
          end: Alignment.topRight,
        ),
      ),
    );
  }
}

class Description extends StatelessWidget {
  const Description(
    {
      super.key, 
      required this.item
    });

  final OnboardingModel item;

  @override
  Widget build(BuildContext context) {
    return
     Center(
      child: 
      GradientText(
        item.description,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium!,

        gradient: const LinearGradient(
          colors: [Color(0xffFFFFFF), Color(0xffA293FF)],
          begin: Alignment.topLeft,
          end: Alignment.topRight,
        ),
      ),
    );
  }
}



class Pagination extends StatelessWidget {
  const Pagination({super.key, required this.data, required this.currentIndex});

  final List<OnboardingModel> data;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        data.length, // numbers of pages fixed 3
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(right: 5),
          height: 8,
          width: currentIndex == index ? 16 : 8, // active size : not active sive
          decoration: BoxDecoration(
            color: currentIndex == index ? Colors.white : Colors.white38,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}

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
      child: Text(currentIndex == data.length - 1 ? "Get Started" : "Next"),
    );
  }
}
