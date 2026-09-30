# Matriks Build: Android 7 → 17 & iOS 15 → 27

> iOS 14 **tidak dapat** dipakai: Xcode 27 menolak deployment target < 15.0
> (`Target Integrity ... range 15.0 to 27.0.x`, flutter/flutter#187741).
> Kabar baik: daftar perangkat iOS 14 ≡ iOS 15 (iPhone 6s ke atas), jadi
> cakupan perangkat **tetap sama** seperti target awal Anda.

## 1. Toolchain terkunci (Flutter 3.47, terverifikasi resmi)

| Komponen | Versi | Keterangan |
|---|---|---|
| Flutter | 3.47.x stable | Dart 3.13 |
| Java | 17 (wajib) | Temurin 17 / Android Studio bundled |
| Kotlin (KGP) | 2.4.0 | `org.jetbrains.kotlin.android` |
| AGP | 9.1.0 | JANGAN ke AGP 10 sebelum didukung resmi |
| Gradle | 9.3.1 | via `gradle-wrapper.properties` |
| compileSdk / targetSdk | 36 (Android 16) | dari `flutter.*` / literal di `app/build.gradle.kts` |
| minSdk | 24 (Android 7.0) | = juga default `flutter.minSdkVersion` |
| Xcode | 27 (27A266a) | SDK iOS 27, Swift 6.4 — macOS saja |
| CocoaPods | terbaru (`sudo gem install cocoapods`) | + `platform :ios, '15.0'` |
| Deployment target iOS | 15.0 | Runner + semua pod (via `post_install`) |

## 2. Matriks Android (minSdk 24 → targetSdk 36)

| OS | API | Status uji | Catatan perilaku |
|---|---|---|---|
| 7.0 – 7.1 | 24–25 | Emulator Nexus 5X | Baseline terendah; hindari API desugaring > 24 |
| 8 – 9 | 26–28 | Emulator Pixel 2 | Notifikasi channel (abaikan, Flutter menangani) |
| 10 – 12 | 29–31 | Emulator Pixel 4 | Scoped storage (tidak relevan, offline) |
| 13 – 14 | 33–34 | Emulator Pixel 7 | Izin notifikasi runtime (tidak dipakai) |
| 15 – 16 | 35–36 | Emulator Pixel 9 | **Edge-to-edge enforced** → uji nav gestur & tombol |
| 17 | 37 | Emulator Pixel (API 37 image) | targetSdk masih 36 → aturan resizability API-37 **belum** mengikat; naikkan setelah uji (jangan kunci orientasi!) |

## 3. Matriks iOS (deployment 15.0 → SDK 27)

| OS | Perangkat uji | Catatan |
|---|---|---|
| 15 – 16 | iPhone 7/8 sim | Batas bawah; uji font skala & safe-area |
| 17 – 18 | iPhone 12/14 sim | - |
| 26 – 27 | iPhone 17/18 sim + device | Build WAJIB Xcode 27; upload via Transporter/TestFlight |

## 4. Urutan kerja

### A. Generate shell iOS (sekali saja, `android/` sudah jadi)
```bat
cd math_logic_app
C:\Users\Administrator\develop\flutter\bin\flutter create --platforms=ios --org com.brainmathlab .
```
Hanya membuat `ios/Runner.xcodeproj` dkk — file `ios/Podfile` & `ios/ExportOptions.plist`
kita TIDAK tertimpa parah (cek `git status`; jika Podfile berubah, timpa ulang dengan versi repo ini).
Lalu di Xcode (Mac/CI): Runner target → General → **Minimum Deployments = 15.0**,
Bundle Identifier = `com.brainmathlab.mathlogic`.

### B. SDK Android (sekali saja)
```bat
sdkmanager "platform-tools" "platforms;android-36" "platforms;android-37" "build-tools;36.0.0" ^
  "system-images;android-24;google_apis;x86_64" "system-images;android-36;google_apis;x86_64"
```
API 24 untuk uji batas bawah, API 36/37 untuk target/latest.

### C. Emulator matriks (contoh)
```bat
avdmanager create avd -n api24 -k "system-images;android-24;google_apis;x86_64" -d "Nexus 5X"
avdmanager create avd -n api36 -k "system-images;android-36;google_apis;x86_64" -d "pixel_9"
flutter emulators --launch api24
```

### D. Build & verifikasi
```bat
flutter pub get
flutter analyze
flutter test
flutter build apk --release --split-per-abi
flutter build appbundle --release
```
Cek hasil:
```bat
aapt dump badging build\app\outputs\flutter-apk\app-arm64-v8a-release.apk | findstr sdkVersion
REM harus: sdkVersion:'24'  targetSdkVersion:'36'
adb -s emulator-5554 install -r app-arm64-v8a-release.apk
```
IPA (hanya macOS/CI — tidak bisa di Windows):
```bash
flutter build ipa --release --export-options-plist=ios/ExportOptions.plist
```
Isi dulu `teamID` di `ios/ExportOptions.plist` + Bundle ID di Xcode.

### E. Signing rilis Play Store (sekali saja, di PC aman — JANGAN commit)
```bat
keytool -genkey -v -keystore android\release.keystore -alias brainmath -keyalg RSA -keysize 2048 -validity 10000
```
Buat `android\key.properties` (masuk .gitignore):
```
storePassword=***
keyPassword=***
keyAlias=brainmath
storeFile=../release.keystore
```
Lalu ganti blok `release {` di `app/build.gradle.kts` memakai `keystoreProperties`
(minta saya bila sampai tahap ini — saya tuliskan bloknya).

## 5. Aturan main ke depan
1. Jangan ubah AGP/Gradle/Kotlin/Java — hanya Flutter `upgrade` yang boleh.
2. Jangan kunci orientasi / `resizeableActivity=false` (dilarang API 37).
3. Uji tiap rilis minimal di: emulator API 24, API 36, dan satu iPhone sim iOS 27.
4. `flutter analyze && flutter test` harus hijau sebelum build (CI sudah menegakkannya).
5. Jika build gagal di gerbang *"Your project's Kotlin version (2.2.10) is lower
   than Flutter's minimum (2.2.20)"* — itu quirk checker Flutter 3.47.5 (membaca
   Kotlin bawaan AGP, bukan KGP terdeklarasi), BUKAN error kompilasi. Lewati dengan:
   `flutter build apk --debug --android-skip-build-dependency-validation`.
