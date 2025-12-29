import 'package:flutter/material.dart';

class AppValuesWidget {
  // --- Existing Values (Preserved) ---
  static const EdgeInsets logoPadding = EdgeInsets.all(10.0);
  static const double iconDefaultSize = 25.0;
  static const double sizedBoxSize = 20.0;
  static BorderRadius borderRadius = BorderRadius.circular(10);
  static const int animDuration = 300;
  static const EdgeInsets boxSizeCat = EdgeInsets.symmetric(horizontal: 8, vertical: 5);
  static const double searchBarSize = 50.0;
  static const EdgeInsets padding = EdgeInsets.symmetric(horizontal: 20, vertical: 15);
  static const Size avatarSize = Size(14, 14);

  // --- New Standard Values (Added for Refactor) ---

  // Padding & Margins
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 40.0;

  // Border Radius
  static const double radiusM = 16.0;

  // Spacing (Gaps)
  static const Widget gapS = SizedBox(height: 8);
  static const Widget gapM = SizedBox(height: 12);
  static const Widget gapL = SizedBox(height: 24);
  static const Widget gapXL = SizedBox(height: 40);
}
