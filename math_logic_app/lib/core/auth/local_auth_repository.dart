import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_user.dart';
import 'auth_repository.dart';

/// Backend lokal: profil tamu default, tersimpan di perangkat sejak awal.
/// Tidak butuh jaringan, akun, maupun konfigurasi apa pun.
class LocalAuthRepository implements AuthRepository {
  static const _kName = 'auth_local_name';
  static const _kEmail = 'auth_local_email';
  static const _kPhoto = 'auth_local_photo';

  final _ctrl = StreamController<AppUser>.broadcast();
  AppUser _user = const AppUser.guest();
  bool _ready = false;

  Future<AppUser> _ensure() async {
    if (!_ready) {
      await _load();
      _ready = true;
    }
    return _user;
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    final name = p.getString(_kName);
    if (name != null && name.isNotEmpty) {
      _user = AppUser(
        uid: 'guest',
        name: name,
        email: p.getString(_kEmail) ?? '',
        photoUrl: p.getString(_kPhoto) ?? '',
      );
    }
  }

  /// Dipakai onboarding/pengaturan untuk memberi nama lokal (tetap tamu).
  Future<void> saveLocalProfile(
      {required String name, String email = '', String photoUrl = ''}) async {
    _user = AppUser(uid: 'guest', name: name, email: email, photoUrl: photoUrl);
    final p = await SharedPreferences.getInstance();
    await p.setString(_kName, name);
    await p.setString(_kEmail, email);
    await p.setString(_kPhoto, photoUrl);
    _ctrl.add(_user);
  }

  @override
  Stream<AppUser> get userStream async* {
    yield await _ensure();
    yield* _ctrl.stream;
  }

  @override
  AppUser get currentUser => _user;

  @override
  bool get googleAvailable => false;

  @override
  Future<AppUser> signInWithGoogle() =>
      throw const AuthNotConfiguredException();

  @override
  Future<void> signOut() async {
    _user = const AppUser.guest();
    final p = await SharedPreferences.getInstance();
    await p.remove(_kName);
    await p.remove(_kEmail);
    await p.remove(_kPhoto);
    _ctrl.add(_user);
  }

  void dispose() => _ctrl.close();
}
