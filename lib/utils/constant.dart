

import 'package:flutter/material.dart';

@immutable
class CustomTextStyles extends ThemeExtension<CustomTextStyles> {
 
  final TextStyle? titleSmallRegular;
  
 
  final TextStyle? bodyExtraSmall; 

  const CustomTextStyles({
    required this.titleSmallRegular,
    this.bodyExtraSmall, // Add to constructor
  });

  @override
  CustomTextStyles copyWith({
    TextStyle? titleSmallRegular,
    TextStyle? bodyExtraSmall, // Add to copyWith parameters
  }) {

    return CustomTextStyles(
      titleSmallRegular: titleSmallRegular ?? this.titleSmallRegular,
      // Add assignment logic
      bodyExtraSmall: bodyExtraSmall ?? this.bodyExtraSmall, 
    );
  }

  @override
  CustomTextStyles lerp(ThemeExtension<CustomTextStyles>? other, double t) {
    if (other is! CustomTextStyles) return this;
    return CustomTextStyles(
      titleSmallRegular: TextStyle.lerp(titleSmallRegular, other.titleSmallRegular, t),

      bodyExtraSmall: TextStyle.lerp(bodyExtraSmall, other.bodyExtraSmall, t), 
    );
  }
}




class AppColors {
  // Your Primary Brand Color
  static const Color primary = Color(0xFF8B5CF6);

  // Standard UI Colors
  static const Color background = Color(0xFFFBFBFB);
  static const Color containerColor = Color(0xFFFFFFFF);
  static const Color boxColor = Color(0xFFEDEDED);
}


class GradientText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Gradient gradient;
 final TextAlign textAlign;
  const GradientText(
      this.text, {
        super.key,
        required this.gradient,
        required this.style,
        this.textAlign = TextAlign.center,
      });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return gradient.createShader(
          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        );
      },
      child: Text(
        text,
       textAlign: textAlign,
        style: style.copyWith(color: Colors.white, ),
      ),
    );
  }
}