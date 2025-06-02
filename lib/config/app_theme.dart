import 'package:app_a_o_c/contants/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  /*
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(brightness: Brightness.light, seedColor: Colors.green),
    //scaffoldBackgroundColor: Colors.grey[100],
  /*  textTheme: TextTheme(
      bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: const Color.fromARGB(255, 245, 2, 2)),
      bodyMedium:
          TextStyle(fontSize: 16, color: const Color.fromARGB(221, 27, 3, 245)),
      bodySmall: TextStyle(
          fontSize: 14, color: const Color.fromRGBO(4, 236, 74, 0.541)),
    ),*/
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.elevatedButtonBackgroundColor,
        foregroundColor: Colors.white,
        elevation: 6,
        shadowColor: const Color.fromARGB(221, 75, 67, 67),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        ),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.appBarBackgroundColor,
    ),
  );

*/

  static final  lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.appSeedColor,
    brightness: Brightness.light,
  ),
  appBarTheme: AppBarTheme(
      backgroundColor: const Color.fromARGB(255, 184, 233, 187),)
);

static final darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.appSeedColor,
    brightness: Brightness.dark,
  ),
  appBarTheme: AppBarTheme(
      backgroundColor: const Color.fromARGB(255, 31, 73, 33),)
);
}
