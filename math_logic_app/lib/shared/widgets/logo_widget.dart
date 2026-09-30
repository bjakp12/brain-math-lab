import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Logo resmi Brain & Math Lab — digambar murni dari kode (tanpa aset),
/// jadi tajam di semua ukuran dan tidak menambah ukuran APK.
/// Dipakai: AppBar, onboarding, splash dalam aplikasi, empty state.
class LogoWidget extends StatelessWidget {
  final double size;
  const LogoWidget({super.key, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _LogoPainter()),
    );
  }
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide;
    // Latar: rounded-square gradasi indigo brand (konstan, tak ikut tema).
    final bg = RRect.fromLTRBR(
      0, 0, s, s, Radius.circular(s * 0.27),
    );
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF3525CD), Color(0xFF4F46E5)],
      ).createShader(Rect.fromLTWH(0, 0, s, s));
    canvas.drawRRect(bg, bgPaint);

    // Simbol takhingga putih (lemniskat) — otak + matematika menyatu.
    final inf = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    const steps = 220;
    final cx = s / 2, cy = s * 0.54, a = s * 0.30;
    for (var i = 0; i <= steps; i++) {
      final t = i / steps * 2 * math.pi;
      final den = 1 + math.pow(math.sin(t), 2);
      final x = cx + a * math.cos(t) / den;
      final y = cy + a * math.sin(t) * math.cos(t) / den * 1.15;
      canvas.drawCircle(Offset(x, y), s * 0.042, inf);
    }

    // Titik aksen emerald: lencana XP.
    canvas.drawCircle(
      Offset(s * 0.73, s * 0.29),
      s * 0.075,
      Paint()..color = AppColors.tertiaryFixedDim,
    );
    canvas.drawCircle(
      Offset(s * 0.73, s * 0.29),
      s * 0.075,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = s * 0.02,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
