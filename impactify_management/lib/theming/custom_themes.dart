import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF006400);
  static const Color secondary = Color(0xFF66CDAA);
  static const Color tertiary = Color(0xFF98FB98);
  static const Color placeholder = Color.fromARGB(255, 104, 104, 104);
  static const Color background = Color(0xFFF5FFFF);
}


class CustomTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primary,
      hintColor: AppColors.placeholder,
      scaffoldBackgroundColor: AppColors.background,
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shadowColor: AppColors.primary, // Text color of TextButton
        ),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent
      ),
      
      
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      hintColor: AppColors.placeholder,
      scaffoldBackgroundColor: AppColors.background,
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shadowColor: AppColors.primary, // Text color of TextButton
        ),
      ),
      //appBarTheme: AppBarTheme(
      //   elevation: 0,
      //   scrolledUnderElevation: 0,
      //   backgroundColor: Colors.transparent
      // ),
    );
  }
}
