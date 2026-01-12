import 'package:flutter/material.dart';
import '../../utils/constants/colors.dart';

abstract class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: PrimaryColors.kDefault,
      scaffoldBackgroundColor: BackgroundColor.kDefault,
      cardColor: BackgroundColor.kCard,
      brightness: Brightness.light,
      appBarTheme: _lightAppBarTheme,
      floatingActionButtonTheme: _lightFloatingActionButtonTheme,
      buttonTheme: _lightButtonTheme,
      inputDecorationTheme: _lightInputDecorationTheme,
      textTheme: _lightTextTheme,
      colorScheme: _lightColorScheme,
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: BackgroundColor.kDefault,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: PrimaryColors.k600,
      scaffoldBackgroundColor: BlackAndWhiteColors.kGrey900,
      cardColor: BlackAndWhiteColors.kGrey800,
      brightness: Brightness.dark,
      appBarTheme: _darkAppBarTheme,
      floatingActionButtonTheme: _darkFloatingActionButtonTheme,
      buttonTheme: _darkButtonTheme,
      inputDecorationTheme: _darkInputDecorationTheme,
      textTheme: _darkTextTheme,
      colorScheme: _darkColorScheme,
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.transparent,
      ),
    );
  }

  static String fontFamily = "sfPro";

  // Light Theme Components
  static AppBarTheme get _lightAppBarTheme => AppBarTheme(
    backgroundColor: PrimaryColors.kDefault,
    titleTextStyle: TextStyle(
      color: TextColor.kTitle,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: BlackAndWhiteColors.kWhite),
  );

  static FloatingActionButtonThemeData get _lightFloatingActionButtonTheme =>
      FloatingActionButtonThemeData(backgroundColor: PrimaryColors.kDefault);

  static ButtonThemeData get _lightButtonTheme => ButtonThemeData(
    buttonColor: PrimaryColors.kDefault,
    textTheme: ButtonTextTheme.primary,
  );

  static InputDecorationTheme get _lightInputDecorationTheme =>
      InputDecorationTheme(
        filled: true,
        contentPadding: EdgeInsets.all(0),
        hintStyle: _lightTextTheme.titleSmall,
        fillColor: BackgroundColor.kGrey,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: BlackAndWhiteColors.kGrey300),
          borderRadius: BorderRadius.circular(50),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: BlackAndWhiteColors.kGrey300),
          borderRadius: BorderRadius.circular(50),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: PrimaryColors.kDefault),
          borderRadius: BorderRadius.circular(50),
        ),
      );

  static TextTheme get _lightTextTheme => TextTheme(
    displayLarge: TextStyle(
      color: TextColor.kTitle,
      fontSize: 32,
      fontWeight: FontWeight.bold,
      fontFamily: fontFamily,
    ),
    displayMedium: TextStyle(
      color: TextColor.kTitle,
      fontSize: 24,
      fontWeight: FontWeight.bold,
      fontFamily: fontFamily,
    ),
    displaySmall: TextStyle(
      color: TextColor.kTitle,
      fontSize: 20,
      fontFamily: fontFamily,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: TextStyle(
      color: TextColor.kSubTitle,
      fontFamily: fontFamily,
      fontSize: 18,
    ),
    titleSmall: TextStyle(
      color: TextColor.kSubTitle,
      fontFamily: fontFamily,
      fontSize: 16,
    ),
    bodyLarge: TextStyle(
      color: TextColor.kBody,
      fontFamily: fontFamily,
      fontSize: 16,
    ),
    bodyMedium: TextStyle(
      color: TextColor.kBody,
      fontFamily: fontFamily,
      fontSize: 14,
    ),
    bodySmall: TextStyle(
      color: TextColor.kSubTitle,
      fontFamily: fontFamily,
      fontSize: 12,
    ),
  );

  static ColorScheme get _lightColorScheme => ColorScheme(
    primary: PrimaryColors.kDefault,
    secondary: SecondaryColors.kDefault,
    surface: BackgroundColor.kCard,
    error: ExtraShades.kRed,
    onPrimary: BlackAndWhiteColors.kWhite,
    onSecondary: BlackAndWhiteColors.kWhite,
    onSurface: TextColor.kBody,
    onError: BlackAndWhiteColors.kWhite,
    brightness: Brightness.light,
  );

  // Dark Theme Components
  static AppBarTheme get _darkAppBarTheme => AppBarTheme(
    backgroundColor: PrimaryColors.k600,
    titleTextStyle: TextStyle(
      color: BlackAndWhiteColors.kWhite,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: BlackAndWhiteColors.kWhite),
  );

  static FloatingActionButtonThemeData get _darkFloatingActionButtonTheme =>
      FloatingActionButtonThemeData(backgroundColor: PrimaryColors.k600);

  static ButtonThemeData get _darkButtonTheme => ButtonThemeData(
    buttonColor: PrimaryColors.k600,
    textTheme: ButtonTextTheme.primary,
  );

  static InputDecorationTheme get _darkInputDecorationTheme =>
      InputDecorationTheme(
        filled: true,
        fillColor: BlackAndWhiteColors.kGrey800,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: BlackAndWhiteColors.kGrey600),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: BlackAndWhiteColors.kGrey600),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: PrimaryColors.k600),
          borderRadius: BorderRadius.circular(8),
        ),
      );

  static TextTheme get _darkTextTheme => TextTheme(
    displayLarge: TextStyle(
      color: BlackAndWhiteColors.kWhite,
      fontSize: 32,
      fontFamily: fontFamily,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: TextStyle(
      color: BlackAndWhiteColors.kWhite,
      fontSize: 24,
      fontFamily: fontFamily,
      fontWeight: FontWeight.bold,
    ),
    displaySmall: TextStyle(
      color: BlackAndWhiteColors.kWhite,
      fontSize: 20,
      fontFamily: fontFamily,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: TextStyle(
      color: BlackAndWhiteColors.kGrey500,
      fontFamily: fontFamily,
      fontSize: 18,
    ),
    titleSmall: TextStyle(
      color: BlackAndWhiteColors.kGrey500,
      fontFamily: fontFamily,
      fontSize: 16,
    ),
    bodyLarge: TextStyle(
      color: BlackAndWhiteColors.kGrey400,
      fontFamily: fontFamily,
      fontSize: 16,
    ),
    bodyMedium: TextStyle(
      color: BlackAndWhiteColors.kGrey400,
      fontFamily: fontFamily,
      fontSize: 14,
    ),
    bodySmall: TextStyle(
      color: BlackAndWhiteColors.kGrey500,
      fontFamily: fontFamily,
      fontSize: 12,
    ),
  );

  static ColorScheme get _darkColorScheme => ColorScheme(
    primary: PrimaryColors.k600,
    secondary: SecondaryColors.k600,
    surface: BlackAndWhiteColors.kGrey800,
    error: ExtraShades.kRed,
    onPrimary: BlackAndWhiteColors.kWhite,
    onSecondary: BlackAndWhiteColors.kWhite,
    onSurface: BlackAndWhiteColors.kGrey400,
    onError: BlackAndWhiteColors.kWhite,
    brightness: Brightness.dark,
  );
}
