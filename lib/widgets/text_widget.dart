import 'package:baylora_prjct/utils/constant.dart';
import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String data;
  final double? size;
  final Color? color;
  final FontWeight? weight;
  final  TextStyle? fontFam;

  const TextWidget(
    this.data, {
    super.key,
    this.size,
    this.color,
    this.weight,
    this.fontFam,
  
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
