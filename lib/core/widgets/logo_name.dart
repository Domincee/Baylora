import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:baylora_prjct/core/constant/app_strings.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/widgets/gradiant_text.dart';

class LogoName extends StatelessWidget {
  final Color fromColor;
  final Color toColor;
  final String image;

  const LogoName({
    super.key,
    required this.fromColor,
    required this.toColor,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(image, height: 50),
        AppValues.gapXS,
        GradientText(
          AppStrings.appName,
          gradient: LinearGradient(
            colors: [fromColor, toColor],
            begin: Alignment.topLeft,
            end: Alignment.topRight,
          ),
          style: Theme.of(context).textTheme.titleLarge!,
        ),
      ],
    );
  }
}
