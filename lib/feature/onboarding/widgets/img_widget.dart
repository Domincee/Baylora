import 'package:baylora_prjct/feature/onboarding/models/onboarding_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MainImg extends StatelessWidget {
  const MainImg({super.key, required this.item});

  final OnboardingModel item;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: item.image.toLowerCase().endsWith('.svg')
          ? SvgPicture.asset(
              item.image,
              fit: BoxFit.contain,
              width: double.infinity,
            )
          : Image.asset(
              item.image,
              fit: BoxFit.contain,
              width: double.infinity,
            ),
    );
  }
}