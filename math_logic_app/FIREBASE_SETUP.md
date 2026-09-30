# Setup Firebase — Login Google + Cloud Progress (±15 menit)

> Tanpa langkah ini aplikasi tetap jalan 100% sebagai **tamu offline**.
> Setelah langkah ini: tombol Google di Profil/Keluar berfungsi, progres
> tersimpan di `users/{uid}` dan mengikuti akun di semua perangkat.

## 0. Dependensi (sekali saja, di proyek)
```bat
flutter pub add firebase_core firebase_auth cloud_firestore google_sign_in
flutter pub get
```

## 1. Buat project Firebase
1. Buka console.firebase.google.com → Add project → nama `brain-math-lab`
   (Analytics boleh off).
2. **Android**: Add app → package persis `com.brainmathlab.mathlogic` →
   unduh `google-services.json` → taruh di `android/app/google-services.json`.
   Ambil juga SHA-1 debug + rilis untuk OAuth (lihat langkah 4).
3. **iOS**: Add app → bundle persis `com.brainmathlab.mathlogic` → unduh
   `GoogleService-Info.plist` → tambahkan via Xcode ke folder Runner
   (File → Add Files, centang target Runner).
4. (Opsional, rapi) `dart pub global activate flutterfire_cli`
   lalu `flutterfire configure` — menghasilkan `lib/firebase_options.dart`;
   bila dipakai, ganti `Firebase.initializeApp()` di `main.dart` menjadi
   `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)`.

## 2. Nyalakan provider Google
Authentication → Sign-in method → **Google → Enable** → pilih support email.
(OAuth consent screen ikut terbuat otomatis.)

## 3. Firestore + rules
Firestore Database → Create database (production mode, region asia-southeast1/
Singapore) → tab Rules, tempel:
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

## 4. SHA-1 (wajib untuk login Google di APK debug & rilis)
```bat
keytool -list -v -keystore %USERPROFILE%\.android\debug.keystore -alias androiddebugkey -storepass android
keytool -list -v -keystore android\release.keystore -alias brainmath
```
Tempel tiap SHA-1 ke Project settings → Your apps (Android) → Add fingerprint.

## 5. Uji
1. `flutter run` → Profil → Google → pilih akun → snackbar sukses.
2. Mainkan 1 sesi → Firebase console → Firestore → `users/{uid}` terisi
   `profile` + subkoleksi `attempts`.
3. Hapus instalan → instal ulang → login lagi → XP/level kembali (cloud menang).

## Troubleshooting
| Gejala | Penyebab umum |
|---|---|
| `ApiException: 10` (DEVELOPER_ERROR) | SHA-1 belum didaftarkan / package name beda |
| Snackbar "butuh setup Firebase" | `google-services.json`/plist belum dipasang |
| iOS: `Missing GoogleService-Info.plist` | file belum di-add ke target Runner di Xcode |
| Auth ok tapi Firestore ditolak | rules belum Publish |
