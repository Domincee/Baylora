import 'package:baylora_prjct/config/routes.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
  

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(

            ),
            ElevatedButton(onPressed: () => Navigator.pushNamed(context, AppRoutes.itemDetailScreen), child: Text("Go to Item Details"))
          ],
        )
        
      ),
    );
  }
}