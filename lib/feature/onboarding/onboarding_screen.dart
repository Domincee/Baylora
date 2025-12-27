import 'package:baylora_prjct/core/assets/images.dart';
import 'package:baylora_prjct/core/constant/app_values_widget.dart';
import 'package:baylora_prjct/core/widgets/logo_name.dart';
import 'package:baylora_prjct/feature/onboarding/models/onboarding_model.dart';
import 'package:baylora_prjct/core/widgets/gradiant_text.dart';
import 'package:baylora_prjct/feature/onboarding/widgets/button_widget.dart';
import 'package:baylora_prjct/feature/onboarding/widgets/img_widget.dart';
import 'package:flutter/material.dart';

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
              Images.onBoardingBg1,
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
                          // LogoName
                          LogoName(image:Images.logoLight, fromColor: Color(0xffFFFFFF),toColor: Color(0xffA293FF),),
                          const SizedBox(height: AppValuesWidget.sizedBoxSize,),

                          // Main image
                          MainImg(item: item),

                          const SizedBox(height: AppValuesWidget.sizedBoxSize,),
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

