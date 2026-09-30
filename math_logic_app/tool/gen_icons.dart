// Membuat ikon launcher PNG dari logo (murni Dart, tanpa tool desain).
// Jalankan:  dart run tool/gen_icons.dart   (sesudah flutter pub get)
// Keluaran : mipmap-* Android (API 24-25), AppIcon iOS, feature graphic Play Store.
import 'dart:io';
import 'dart:math' as math;
import 'package:image/image.dart';

void drawLogo(Image img) {
  final s = img.width;
  fill(img, color: ColorRgb8(53, 37, 205)); // indigo brand full-bleed
  // Takhingga putih (lemniskat).
  final white = ColorRgb8(255, 255, 255);
  const steps = 360;
  final cx = s / 2, cy = s * 0.54, a = s * 0.30, r = (s * 0.038).round();
  for (var i = 0; i <= steps; i++) {
    final t = i / steps * 2 * math.pi;
    final den = 1 + math.pow(math.sin(t), 2);
    final x = (cx + a * math.cos(t) / den).round();
    final y = (cy + a * math.sin(t) * math.cos(t) / den * 1.15).round();
    fillCircle(img, x: x, y: y, radius: r, color: white);
  }
  // Titik emerald.
  fillCircle(img,
      x: (s * 0.73).round(),
      y: (s * 0.29).round(),
      radius: (s * 0.07).round(),
      color: ColorRgb8(78, 222, 163));
}

void save(Image img, String path) {
  File(path)
    ..createSync(recursive: true)
    ..writeAsBytesSync(encodePng(img));
  print('wrote $path (${img.width}x${img.height})');
}

void main() {
  final master = Image(width: 1024, height: 1024);
  drawLogo(master);

  // Android legacy (API 24-25; API 26+ memakai adaptive XML vektor).
  const android = {'mdpi': 48, 'hdpi': 72, 'xhdpi': 96, 'xxhdpi': 144, 'xxxhdpi': 192};
  android.forEach((dens, px) {
    save(copyResize(master, width: px, height: px),
        'android/app/src/main/res/mipmap-$dens/ic_launcher.png');
  });

  // iOS AppIcon (nama file HARUS cocok dengan Contents.json).
  const iosIcons = {
    'Icon-App-20x20@2x.png': 40,
    'Icon-App-20x20@3x.png': 60,
    'Icon-App-29x29@2x.png': 58,
    'Icon-App-29x29@3x.png': 87,
    'Icon-App-40x40@2x.png': 80,
    'Icon-App-40x40@3x.png': 120,
    'Icon-App-60x60@2x.png': 120,
    'Icon-App-60x60@3x.png': 180,
    'Icon-App-76x76@1x.png': 76,
    'Icon-App-76x76@2x.png': 152,
    'Icon-App-83.5x83.5@2x.png': 167,
    'Icon-App-1024x1024@1x.png': 1024,
  };
  iosIcons.forEach((name, px) {
    save(copyResize(master, width: px, height: px),
        'ios/Runner/Assets.xcassets/AppIcon.appiconset/$name');
  });

  // Feature graphic Play Store 1024x500.
  final fg = Image(width: 1024, height: 500);
  fill(fg, color: ColorRgb8(53, 37, 205));
  final mark = copyResize(master, width: 360, height: 360);
  compositeImage(fg, mark, dstX: 60, dstY: 70);
  drawString(fg, 'BRAIN & MATH LAB',
      font: arial48, x: 470, y: 150, color: ColorRgb8(255, 255, 255));
  drawString(fg, 'Latihan Matematika & Logika 10 menit sehari',
      font: arial24, x: 472, y: 230, color: ColorRgb8(194, 192, 255));
  fillCircle(fg, x: 490, y: 330, radius: 14, color: ColorRgb8(78, 222, 163));
  drawString(fg, '5000+ soal  -  Offline  -  Adaptif',
      font: arial24, x: 520, y: 312, color: ColorRgb8(255, 255, 255));
  save(fg, 'store/feature-graphic.png');

  print('DONE: ${android.length + iosIcons.length + 1} files');
}
