
import 'package:flutter/material.dart';


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