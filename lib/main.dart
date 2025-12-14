import 'package:baylora_prjct/config/routes.dart';
import 'package:baylora_prjct/theme/app_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: AppTheme.themeData,
      
      debugShowCheckedModeBanner: false,
      title: 'Bidaro',
     
      initialRoute: AppRoutes.onboarding,
      routes: AppRoutes.routes,
    );
  }

}
