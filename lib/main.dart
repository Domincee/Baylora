import 'package:baylora_prjct/config/routes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: const TextTheme(
          //LOGO TEXT
          titleLarge: TextStyle(
            fontFamily: 'MontserratAlternates',
            fontWeight: FontWeight.bold,
            fontSize: 40,
          ),

          titleSmall: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize:30,
          ),

          //DEFAULT BODY SIZE
          bodyMedium: TextStyle(
            fontFamily: 'NunitoSans',
            fontWeight: FontWeight.w500,
            fontSize:16,
          ),


        ),
      ),
      initialRoute: AppRoutes.onboarding,
      routes: AppRoutes.routes,
    );
  }

}
