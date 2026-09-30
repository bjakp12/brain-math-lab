import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:math_logic_app/core/auth/app_user.dart';
import 'package:math_logic_app/core/auth/auth_repository.dart';
import 'package:math_logic_app/core/auth/local_auth_repository.dart';
import 'package:math_logic_app/core/data/app_state.dart';
import 'package:math_logic_app/core/data/sync_engine.dart';
import 'package:math_logic_app/core/logic/learner_model.dart';
import 'package:math_logic_app/features/donation/donation_config.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('profil default (tamu bersih, tanpa demo)', () {
    test('guest kosong dan jujur', () {
      const g = AppUser.guest();
      expect(g.isGuest, true);
      expect(g.uid, 'guest');
      expect(g.name, 'Pelajar');
      expect(g.initials, 'P');
    });

    test('inisial dua kata', () {
      expect(const AppUser(uid: 'x', name: 'Budi Pratama').initials, 'BP');
    });

    test('UserProfile default = tamu level 1, XP 0', () {
      const p = UserProfile();
      expect(p.name, 'Pelajar');
      expect(p.level, 1);
      expect(p.totalXp, 0);
      expect(p.streakDays, 0);
      expect(p.todayMinutes, 0);
      expect(p.isGuest, true);
    });

    test('toJson/fromJson roundtrip', () {
      const p = UserProfile(name: 'Ayu', totalXp: 120, level: 3);
      final back = UserProfile.fromJson(p.toJson());
      expect(back.name, 'Ayu');
      expect(back.totalXp, 120);
      expect(back.level, 3);
    });
  });

  group('backend lokal', () {
    setUp(() => SharedPreferences.setMockInitialValues({}));

    test('login Google tanpa setup melempar error ramah', () async {
      final repo = LocalAuthRepository();
      expect(repo.googleAvailable, false);
      expect(
        () => repo.signInWithGoogle(),
        throwsA(isA<AuthNotConfiguredException>()),
      );
      repo.dispose();
    });

    test('signOut kembali ke tamu', () async {
      final repo = LocalAuthRepository();
      await repo.saveLocalProfile(name: 'Dito');
      expect(repo.currentUser.name, 'Dito');
      await repo.signOut();
      expect(repo.currentUser.isGuest, true);
      repo.dispose();
    });
  });

  group('sinkronisasi antrean', () {
    setUp(() => SharedPreferences.setMockInitialValues({}));

    test('enqueue lalu flush mengosongkan antrean', () async {
      final sent = <Map<String, dynamic>>[];
      const engine = SyncEngine(
        isOnline: () async => true,
        remote: (batch) async => sent.addAll(batch),
      );
      await engine.recordAttempt(Attempt(
        topicId: 'ar_penjumlahan',
        tier: 1,
        correct: true,
        seconds: 12,
        estimatedSec: 35,
      ));
      expect(await engine.pending().then((l) => l.length), 1);
      expect(await engine.flush(), 0);
      expect(sent.length, 1);
      expect(sent.first['type'], 'attempt');
    });

    test('offline menahan antrean', () async {
      var calls = 0;
      const engine = SyncEngine(
        isOnline: () async => false,
        remote: (_) async => calls++,
      );
      await engine.recordAttempt(Attempt(
        topicId: 'ge_pythagoras',
        tier: 2,
        correct: false,
        seconds: 40,
        estimatedSec: 45,
      ));
      expect(await engine.flush(), 1);
      expect(calls, 0);
    });
  });

  group('donasi', () {
    test('tautan PayPal valid dan memuat nominal', () {
      for (final a in DonationConfig.paypalAmountsUsd) {
        final url = DonationConfig.paypalUrl(amountUsd: a);
        final uri = Uri.parse(url);
        expect(uri.host, 'www.paypal.com');
        expect(uri.path, '/donate');
        expect(uri.queryParameters['amount'], a.toString());
        expect(uri.queryParameters['currency_code'], 'USD');
        expect(uri.queryParameters['business']!.isNotEmpty, true);
      }
    });
  });
}
