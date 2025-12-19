import 'package:baylora_prjct/core/constant/app_strings.dart';
import 'package:baylora_prjct/core/widgets/gradiant_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LogoName extends StatelessWidget {
  const LogoName({
  super.key, 

 required this.toColor,
  required this.fromColor,

 required this.image
  
  });
 final Color fromColor;
 final Color toColor;
 final String image;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(image, height: 50),
        const SizedBox(height: 10),
        GradientText(
          AppStrings.appName,
          gradient: LinearGradient(
            colors: [
              fromColor,
              toColor
               // Secondary Color
            ],
            begin: Alignment.topLeft,
            end: Alignment.topRight,
          ),

          // 3. Define the font weight or font family here
          style: Theme.of(context).textTheme.titleLarge!,
        ),
      ],
    );
  }
}
