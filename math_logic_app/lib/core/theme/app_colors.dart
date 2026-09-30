import 'package:flutter/material.dart';

/// Token warna persis dari `cognitive_kinetic/DESIGN.md` + wireframe Stitch.
/// Light scheme = baseline. Dark scheme = tonal mapping manual agar tetap
/// "stock Android" Material 3 tanpa dynamic-color crash di iOS.
class AppColors {
  // Primary
  static const primary = Color(0xFF1E1E1E);
  static const onPrimary = Color(0xFFFFFFFF);
  static const primaryContainer = Color(0xFF4F46E5);
  static const onPrimaryContainer = Color(0xFFDAD7FF);
  static const primaryFixed = Color(0xFFE2DFFF);
  static const primaryFixedDim = Color(0xFFC3C0FF);
  static const onPrimaryFixed = Color(0xFF0F0069);
  static const onPrimaryFixedVariant = Color(0xFF3323CC);

  // Secondary
  static const secondary = Color(0xFF4648D4);
  static const onSecondary = Color(0xFFFFFFFF);
  static const secondaryContainer = Color(0xFF6063EE);
  static const onSecondaryContainer = Color(0xFFFFFBFF);
  static const secondaryFixed = Color(0xFFE1E0FF);
  static const secondaryFixedDim = Color(0xFFC0C1FF);
  static const onSecondaryFixed = Color(0xFF07006C);
  static const onSecondaryFixedVariant = Color(0xFF2F2EBE);

  // Tertiary (gamifikasi / benar)
  static const tertiary = Color(0xFF005338);
  static const onTertiary = Color(0xFFFFFFFF);
  static const tertiaryContainer = Color(0xFF006E4B);
  static const onTertiaryContainer = Color(0xFF67F4B7);
  static const tertiaryFixed = Color(0xFF6FFBBE);
  static const tertiaryFixedDim = Color(0xFF4EDEA3);
  static const onTertiaryFixed = Color(0xFF002113);
  static const onTertiaryFixedVariant = Color(0xFF005236);

  // Error
  static const error = Color(0xFFBA1A1A);
  static const onError = Color(0xFFFFFFFF);
  static const errorContainer = Color(0xFFFFDAD6);
  static const onErrorContainer = Color(0xFF93000A);

  // Surface hierarchy
  static const surface = Color(0xFFF8F9FA);
  static const surfaceDim = Color(0xFFDAD6FF);
  static const surfaceBright = Color(0xFFFCF8FF);
  static const surfaceLowest = Color(0xFFFFFFFF);
  static const surfaceLow = Color(0xFFF6F2FF);
  static const surfaceContainer = Color(0xFFEFEbFF);
  static const surfaceHigh = Color(0xFFE9E5FF);
  static const surfaceHighest = Color(0xFFE3DFFF);
  static const surfaceVariant = Color(0xFFE3DFFF);
  static const onSurface = Color(0xFF181445);
  static const onSurfaceVariant = Color(0xFF464555);
  static const outline = Color(0xFF777587);
  static const outlineVariant = Color(0xFFC7C4D8);
  static const surfaceTint = Color(0xFF4D44E3);

  // Inverse
  static const inverseSurface = Color(0xFF111111);
  static const inverseOnSurface = Color(0xFFF3EEFF);
  static const inversePrimary = Color(0xFFD2CEFF);
  static const background = Color(0xFFFCF8FF);
  static const onBackground = Color(0xFF181445);

  // Stitch live tokens (pastel + charcoal, dari proyek "Brain Training App
  // Wireframes" per 30 Sep 2026). Dipakai eksplisit untuk aksen pastel agar
  // token semantik lama (indigo seleksi, hijau sukses, merah error) utuh.
  static const pastelPurple = Color(0xFFD2CEFF);
  static const pastelPurpleDeep = Color(0xFF5C5A84);
  static const pastelYellow = Color(0xFFFFEAA7);
  static const amberGlow = Color(0xFFD97706);
  static const cocoaBrown = Color(0xFF78350F);
  static const inkBlack = Color(0xFF111111);
  static const lineGray = Color(0xFFEDEEEF);
  static const successGreen = Color(0xFF10B981);
  static const coralRed = Color(0xFFFF6B6B);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimaryContainer,
      secondary: secondary,
      onSecondary: onSecondary,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: onSecondaryContainer,
      tertiary: tertiary,
      onTertiary: onTertiary,
      tertiaryContainer: tertiaryContainer,
      onTertiaryContainer: onTertiaryContainer,
      error: error,
      onError: onError,
      errorContainer: errorContainer,
      onErrorContainer: onErrorContainer,
      surface: surface,
      onSurface: onSurface,
      surfaceContainerHighest: surfaceHighest,
      surfaceContainerHigh: surfaceHigh,
      surfaceContainer: surfaceContainer,
      surfaceContainerLow: surfaceLow,
      surfaceContainerLowest: surfaceLowest,
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      outlineVariant: outlineVariant,
      inverseSurface: inverseSurface,
      inversePrimary: inversePrimary,
      surfaceTint: surfaceTint,
    );
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFC3C0FF),
      onPrimary: Color(0xFF0F0069),
      primaryContainer: Color(0xFF3525CD),
      onPrimaryContainer: Color(0xFFE2DFFF),
      secondary: Color(0xFFC0C1FF),
      onSecondary: Color(0xFF07006C),
      secondaryContainer: Color(0xFF4648D4),
      onSecondaryContainer: Color(0xFFE1E0FF),
      tertiary: Color(0xFF6FFBBE),
      onTertiary: Color(0xFF002113),
      tertiaryContainer: Color(0xFF005338),
      onTertiaryContainer: Color(0xFF67F4B7),
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      errorContainer: Color(0xFF93000A),
      onErrorContainer: Color(0xFFFFDAD6),
      surface: Color(0xFF14112B),
      onSurface: Color(0xFFF3EEFF),
      surfaceContainerHighest: Color(0xFF2D2A5B),
      surfaceContainerHigh: Color(0xFF25224A),
      surfaceContainer: Color(0xFF1E1B3D),
      surfaceContainerLow: Color(0xFF191633),
      surfaceContainerLowest: Color(0xFF121024),
      onSurfaceVariant: Color(0xFFC7C4D8),
      outline: Color(0xFF918FA3),
      outlineVariant: Color(0xFF464555),
      inverseSurface: Color(0xFFF3EEFF),
      inversePrimary: Color(0xFF3525CD),
      surfaceTint: Color(0xFFC3C0FF),
    );
  }
}
