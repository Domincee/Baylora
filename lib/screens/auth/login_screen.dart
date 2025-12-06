import 'package:baylora_prjct/config/routes.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
 return Scaffold(
      body: Center(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           crossAxisAlignment: CrossAxisAlignment.center,
           children: [
            Text("Login Screen"),
            ElevatedButton(onPressed: () => Navigator.pushNamed(context, AppRoutes.main), child: Text("Login"))
           
           ],
         ),
        
      ),
    );
  }
}