import 'package:flutter/material.dart';
import 'constants.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppConstants.primaryColor,
    scaffoldBackgroundColor: AppConstants.backgroundColor,
    appBarTheme: AppBarTheme(
      backgroundColor: AppConstants.primaryColor,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: AppConstants.extraLargeTextSize,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(
        color: AppConstants.textColor,
        fontSize: AppConstants.largeTextSize,
      ),
      bodyMedium: TextStyle(
        color: AppConstants.textColor,
        fontSize: AppConstants.mediumTextSize,
      ),
      bodySmall: TextStyle(
        color: AppConstants.hintColor,
        fontSize: AppConstants.smallTextSize,
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: AppConstants.primaryColor,
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      ),
      filled: true,
      fillColor: Colors.grey[200],
      hintStyle: TextStyle(
        color: AppConstants.hintColor,
        fontSize: AppConstants.mediumTextSize,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: AppConstants.primaryColor,
    scaffoldBackgroundColor: Colors.grey[900],
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[900],
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: AppConstants.extraLargeTextSize,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(
        color: Colors.white,
        fontSize: AppConstants.largeTextSize,
      ),
      bodyMedium: TextStyle(
        color: Colors.white,
        fontSize: AppConstants.mediumTextSize,
      ),
      bodySmall: TextStyle(
        color: Colors.grey[500],
        fontSize: AppConstants.smallTextSize,
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: AppConstants.primaryColor,
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      ),
      filled: true,
      fillColor: Colors.grey[800],
      hintStyle: TextStyle(
        color: Colors.grey[500],
        fontSize: AppConstants.mediumTextSize,
      ),
    ),
  );
}