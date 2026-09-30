import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  static const double gutter = 16.0;
  static const double gutterTablet = 24.0;
  static const double gutterDesktop = 24.0;

  static const double margin = 16.0;
  static const double marginTablet = 24.0;
  static const double marginDesktop = 32.0;

  static const double bottomNavHeight = 80.0;
  static const double topBarHeight = 64.0;
}

class AppBorderRadius {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 28.0;
  static const double full = 9999.0;

  static BorderRadius get cardSmall => BorderRadius.circular(sm);
  static BorderRadius get cardMedium => BorderRadius.circular(md);
  static BorderRadius get cardLarge => BorderRadius.circular(lg);
  static BorderRadius get cardXLarge => BorderRadius.circular(xl);
  static BorderRadius get cardXXLarge => BorderRadius.circular(xxl);
  static BorderRadius get pill => BorderRadius.circular(full);
}

class AppElevation {
  static const double level0 = 0.0;
  static const double level1 = 0.0;
  static const double level2 = 4.0;
  static const double level3 = 8.0;
  static const double level4 = 12.0;

  static List<BoxShadow> get level2Shadow => [
        BoxShadow(
          color: AppColors.onSurface.withValues(alpha: 0.04),
          blurRadius: 16,
          offset: const Offset(0, 4),
          spreadRadius: -2,
        ),
      ];

  static List<BoxShadow> get level3Shadow => [
        BoxShadow(
          color: AppColors.onSurface.withValues(alpha: 0.08),
          blurRadius: 24,
          offset: const Offset(0, 8),
          spreadRadius: -4,
        ),
      ];

  static List<BoxShadow> get level4Shadow => [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.12),
          blurRadius: 32,
          offset: const Offset(0, 12),
          spreadRadius: -4,
        ),
      ];

  static List<BoxShadow> get primaryButtonShadow => [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.35),
          blurRadius: 20,
          offset: const Offset(0, 8),
          spreadRadius: -4,
        ),
      ];
}

class AppAnimation {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);

  static const Curve standard = Curves.easeInOut;
  static const Curve emphasized = Curves.easeOutCubic;
  static const Curve decelerated = Curves.decelerate;

  static const Duration pageTransition = Duration(milliseconds: 300);
  static const Duration sharedElementTransition = Duration(milliseconds: 400);
}
