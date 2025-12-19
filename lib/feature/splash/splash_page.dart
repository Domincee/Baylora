import 'package:baylora_prjct/core/assets/images.dart';
import 'package:baylora_prjct/core/config/routes.dart';
import 'package:baylora_prjct/core/constant/app_values_widget.dart';
import 'package:baylora_prjct/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashPage extends StatefulWidget {
  
  const SplashPage({super.key
  });

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  // 1. DEFINE THE FLAG HERE
  bool _isInit = false; 

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 2. MOVE LOGIC HERE (Where context is safe)
    if (!_isInit) {
      _isInit = true; // Ensure we run this only ONCE
      _initApp();
    }
  }
  
Future<void> _initApp() async {
    final minWait = Future.delayed(const Duration(seconds: 2));

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
      debugPrint("❌ Error loading images: $e");
    }

    /* CHECK User Status */
    final session = supabase.auth.currentSession;
    final bool isSessionValid = session != null;
    /* Destroy if screen is closed*/
    if (!mounted) return; 
   
   /* check if already login */
    if (isSessionValid) {
      /* already login */
     _navigateTo(AppRoutes.main);
    } else {
      /* not login */
      _navigateTo(AppRoutes.onboarding);
    }
  }
  
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
        transitionDuration: const Duration(milliseconds: 800), 
      ),
    );
  }
  
@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 76, 76),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(Images.logo, width: 125),
            const SizedBox(height: AppValuesWidget.sizedBoxSize),
            // Changed to WHITE so it is visible on your red background
            const CircularProgressIndicator(color: Colors.white), 
          ],
        ),
      ),
    );
  }
}