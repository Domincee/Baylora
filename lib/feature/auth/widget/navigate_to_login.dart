import 'package:baylora_prjct/core/config/routes.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

RichText navigateToLogin(BuildContext context) {
  return RichText(
    text: TextSpan(
      text: "Already Have Account? ",
      style: TextStyle(fontSize: 12, color: Colors.grey[800]),
      children: [
        TextSpan(
          text: "Login",
          style: const TextStyle(
            color: AppColors.royalBlue,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
        ),
      ],
    ),
  );
}
