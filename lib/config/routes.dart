import 'package:baylora_prjct/screens/auth/login_screen.dart';
import 'package:baylora_prjct/screens/details/item_details_screen.dart';
import 'package:baylora_prjct/screens/onboarding/onboarding_screen.dart';
import 'package:baylora_prjct/screens/post/create_listing_screen.dart';
import 'package:baylora_prjct/screens/root/main_wrapper.dart';
import 'package:baylora_prjct/screens/splash_page.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String main = '/main';
  static const String itemDetailScreen = '/item_details';
  static const String createListing = '/create_listing';

  static Map<String, WidgetBuilder> routes = {
    onboarding: (context) => OnboardingScreen(),
    login: (context) => LoginScreen(),
    main: (context) => MainWrapper(),
    splash: (context) => SplashPage(),
    createListing: (context) => CreateListingScreen(),
    itemDetailScreen: (context) => ItemDetailsScreen(),
  };
}
