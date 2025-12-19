import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

  TextSpan termsAgrement(BuildContext context) {
    return TextSpan(
      text: "By registering, you agree to our ",
      style: TextStyle(fontSize: 12, color: Colors.grey[800]),
      children: [
        TextSpan(
          text: "Terms & Agreements",
          style: const TextStyle(
            color: AppColors.highLightTextColor, // highlighted color
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline, // optional
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              // Show modal
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Terms & Agreements"),
                    content: const SingleChildScrollView(
                      child: Text("Here are the full terms & agreements..."),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Done"),
                      ),
                    ],
                  );
                },
              );
            },
        ),
      ],
    );
  }

