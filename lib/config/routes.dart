import 'package:flutter/material.dart';

class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String main = '/main';
  static const String createListing = '/create_listing';

  static Map<String, WidgetBuilder> routes = {
    onboarding: (context) => OnboardingScreen(),
    login: (context) => LoginScreen(),
    main: (context) => MainWrapper(),
    createListing: (context) => CreateListingScreen(),
  };
}
