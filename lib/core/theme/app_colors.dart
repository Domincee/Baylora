import 'package:flutter/material.dart';

/// Centralized color palette for the entire application.
/// All colors should be referenced from here to maintain consistency.
class AppColors {
  // ============================================
  // PRIMARY COLORS
  // ============================================
  
  /// Pure black
  static const Color black = Colors.black;
  
  /// Pure white - main background
  static const Color white = Colors.white;
  
  /// Primary color (white)
  static const Color primaryColor = Color(0xFFFFFFFF);
  
  /// Background color - light grey
  static const Color bgColor = Color(0xffFBFBFB);
  
  /// Surface color - light pink (for cards, containers)
  static const Color surface = Color.fromARGB(255, 241, 150, 150);

  // ============================================
  // BRAND COLORS
  // ============================================
  
  /// Royal blue - primary brand color
  static const Color royalBlue = Color(0xff0049DC);
  
  /// Deep blue - secondary brand color
  static const Color deepBlue = Color(0xff0E0A83);
  
  /// Selected/active color - light blue
  static const Color selectedColor = Color(0xFF09B7FD);

  // ============================================
  // TEXT COLORS
  // ============================================
  
  /// Highlight text color - light blue
  static const Color highLightTextColor = Color(0xFF09B7FD);
  
  /// Subtitle/secondary text color - grey
  static const Color subTextColor = Color(0xFF7C7C7C);
  
  /// Label grey text
  static const Color textGrey = Color(0xFF9E9E9E);
  
  /// Dark grey text
  static const Color textDarkGrey = Color(0xFF757575);

  // ============================================
  // GREY SHADES
  // ============================================
  
  /// Light grey for backgrounds
  static const Color greyLight = Color(0xFFF5F5F5);
  
  /// Medium grey for borders/dividers
  static const Color greyMedium = Color(0xFFE0E0E0);
  
  /// Grey for disabled states
  static const Color greyDisabled = Color(0xFFBDBDBD);

  // ============================================
  // SEMANTIC COLORS
  // ============================================
  
  /// Success color - green
  static const Color successColor = Color(0xFF4CAF50);
  
  /// Error color - red
  static const Color errorColor = Color(0xFFF44336);
  
  /// Warning color - orange
  static const Color warningColor = Color(0xFFFF9800);
  
  /// Info color - blue
  static const Color infoColor = Color(0xFF2196F3);
  
  /// Recommended/featured color - green
  static const Color recommendedColor = Color(0xFF4CAF50);

  // ============================================
  // ACCENT COLORS
  // ============================================
  
  /// Secondary background color
  static const Color secondaryColor = Color(0xFFF4F4F4);
  
  /// Shadow color for elevation
  static const Color shadowColor = Color(0xFFF3E3E3);
  
  /// Lavender blue for info cards
  static const Color lavenderBlue = Color(0xFFEBEBFF);
  
  /// Info card background - light green
  static const Color infoCardBg = Color(0xFFC9FFE0);
  
  /// Info card text color - dark grey
  static const Color infoCardTClr = Color(0xFF6C6C6C);

  // ============================================
  // TEAL/CYAN SHADES
  // ============================================
  
  /// Teal background for tags
  static const Color tealLight = Color(0xFFB2DFDB);
  
  /// Teal text for tags
  static const Color tealText = Color(0xFF00796B);

  // ============================================
  // BLUE SHADES
  // ============================================
  
  /// Light blue background
  static const Color blueLight = Color(0xFFE3F2FD);
  
  /// Blue text
  static const Color blueText = Color(0xFF1976D2);
  
  /// Dark blue text
  static const Color blueDark = Color(0xFF0D47A1);

  // ============================================
  // FUNCTIONAL COLORS
  // ============================================
  
  /// Transparent overlay
  static const Color overlay = Color(0x80000000);
  
  /// Card white background
  static const Color cardWhite = Colors.white;
  
  /// Divider color
  static const Color divider = Color(0xFFE0E0E0);
  
  // ============================================
  // LEGACY COLORS (for backwards compatibility)
  // ============================================
  
  /// Legacy success color
  static const Color sucessColor = successColor;
  
  /// Legacy text label grey
  static const Color textLblG = textGrey;
}