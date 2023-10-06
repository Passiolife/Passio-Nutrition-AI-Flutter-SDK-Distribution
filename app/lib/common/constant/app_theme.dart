import 'package:flutter/material.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/app_colors.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/styles.dart';

class AppTheme {
  ThemeData get lightTheme {
    final themeData = ThemeData.light(useMaterial3: true);
    return themeData.copyWith(
      appBarTheme: AppBarTheme(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(
          color: AppColors.whiteColor,
        ),
        titleTextStyle: AppStyles.style18.copyWith(color: AppColors.whiteColor),
      ),
      // Text field cursor color
      textSelectionTheme: themeData.textSelectionTheme.copyWith(
        cursorColor: AppColors.customBase,
      ),

      /// Default Card Theme
      cardTheme: const CardTheme(
        color: AppColors.passioInset,
        surfaceTintColor: AppColors.passioInset,
      ),

      scaffoldBackgroundColor: AppColors.passioBackgroundWhite,
    );
  }

  ThemeData get darkTheme {
    return ThemeData.dark(useMaterial3: true);
  }
}
