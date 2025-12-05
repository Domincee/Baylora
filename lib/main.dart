import 'package:baylora_prjct/utils/constant.dart';
import 'package:baylora_prjct/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        textTheme: GoogleFonts.nunitoSansTextTheme(), 
      ),

      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             TextWidget
             (
                  data: "Hello WOrld", 
                  size: AppTextStyles.bodyTextSize, 
                  color: AppTextStyles.textColorSemiDark, 
                  fontFamily: AppTextStyles.fontHeader,
                ),
            textGradiant(),
            ],
          ),
        ),
      ),
    );
  }

}
