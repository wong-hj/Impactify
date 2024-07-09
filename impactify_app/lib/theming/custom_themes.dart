import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF006400);
  static const Color secondary = Color(0xFF66CDAA);
  static const Color tertiary = Color(0xFF98FB98);
  static const Color placeholder = Color.fromARGB(255, 104, 104, 104);
  static const Color background = Color(0xFFF5FFFF);
}

class AppTextStyles {
  static final TextStyle authHead = GoogleFonts.nunito(
      fontSize: 32.0,
      //fontWeight: FontWeight.bold,
      color: Colors.black);

  static final TextStyle displayLarge = GoogleFonts.nunito(
    fontSize: 15.0,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  static const TextStyle bodyText1 = TextStyle(
    fontSize: 16.0,
    color: AppColors.secondary,
  );

  // Add more text styles as needed
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
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent
      ),
    );
  }
}
