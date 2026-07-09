import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppThemes {
  // ১. এডমিন থিম (আপনার আগের কালারগুলো দিয়ে)
  static ThemeData get adminTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.white,
        error: AppColors.error,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
    );
  }

  // ২. ইউজার থিম (লোগো থেকে নেওয়া নতুন কালারগুলো দিয়ে)
  static ThemeData get userTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.userPrimary, // মেইন সবুজ
        secondary: AppColors.userSecondary, // গাঢ় নীল
        surface: AppColors.white,
        error: AppColors.error,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.userSecondary, // ইউজার অ্যাপবার হবে গাঢ় নীল
        foregroundColor: AppColors.white,
      ),
    );
  }
}
