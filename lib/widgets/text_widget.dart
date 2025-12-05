import 'package:baylora_prjct/utils/constant.dart';
import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String data;
  final double? size;
  final TextStyle? fontFamily;
  final Color? color;

  const TextWidget({
    super.key,
    
    this.color,
    this.fontFamily,
    this.size,
    required this.data,
    });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: TextStyle(
        fontSize: size ?? 16,
        color: color ?? AppTextStyles.textColorDefault,
        fontFamily: fontFamily?.fontFamily ?? AppTextStyles.fontBody.fontFamily,
      ),
    );
    
  }
}