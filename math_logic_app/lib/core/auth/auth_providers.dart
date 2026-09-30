import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/app_state.dart';
import '../data/sync_engine.dart';
import '../logic/learner_model.dart';
import 'app_user.dart';
import 'auth_repository.dart';
import 'google_auth_repository.dart';
import 'local_auth_repository.dart';

/// true setelah Firebase.initializeApp() sukses (diatur Bootstrap).
/// Selama false, seluruh aplikasi memakai backend lokal (tamu).
final firebaseReadyProvider = StateProvider<bool>((ref) => false);

/// Model adaptif in-memory untuk sesi berjalan.
final learnerModelProvider = Provider<LearnerModel>((ref) => LearnerModel());

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  if (ref.watch(firebaseReadyProvider)) {
    return GoogleAuthRepository();
  }
  return LocalAuthRepository();
});

final appUserProvider = StreamProvider<AppUser>((ref) {
  return ref.watch(authRepositoryProvider).userStream;
});

/// Orkestrasi login: Google -> profil lokal -> tarik cloud -> sinkron antrean.
Future<AppUser> signInWithGoogleAction(WidgetRef ref) async {
  final repo = ref.read(authRepositoryProvider);
  final user = await repo.signInWithGoogle();
  final profile = ref.read(profileProvider.notifier);
  profile.applyGoogleUser(user);
  if (!user.isGuest) {
    try {
      final cloud = await ProgressRepository.loadProfile(user.uid);
      if (cloud != null) profile.applyCloud(cloud);
      await ref.read(syncEngineProvider).flush();
    } catch (_) {/* cloud opsional; lokal tetap jalan */}
  }
  return user;
}

/// Keluar: kembali ke tamu (data cloud tetap aman di server).
Future<void> signOutAction(WidgetRef ref) async {
  try {
    await ref.read(authRepositoryProvider).signOut();
  } catch (_) {}
  ref.read(profileProvider.notifier).resetToGuest();
}
