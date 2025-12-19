import 'package:baylora_prjct/feature/auth/pages/login.dart';
import 'package:baylora_prjct/feature/auth/pages/register.dart';
import 'package:baylora_prjct/feature/details/item_details_screen.dart';
import 'package:baylora_prjct/feature/onboarding/onboarding_screen.dart';
import 'package:baylora_prjct/feature/post/create_listing_screen.dart';
import 'package:baylora_prjct/core/root/main_wrapper.dart';
import 'package:baylora_prjct/feature/splash/splash_page.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String register = '/register';
  static const String login = '/login';

  static const String main = '/main';
  static const String itemDetailScreen = '/item_details';
  static const String createListing = '/create_listing';

  static Map<String, WidgetBuilder> routes = {
    onboarding: (context) => OnboardingScreen(),
    register: (context) => RegisterScreen(),
    login: (context) => LoginScreen(),
    main: (context) => MainWrapper(),
    splash: (context) => SplashPage(),
    createListing: (context) => CreateListingScreen(),
    itemDetailScreen: (context) => ItemDetailsScreen(),
  };
}
