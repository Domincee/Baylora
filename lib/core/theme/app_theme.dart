import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData themeData = ThemeData(
        textTheme: const TextTheme(
          //LOGO TEXT  1
          titleLarge: TextStyle(
            fontFamily: 'MontserratAlternates',
            fontWeight: FontWeight.bold,
            fontSize: 40,
          ),

          /* header 2 */
          titleSmall: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize:22,
          ),

          //DEFAULT BODY SIZE
          bodyMedium: TextStyle(
            fontFamily: 'NunitoSans',
            fontWeight: FontWeight.w600,
            fontSize:16,
            
          ),
         bodySmall: TextStyle(
          fontFamily: 'NunitoSans',
          fontWeight: FontWeight.w400,
          fontSize:14,
         ),
        
        ),
      );
}
