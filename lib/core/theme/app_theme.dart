import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';

/// Central theme configuration for the entire app.
/// Defines all text styles, colors, and component themes.
class AppTheme {
  static ThemeData themeData = ThemeData(
    // ============================================
    // COLOR SCHEME
    // ============================================
    scaffoldBackgroundColor: AppColors.bgColor,
    primaryColor: AppColors.royalBlue,
    colorScheme: ColorScheme.light(
      primary: AppColors.royalBlue,
      secondary: AppColors.selectedColor,
      surface: AppColors.surface,
      error: AppColors.errorColor,
      onPrimary: AppColors.primaryColor,
      onSecondary: AppColors.primaryColor,
      onSurface: AppColors.black,
      onError: AppColors.primaryColor,
    ),

    // ============================================
    // TEXT THEME - Complete typography system
    // ============================================
    textTheme: const TextTheme(
      // Display styles - Large decorative text
      displayLarge: TextStyle(
        fontFamily: 'LogoFont',
        fontSize: 50,
        fontWeight: FontWeight.w400,
      ),
      displayMedium: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 40,
        fontWeight: FontWeight.w700,
      ),
      displaySmall: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 32,
        fontWeight: FontWeight.w600,
      ),

      // Headline styles - Section headers
      headlineLarge: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 28,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'NunitoSans',
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'NunitoSans',
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),

      // Title styles - Card headers, list titles
      titleLarge: TextStyle(
        fontFamily: 'LogoFont',
        fontSize: 50,
        fontWeight: FontWeight.w400,
      ),
      titleMedium: TextStyle(
        fontFamily: 'NunitoSans',
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: TextStyle(
        fontFamily: 'NunitoSans',
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),

      // Body styles - Main content text
      bodyLarge: TextStyle(
        fontFamily: 'NunitoSans',
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'NunitoSans',
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      bodySmall: TextStyle(
        fontFamily: 'NunitoSans',
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),

      // Label styles - Buttons, chips, small UI elements
      labelLarge: TextStyle(
        fontFamily: 'NunitoSans',
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
      labelMedium: TextStyle(
        fontFamily: 'NunitoSans',
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: TextStyle(
        fontFamily: 'NunitoSans',
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),

    // ============================================
    // COMPONENT THEMES
    // ============================================
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.royalBlue,
        foregroundColor: AppColors.primaryColor,
        elevation: 2,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontFamily: 'NunitoSans',
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.bgColor,
      elevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: AppColors.black),
      titleTextStyle: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.black,
      ),
    ),

    cardTheme: CardThemeData(
      color: AppColors.primaryColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.bgColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.shadowColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.shadowColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.royalBlue, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.errorColor),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),

    dividerTheme: const DividerThemeData(
      color: AppColors.shadowColor,
      thickness: 1,
      space: 1,
    ),
  );
}