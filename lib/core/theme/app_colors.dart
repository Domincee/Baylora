import 'package:flutter/material.dart';


class AppColors {
  // ============================================
  // PRIMARY COLORS
  // ============================================
  
  /// Pure black
  static const Color black = Colors.black;
  
  /// Black with 87% opacity
  static const Color black87 = Colors.black87;
  
  /// Pure white - main background
  static const Color white = Colors.white;

  /// White with 38% opacity
  static const Color white38 = Colors.white38;
  
  /// Primary color (white)
  static const Color primaryColor = Color(0xFFFFFFFF);
  
  /// Background color - light grey
  static const Color bgColor = Color(0xffFBFBFB);
  
  /// Surface color - light pink (for cards, containers)
  static const Color surface = Color.fromARGB(255, 241, 150, 150);

  // ============================================
  // BRAND COLORS
  // ============================================
  // Yellow
  static const Color yellowAcc = Colors.yellowAccent;

  /// Royal blue - primary brand color
  static const Color royalBlue = Color(0xff0049DC);
  
  /// Deep blue - secondary brand color
  static const Color deepBlue = Color(0xff0E0A83);
  
  /// Selected/active color - light blue
  static const Color selectedColor = Color(0xFF09B7FD);

  /// Logo Gradient End Color - Periwinkle
  static const Color logoGradientEnd = Color(0xff8F7EFF);

  /// Onboarding Gradient End - Lavender Accent
  static const Color lavenderAccent = Color(0xffA293FF);

  /// Trade Icon Color - Purple
  static const Color tradeIconColor = Color(0xFF8B5CF6);

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
  static const Color greyLight = Color(0xFFF5F5F5); // ~Grey 100/200

  /// Grey 200
  static const Color grey200 = Color(0xFFEEEEEE);
  
  /// Medium grey for borders/dividers
  static const Color greyMedium = Color(0xFFE0E0E0); // ~Grey 300

  /// Grey 300
  static const Color grey300 = Color(0xFFE0E0E0);

  /// Grey 400
  static const Color grey400 = Color(0xFFBDBDBD);

  /// Grey 600
  static const Color grey600 = Color(0xFF757575);
  
  /// Grey for disabled states
  static const Color greyDisabled = Color(0xFFBDBDBD);

  /// Gradient Grey Start (for Rating Pill)
  static const Color gradientGreyStart = Color(0xFFD7D7D7);

  /// Gradient Grey End (for Rating Pill)
  static const Color gradientGreyEnd = Color(0xFFD0C9C9);

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

  /// Star/Rating Color
  static const Color starColor = Colors.amber;

  /// Winning Bid Color
  static const Color winningBid = Colors.deepPurpleAccent;

  // ============================================
  // STATUS COLORS
  // ============================================
  
  /// Status Accepted Text
  static const Color statusAcceptedText = Color(0xFF1565C0);
  
  /// Status Accepted Background
  static const Color statusAcceptedBg = Colors.blue;
  
  /// Status Sold Text
  static const Color statusSoldText = white;
  
  /// Status Sold Background
  static const Color statusSoldBg = Colors.grey;
  
  /// Status Pending Background
  static const Color statusPendingBg = Color(0x3340C4FF); // Light Blue Accent 0.2

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
