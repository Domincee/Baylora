import 'package:baylora_prjct/core/assets/images.dart';
import 'package:baylora_prjct/core/config/routes.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  /// Flag to ensure _initApp runs only once
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      _isInit = true;
      _initApp();
    }
  }

  /// Initialize app: preload images, check session, navigate
  Future<void> _initApp() async {
    final minWait = Future.delayed(Duration(milliseconds: AppValues.durationSlow));

    try {
      await Future.wait([
        precacheImage(const AssetImage(Images.onBoardingBg1), context),
        precacheImage(const AssetImage(Images.onBoardingImg1), context),
        precacheImage(const AssetImage(Images.onBoardingImg2), context),
        precacheImage(const AssetImage(Images.onBoardingImg3), context),
        precacheImage(const AssetImage(Images.logo), context),
        minWait,
      ]);
    } catch (e) {
      debugPrint(" Error loading images: $e");
    }

    if (!mounted) return;

    final session = supabase.auth.currentSession;
    final bool isSessionValid = session != null;

    if (isSessionValid) {
      _navigateTo(AppRoutes.main);
    } else {
      _navigateTo(AppRoutes.onboarding);
    }
  }

  /// Navigate to the given route with fade transition
  void _navigateTo(String routeName) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          final widgetBuilder = AppRoutes.routes[routeName];
          return widgetBuilder!(context);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: Duration(milliseconds: AppValues.durationSlow),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.royalBlue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              Images.logoLight,
              width: AppValues.containerSizeImage.width, // standardized logo width
            ),
            AppValues.gapM,
            SizedBox(
              height: AppValues.loadingIndicatorSize,
              width: AppValues.loadingIndicatorSize,
              child: CircularProgressIndicator(
                color: AppColors.white,
                strokeWidth: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
