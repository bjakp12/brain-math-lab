import 'app_user.dart';

/// Kontrak backend identitas. Implementasi lokal selalu tersedia;
/// implementasi Google aktif setelah setup Firebase (FIREBASE_SETUP.md).
abstract class AuthRepository {
  Stream<AppUser> get userStream;
  AppUser get currentUser;

  /// false bila login Google belum bisa dipakai di perangkat ini.
  bool get googleAvailable;

  /// Masuk dengan Google. Melempar [AuthNotConfiguredException] bila
  /// Firebase/Google belum dikonfigurasi — UI menampilkan snackbar ramah.
  Future<AppUser> signInWithGoogle();

  Future<void> signOut();
}

class AuthNotConfiguredException implements Exception {
  final String message;
  const AuthNotConfiguredException(
      [this.message =
          'Login Google butuh setup Firebase sekali saja. Lihat FIREBASE_SETUP.md.']);
  @override
  String toString() => message;
}
