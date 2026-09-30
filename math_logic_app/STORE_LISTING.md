# Listing Play Store — Brain & Math Lab (siap tempel)

## Identitas
- Nama: **Brain & Math Lab — Matematika & Logika**
- Package: `com.brainmathlab.mathlogic` · versi `1.4.2+2401`
- Kategori: **Education** · Rating: Everyone · Gratis, tanpa iklan, offline.

## Deskripsi singkat (≤80 karakter, ID)
```
Latihan matematika & otak: 5000+ soal adaptif, 10 menit sehari.
```

## Deskripsi penuh (ID)
```
Brain & Math Lab melatih 5 pilar kognitif: Matematika, Logika, Kecepatan,
Memori, dan Visual-Spasial — cukup 10 menit sehari.

MATEMATIKA (53 topik, 4 level: dasar → tantangan)
• Aritmatika, pecahan, desimal & persen
• Aljabar: persamaan, faktorisasi, kuadrat, SPLDV/SPLTV
• Fungsi: linear, grafik, invers, komposisi
• Trigonometri & Geometri lengkap + transformasi
• Peluang, statistika, barisan-deret, aritmatika sosial
• Tiap topik: konsep singkat, contoh, latihan bertahap,
  pembahasan langkah-demi-langkah, rangkuman & evaluasi

LOGIKA & OTAK
• Speed Training: perkalian 1–20, hitung kilat, pola bilangan
• Memory: urutan angka, pola Simon, Memory Maze + bom
• Visual: rotasi 3D, bayangan, susun bentuk

ADAPTIF: kesulitan naik otomatis saat menguasai materi; remedial +
penjelasan tambahan saat sering salah. 100% offline — tanpa akun, tanpa iklan.
```

## Full description (EN, untuk listing bilingual)
```
Brain & Math Lab trains 5 cognitive pillars — Math, Logic, Speed, Memory
and Visual-Spatial — in just 10 minutes a day. 53 math topics across 4
adaptive tiers (basic to challenge), each with concept summary, examples,
graded drills, step-by-step solutions and final evaluation. 20 brain games
including speed arithmetic, sequence memory, bomb memory maze and 3D rotation.
Fully offline. No account. No ads. 5,000+ procedurally generated questions.
```

## Aset grafis
| Aset | Spesifikasi | Status |
|---|---|---|
| App icon 512px | PNG 512×512 | hasilkan: `dart run tool/gen_icons.dart` → resize master 1024 → 512 |
| Feature graphic | 1024×500 PNG | **otomatis**: `store/feature-graphic.png` (dari script yang sama) |
| Screenshot HP | ≥2, JPEG/PNG | ambil di device: `flutter screenshot` saat sesi soal + hasil |
| Screenshot 7"/10" tablet | opsional tapi disarankan | sama, di emulator Pixel Tablet |

## Data safety (jawab di Play Console)
- Tanpa backend: **No data collected / No data shared**.
- Setelah Firebase (opsional): User IDs, App activity — encrypted in transit,
  deletable (tombol hapus di Profil perlu ditambah sebelum klaim ini).

## Checklist pra-publish
- [ ] `dart run tool/gen_icons.dart` + `dart run tool/export_bank.dart`
- [ ] `flutter analyze` bersih, `flutter test` hijau
- [ ] `android/key.properties` + keystore dibuat (lihat key.properties.example)
- [ ] `flutter build appbundle --release` → upload Play Console (track internal)
- [ ] Isi Data safety + Content rating questionnaire + Privacy policy URL
      (hosting PRIVACY_POLICY.md — mis. GitHub Pages repo ini)
- [ ] Screenshot + feature graphic diunggah
