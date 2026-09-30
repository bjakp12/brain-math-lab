import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Material 3 theme persis DESIGN.md:
/// Display/Headline = Plus Jakarta Sans, Body/Label = Inter.
class AppTheme {
  static TextTheme _textTheme(ColorScheme scheme) {
    final display = GoogleFonts.plusJakartaSansTextTheme();
    final body = GoogleFonts.interTextTheme();
    return TextTheme(
      displayLarge: display.displayLarge?.copyWith(
          fontSize: 57, fontWeight: FontWeight.w700, height: 64 / 57, letterSpacing: -0.25, color: scheme.onSurface),
      displayMedium: display.displayMedium?.copyWith(
          fontSize: 45, fontWeight: FontWeight.w600, height: 52 / 45, color: scheme.onSurface),
      displaySmall: display.displaySmall?.copyWith(
          fontSize: 36, fontWeight: FontWeight.w600, height: 44 / 36, color: scheme.onSurface),
      headlineLarge: display.headlineLarge?.copyWith(
          fontSize: 32, fontWeight: FontWeight.w600, height: 40 / 32, color: scheme.onSurface),
      headlineMedium: display.headlineMedium?.copyWith(
          fontSize: 28, fontWeight: FontWeight.w600, height: 36 / 28, color: scheme.onSurface),
      headlineSmall: display.headlineSmall?.copyWith(
          fontSize: 24, fontWeight: FontWeight.w600, height: 32 / 24, color: scheme.onSurface),
      titleLarge: display.titleLarge?.copyWith(
          fontSize: 22, fontWeight: FontWeight.w500, height: 28 / 22, color: scheme.onSurface),
      titleMedium: body.titleMedium?.copyWith(
          fontSize: 16, fontWeight: FontWeight.w600, height: 24 / 16, letterSpacing: 0.15, color: scheme.onSurface),
      titleSmall: body.titleSmall?.copyWith(
          fontSize: 14, fontWeight: FontWeight.w600, height: 20 / 14, letterSpacing: 0.1, color: scheme.onSurface),
      bodyLarge: body.bodyLarge?.copyWith(
          fontSize: 16, fontWeight: FontWeight.w400, height: 24 / 16, letterSpacing: 0.5, color: scheme.onSurface),
      bodyMedium: body.bodyMedium?.copyWith(
          fontSize: 14, fontWeight: FontWeight.w400, height: 20 / 14, letterSpacing: 0.25, color: scheme.onSurface),
      bodySmall: body.bodySmall?.copyWith(
          fontSize: 12, fontWeight: FontWeight.w400, height: 16 / 12, letterSpacing: 0.4, color: scheme.onSurfaceVariant),
      labelLarge: body.labelLarge?.copyWith(
          fontSize: 14, fontWeight: FontWeight.w500, height: 20 / 14, letterSpacing: 0.1, color: scheme.onSurface),
      labelMedium: body.labelMedium?.copyWith(
          fontSize: 12, fontWeight: FontWeight.w500, height: 16 / 12, letterSpacing: 0.5, color: scheme.onSurfaceVariant),
      labelSmall: body.labelSmall?.copyWith(
          fontSize: 11, fontWeight: FontWeight.w500, height: 16 / 11, letterSpacing: 0.5, color: scheme.onSurfaceVariant),
    );
  }

  static ThemeData light() {
    final scheme = AppColors.lightScheme();
    return _base(scheme);
  }

  static ThemeData dark() {
    final scheme = AppColors.darkScheme();
    return _base(scheme);
  }

  static ThemeData _base(ColorScheme scheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      textTheme: _textTheme(scheme),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surfaceContainerLowest.withValues(alpha: 0.92),
        surfaceTintColor: Colors.transparent,
        shape: Border(
            bottom: BorderSide(
                color: scheme.outlineVariant.withValues(alpha: 0.6))),
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: scheme.onSurface),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface.withValues(alpha: 0.85),
        indicatorColor: AppColors.pastelPurple,
        labelTextStyle: WidgetStatePropertyAll(
            GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500)),
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceContainerLow,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 48),
          shape: const StadiumBorder(),
          textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      chipTheme: scheme.brightness == Brightness.light
          ? ChipThemeData(
              backgroundColor: AppColors.surfaceLow,
              selectedColor: AppColors.primary,
              secondaryLabelStyle: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
              labelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
            )
          : null,
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? scheme.onPrimary : scheme.onSurfaceVariant),
        trackColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? scheme.primary : scheme.surfaceContainerHighest),
      ),
    );
  }
}
