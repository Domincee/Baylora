import 'package:baylora_prjct/config/routes.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           crossAxisAlignment: CrossAxisAlignment.center,
           children: [
            Text("Onboarding Screen"),
            ElevatedButton(onPressed: () => Navigator.pushNamed(context, AppRoutes.login), child: Text("Next"))
           
           ],
         ),
        
      ),
    );
  }
}


