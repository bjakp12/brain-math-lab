import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'app_user.dart';
import 'auth_repository.dart';

/// Backend Google: Sign-In (google_sign_in v7) + Firebase Auth +
/// progres di Cloud Firestore. Aktif bila `google-services.json` /
/// `GoogleService-Info.plist` terpasang + `Firebase.initializeApp()` sukses.
/// Lihat FIREBASE_SETUP.md untuk 15 menit setup konsol.
class GoogleAuthRepository implements AuthRepository {
  bool _gsiReady = false;

  Future<void> _ensureGsi() async {
    if (_gsiReady) return;
    try {
      await GoogleSignIn.instance.initialize();
    } catch (_) {
      // initialize() boleh gagal di sini; authenticate() akan mencoba lagi.
    }
    _gsiReady = true;
  }

  /// Pemulihan sesi diam-diam saat aplikasi dibuka (tanpa UI).
  Future<void> restore() async {
    await _ensureGsi();
    try {
      await GoogleSignIn.instance.attemptLightweightAuthentication();
    } catch (_) {/* tetap tamu bila gagal */}
  }

  AppUser _map(User? u) => u == null
      ? const AppUser.guest()
      : AppUser(
          uid: u.uid,
          name: (u.displayName?.trim().isNotEmpty ?? false)
              ? u.displayName!.trim()
              : 'Pelajar',
          email: u.email ?? '',
          photoUrl: u.photoURL ?? '',
          isGuest: false,
        );

  @override
  bool get googleAvailable => true;

  @override
  AppUser get currentUser => _map(FirebaseAuth.instance.currentUser);

  @override
  Stream<AppUser> get userStream =>
      FirebaseAuth.instance.authStateChanges().map(_map);

  @override
  Future<AppUser> signInWithGoogle() async {
    await _ensureGsi();
    final gsi = GoogleSignIn.instance;
    if (!gsi.supportsAuthenticate()) {
      throw const AuthNotConfiguredException(
          'Perangkat ini tidak mendukung login Google langsung.');
    }
    final gUser = await gsi.authenticate();
    final idToken = gUser.authentication.idToken;
    if (idToken == null || idToken.isEmpty) {
      throw const AuthNotConfiguredException(
          'Token Google kosong. Periksa jam perangkat lalu coba lagi.');
    }
    final cred = GoogleAuthProvider.credential(idToken: idToken);
    final res = await FirebaseAuth.instance.signInWithCredential(cred);
    return _map(res.user);
  }

  @override
  Future<void> signOut() async {
    try {
      await GoogleSignIn.instance.signOut();
    } catch (_) {}
    await FirebaseAuth.instance.signOut();
  }
}

/// Penyimpanan progres: users/{uid} {profile, updatedAt}
/// + users/{uid}/attempts/{id}. Dipakai login, bootstrap, dan SyncEngine.
class ProgressRepository {
  static DocumentReference<Map<String, dynamic>> _doc(String uid) =>
      FirebaseFirestore.instance.collection('users').doc(uid);

  static Future<void> saveProfile(
      String uid, Map<String, dynamic> json) async {
    await _doc(uid).set(
      {'profile': json, 'updatedAt': FieldValue.serverTimestamp()},
      SetOptions(merge: true),
    );
  }

  static Future<Map<String, dynamic>?> loadProfile(String uid) async {
    final d = await _doc(uid).get();
    final m = d.data();
    if (m == null) return null;
    final p = m['profile'];
    return p is Map ? Map<String, dynamic>.from(p) : null;
  }

  /// Pengirim batch untuk SyncEngine.flush(remote: ...).
  static Future<void> Function(List<Map<String, dynamic>>) sender(
      String uid) {
    return (batch) async {
      final col = _doc(uid).collection('attempts');
      final w = FirebaseFirestore.instance.batch();
      for (final e in batch) {
        final id = e['id'] as String?;
        w.set(col.doc(id), {
          ...e,
          'uid': uid,
          'serverAt': FieldValue.serverTimestamp(),
        });
      }
      await w.commit();
    };
  }
}
