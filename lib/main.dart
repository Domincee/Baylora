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
          titleLarge: TextStyle(
            fontFamily: 'MontserratAlternates',
            fontWeight: FontWeight.bold,
            fontSize: 24,
          )

        ), 
      ),
      initialRoute: AppRoutes.onboarding,
      routes: AppRoutes.routes,
    );
  }

}
