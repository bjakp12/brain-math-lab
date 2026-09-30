import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Skala tipe DESIGN.md (cadangan — tema aktif dipakai dari AppTheme).
class AppTypography {
  static TextTheme get textTheme => TextTheme(
        displayLarge: GoogleFonts.plusJakartaSans(
          fontSize: 57, fontWeight: FontWeight.w700, height: 64 / 57,
          letterSpacing: -0.25, color: AppColors.onSurface,
        ),
        displayMedium: GoogleFonts.plusJakartaSans(
          fontSize: 45, fontWeight: FontWeight.w600, height: 52 / 45,
          color: AppColors.onSurface,
        ),
        displaySmall: GoogleFonts.plusJakartaSans(
          fontSize: 36, fontWeight: FontWeight.w600, height: 44 / 36,
          color: AppColors.onSurface,
        ),
        headlineLarge: GoogleFonts.plusJakartaSans(
          fontSize: 32, fontWeight: FontWeight.w600, height: 40 / 32,
          color: AppColors.onSurface,
        ),
        headlineMedium: GoogleFonts.plusJakartaSans(
          fontSize: 28, fontWeight: FontWeight.w600, height: 36 / 28,
          color: AppColors.onSurface,
        ),
        headlineSmall: GoogleFonts.plusJakartaSans(
          fontSize: 24, fontWeight: FontWeight.w600, height: 32 / 24,
          color: AppColors.onSurface,
        ),
        titleLarge: GoogleFonts.plusJakartaSans(
          fontSize: 22, fontWeight: FontWeight.w500, height: 28 / 22,
          color: AppColors.onSurface,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 16, fontWeight: FontWeight.w600, height: 24 / 16,
          letterSpacing: 0.15, color: AppColors.onSurface,
        ),
        titleSmall: GoogleFonts.inter(
          fontSize: 14, fontWeight: FontWeight.w600, height: 20 / 14,
          letterSpacing: 0.1, color: AppColors.onSurface,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16, fontWeight: FontWeight.w400, height: 24 / 16,
          letterSpacing: 0.5, color: AppColors.onSurface,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14, fontWeight: FontWeight.w400, height: 20 / 14,
          letterSpacing: 0.25, color: AppColors.onSurface,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12, fontWeight: FontWeight.w400, height: 16 / 12,
          letterSpacing: 0.4, color: AppColors.onSurfaceVariant,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14, fontWeight: FontWeight.w500, height: 20 / 14,
          letterSpacing: 0.1, color: AppColors.onSurface,
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 12, fontWeight: FontWeight.w500, height: 16 / 12,
          letterSpacing: 0.5, color: AppColors.onSurface,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 11, fontWeight: FontWeight.w500, height: 16 / 11,
          letterSpacing: 0.5, color: AppColors.onSurfaceVariant,
        ),
      );

  static TextStyle get scoreDisplay => GoogleFonts.plusJakartaSans(
        fontSize: 45, fontWeight: FontWeight.w700, height: 52 / 45,
        letterSpacing: -0.25,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  static TextStyle get timerDisplay => GoogleFonts.inter(
        fontSize: 16, fontWeight: FontWeight.w600, height: 24 / 16,
        letterSpacing: 0.15,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  static TextStyle get mathFormula => GoogleFonts.inter(
        fontSize: 16, fontWeight: FontWeight.w500, height: 24 / 16,
        letterSpacing: 0.5,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  static TextStyle get monospace => GoogleFonts.inter(
        fontSize: 14, fontWeight: FontWeight.w400, height: 20 / 14,
        letterSpacing: 0.25,
        fontFeatures: const [FontFeature.tabularFigures()],
      );
}
