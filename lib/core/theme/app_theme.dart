import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';

/// Central theme configuration for the entire app.
/// Defines all text styles, colors, and component themes.
class AppTheme {
  static ThemeData themeData = ThemeData(

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
        fontFamily: 'Poppins',
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),

      // Body styles - Main content text
      bodyLarge: TextStyle(
        fontFamily: 'NunitoSans',
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'NunitoSans',
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      bodySmall: TextStyle(
        fontFamily: 'NunitoSans',
        fontSize: 10,
        fontWeight: FontWeight.w400,
      ),

      // Label styles - Buttons, chips, small UI elements
      labelLarge: TextStyle(
        fontFamily: 'NunitoSans',
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      labelMedium: TextStyle(
        fontFamily: 'NunitoSans',
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: TextStyle(
        fontFamily: 'NunitoSans',
        fontSize: 8,
        fontWeight: FontWeight.w400,
      ),
    ),
    //===========Standard Font to Use//


    // ============================================
    // COMPONENT THEMES
    // ============================================
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        elevation: 2,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        textStyle: const TextStyle(
          fontFamily: 'NunitoSans',
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: AppColors.royalBlue,
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