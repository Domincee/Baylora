class OnboardingModel {
  final String title;
  final String description;
  final String image;

  OnboardingModel({
    required this.title,
    required this.description,
    required this.image,
    
  });

  static List<OnboardingModel> getCategories() {
    return [

      OnboardingModel(
      title: 
      "Trade, Bid, and Barter", 
      description: 
      "Anything from gadgets to gear.", 
      image: "assets/images/onboarding/onboarding_1.png"),

      OnboardingModel(
      title: 
      "Win the Bidding War.", 
      description: 
      "Bid smart, act fast, and secure the winning deal before time runs out.", 
      image: "assets/images/onboarding/onboarding_1.png"),

      OnboardingModel(
      title: 
      "Your Items Are Currency", 
      description: 
      "Turn your unused gear into purchasing power. Offer straight swaps or add cash to win the bid.", 
      image: "assets/images/onboarding/onboarding_1.png"),
    ];
  }
}