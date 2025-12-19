import 'package:baylora_prjct/core/assets/images.dart';

class OnboardingModel {
  final String title;
  final String description;
  final String image;
  final String logo;
  OnboardingModel({
    required this.title,
    required this.description,
    required this.image,
    this.logo =  Images.logo
  });

 
  static List<OnboardingModel> getCategories() {
    return [

      OnboardingModel(
      title: 
      "Trade, Bid, and Barter", 
      description: 
      "Anything from gadgets to gear.", 

      image: Images.onBoardingImg1),


      OnboardingModel(
      title: 
      "Win the Bidding War.", 
      description: 
      "Bid smart, act fast, and secure the winning deal before time runs out.", 
      image:Images.onBoardingImg2),

      OnboardingModel(
      title: 
      "Your Items Are Currency", 
      description: 
      "Turn your unused gear into purchasing power. Offer straight swaps or add cash to win the bid.", 
      image: Images.onBoardingImg3),
    ];
  }
}

