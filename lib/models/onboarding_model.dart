class OnboardingModel {
  final String title;
  final String description;
  final String image;
  final String logo;
  OnboardingModel({
    required this.title,
    required this.description,
    required this.image,
    this.logo = "assets/images/logo.svg"
  });

 
  static List<OnboardingModel> getCategories() {
    return [

      OnboardingModel(
      title: 
      "Trade, Bid, and Barter", 
      description: 
      "Anything from gadgets to gear.", 

      image: "assets/images/onboarding_images/onboarding_img_1.svg"),


      OnboardingModel(
      title: 
      "Win the Bidding War.", 
      description: 
      "Bid smart, act fast, and secure the winning deal before time runs out.", 
      image: "assets/images/onboarding_images/onboarding_img_2.png"),

      OnboardingModel(
      title: 
      "Your Items Are Currency", 
      description: 
      "Turn your unused gear into purchasing power. Offer straight swaps or add cash to win the bid.", 
      image: "assets/images/onboarding_images/onboarding_img_3.png"),
    ];
  }
}

