# Backend Brain & Math Lab

Arsitektur: **offline-first + outbox**. Semua upaya/XP ditulis ke antrean
lokal (`SyncEngine`, tersimpan di SharedPreferences) dan dikirim batch saat
online. Tanpa server pun aplikasi **berfungsi penuh** — inilah yang dimaksud
"backend berfungsi": tidak ada layar yang menggantung menunggu jaringan.

## Status saat ini
- `SyncEngine` (`lib/core/data/sync_engine.dart`): antre (`recordAttempt`),
  cek koneksi (`connectivity_plus`), kirim batch 50 (`flush`), kosongkan antrean.
- `RemoteSender` default = dev/null (log saja). Ganti dengan backend nyata:

```dart
final engine = SyncEngine(remote: FirebaseBackend.send);
await engine.flush(); // mis. saat app resume / tiap sesi selesai
```

## Opsi A — Firebase (disarankan, sesuai PRD telemetry)
15 menit di akun Google Anda (saya tidak bisa melakukannya untuk Anda):
1. console.firebase.google.com → Add project → `brain-math-lab`.
2. Android: Add app → package `com.brainmathlab.mathlogic` → unduh
   `google-services.json` → taruh di `android/app/`.
3. iOS: Add app → bundle `com.brainmathlab.mathlogic` → unduh
   `GoogleService-Info.plist` → taruh di `ios/Runner/` (via Xcode).
4. `flutter pub add firebase_core firebase_auth cloud_firestore firebase_analytics`
5. `dart pub global activate flutterfire_cli` → `flutterfire configure`.
6. Implementasi `FirebaseBackend.send`: tulis batch ke
   `users/{uid}/attempts` (Auth anonim bila tanpa login).
7. Firestore rules minimal (hanya dokumen milik sendiri):
```
rules_version = '2';
service cloud.firestore {
  match /databases/{db}/documents {
    match /users/{uid}/{doc=**} {
      allow read, write: if request.auth != null && request.auth.uid == uid;
    }
  }
}
```

### Event analytics (PRD Fase 5 — kirim via firebase_analytics)
| Event | Param |
|---|---|
| `lesson_start` | topic, tier |
| `question_answered` | topic, tier, correct, seconds, confidence |
| `level_up` | topic, from_tier, to_tier |
| `streak_milestone` | days |
| `remedial_shown` | topic |
| `sync_flush` | count |

## Opsi B — Supabase (alternatif 10 menit)
1. supabase.com → New project → catat URL + anon key.
2. `flutter pub add supabase_flutter` → init di `main()` + tabel `attempts`.
3. Implementasi `SupabaseBackend.send` (insert batch).
4. Cocok bila ingin database SQL + Auth email tanpa Firebase.

## Catatan Play Console
- Data safety: jika backend BELUM dipasang → jawab **"No data collected/shared"**
  (sinkronisasi murni lokal). Setelah Firebase Auth aktif → nyatakan
  User IDs + App activity, terenkripsi transit, bisa dihapus via menu profil.
