import 'package:flutter/material.dart';

/// Foto profil default: lingkaran gradasi brand + inisial nama.
/// Bila [photoUrl] terisi (login Google), tampilkan foto asli dengan
/// fallback otomatis ke inisial bila gagal dimuat.
class AvatarWidget extends StatelessWidget {
  final String name;
  final String photoUrl;
  final double size;
  final double fontSize;
  const AvatarWidget({
    super.key,
    required this.name,
    this.photoUrl = '',
    this.size = 48,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    final initials = _initials(name);
    if (photoUrl.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          photoUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _fallback(initials),
        ),
      );
    }
    return _fallback(initials);
  }

  Widget _fallback(String initials) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3525CD), Color(0xFF4F46E5)],
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  static String _initials(String name) {
    final parts =
        name.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    if (parts.isEmpty) return 'P';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }
}
