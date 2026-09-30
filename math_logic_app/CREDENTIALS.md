# Inventaris Kredensial Rilis — Brain & Math Lab

> Prinsip: **tidak ada secret di repo**. Semua file di bawah ini sudah masuk
> `.gitignore` atau berupa template `.example`. Bocor = revoke + rotate.

## 1. Android signing (wajib untuk publish)
| Item | Cara dapat | Taruh di | Validasi |
|---|---|---|---|
| `release.keystore` | `tool` di bawah, sekali saja | `android/release.keystore` (JANGAN commit) | `keytool -list -keystore android\release.keystore` |
| `key.properties` | salin dari `key.properties.example` | `android/key.properties` (JANGAN commit) | build rilis tanpa `--debug` sukses |

Buat keystore (Windows, sekali saja — catat password di password manager):
```bat
keytool -genkey -v -keystore android\release.keystore -alias brainmath -keyalg RSA -keysize 2048 -validity 10000
copy android\key.properties.example android\key.properties
REM lalu isi password di key.properties
```
Backup `release.keystore` di 2 tempat (hilang = tidak bisa update aplikasi lagi).

## 2. Google Play Console (±$25 sekali bayar)
| Item | Cara dapat | Dipakai untuk |
|---|---|---|
| Akun developer | play.google.com/console → daftar | upload AAB |
| Upload key = release.keystore di atas | otomatis saat upload pertama (App signing by Google) | update berikutnya |
| Service account + JSON key (opsional, untuk upload via CI) | Setup → API access → Create service account → key JSON → simpan sebagai GitHub Secret `PLAY_SERVICE_JSON` | `r0adkll/upload-google-play` di workflow |
| Data safety, rating, listing | isi manual mengikuti `STORE_LISTING.md` | review lolos |

## 3. Apple App Store (butuh $99/tahun + Mac/CI)
| Item | Cara dapat | Dipakai untuk |
|---|---|---|
| Apple Developer Program | developer.apple.com | TestFlight + rilis |
| Team ID (10 karakter) | Membership details | `ios/ExportOptions.plist` → ganti `GANTI_DENGAN_TEAM_ID_10_KARAKTER` |
| Bundle ID | Identifiers → `com.brainmathlab.mathlogic` | Xcode target + Firebase iOS |
| App Store Connect API key (opsional CI) | Users and Access → Integrations | upload IPA otomatis |

## 4. Firebase (login Google + cloud)
| Item | Cara dapat | Taruh di |
|---|---|---|
| `google-services.json` | console → Android app | `android/app/` |
| `GoogleService-Info.plist` | console → iOS app | `ios/Runner/` via Xcode |
| SHA-1 debug & rilis | `keytool -list ...` (lihat FIREBASE_SETUP.md) | Project settings → fingerprints |
| Web/OAuth client IDs | otomatis dari google-services | jangan dipakai manual |

## 5. Donasi
| Item | Cara dapat | Taruh di |
|---|---|---|
| Email bisnis PayPal | paypal.com → buat akun bisnis → paypal.com/donate | `lib/features/donation/donation_config.dart` → `paypalEmail` |
| Gambar QR QRIS statis | minta ke bank/acquirer (PNG kontras, persegi) | `assets/brand/qris.png` |

## 6. Checklist sebelum `git push` rilis
- [ ] `git status` bersih dari: `*.keystore`, `key.properties`, `google-services.json`, `GoogleService-Info.plist`, `build.log`
- [ ] `flutter analyze` bersih · `flutter test` hijau
- [ ] `flutter build appbundle --release` sukses (pakai keystore rilis)
- [ ] `aapt dump badging` → `sdkVersion:'24'`
