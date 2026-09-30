// Identitas pengguna aplikasi: tamu lokal (default) atau akun Google.
class AppUser {
  final String uid;
  final String name;
  final String email;
  final String photoUrl;
  final bool isGuest;
  const AppUser({
    required this.uid,
    required this.name,
    this.email = '',
    this.photoUrl = '',
    this.isGuest = true,
  });

  /// Profil default untuk pengguna baru: bersih, tanpa data demo.
  const AppUser.guest()
      : uid = 'guest',
        name = 'Pelajar',
        email = '',
        photoUrl = '',
        isGuest = true;

  /// Inisial 1-2 huruf untuk avatar default (tanpa foto).
  String get initials {
    final parts =
        name.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    if (parts.isEmpty) return 'P';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }
}
