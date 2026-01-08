import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {

  static TextStyle titleMedium(
      BuildContext context, {
        bool bold = false,
        Color? color,
      }) {
    final base = Theme.of(context).textTheme.titleMedium!;

    return base.copyWith(
      fontWeight: bold ? FontWeight.bold : null,
      color: color ?? AppColors.black,
    );
  }

  static TextStyle titleSmall(
      BuildContext context, {
        bool bold = false,
        Color? color,
      }) {
    final base = Theme.of(context).textTheme.titleSmall!;

    return base.copyWith(
      fontWeight: bold ? FontWeight.bold : null,
      color: color ?? AppColors.black,
    );
  }

  static TextStyle bodyLarge(
      BuildContext context, {
        bool bold = false,
        Color? color,
      }) {
    final base = Theme.of(context).textTheme.bodyLarge!;

    return base.copyWith(
      fontWeight: bold ? FontWeight.bold : null,
      color: color ?? AppColors.black,
    );
  }

  static TextStyle bodyMedium(
      BuildContext context, {
        bool bold = false,
        Color? color,
      }) {
    final base = Theme.of(context).textTheme.bodyMedium!;

    return base.copyWith(
      fontWeight: bold ? FontWeight.bold : null,
      color: color ?? AppColors.black,
    );
  }

  static TextStyle bodySmall(
      BuildContext context, {
        bool bold = false,
        Color? color,
      }) {
    final base = Theme.of(context).textTheme.bodySmall!;

    return base.copyWith(
      fontWeight: bold ? FontWeight.bold : null,
      color: color ?? AppColors.black,
    );
  }

  static TextStyle labelSmall(
      BuildContext context, {
        bool bold = false,
        Color? color,
      }) {
    final base = Theme.of(context).textTheme.labelSmall!;

    return base.copyWith(
      fontWeight: bold ? FontWeight.bold : null,
      color: color ?? AppColors.black,
    );
  }



}