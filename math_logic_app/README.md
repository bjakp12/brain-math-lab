# Brain & Math Lab — Flutter (Android & iOS)

Replika 1:1 dari 14 wireframe Stitch + `DESIGN.md` (Cognitive Kinetic, Material 3 stock Android),
dengan rancangan PRD: kurikulum matematika berlevel, brain training, adaptive engine, offline-first.

## Struktur
```
lib/
  main.dart
  core/
    theme/ (app_colors.dart, app_theme.dart)   # token DESIGN.md persis
    router/ (app_router.dart)                  # alur Bagian IV spek
    data/ (app_state.dart, question_bank.dart) # profil, settings, bank soal prosedural
    logic/ (adaptive_engine.dart)              # nextLevel, mastery, SM-2
  shared/widgets/ (app_widgets.dart, main_shell.dart)
  features/
    onboarding/ (Layar 1)
    home/ (Layar 2)
    modules/ (Layar 3)
    math/ (Layar 4,5,6,7,8)
    games/ (Layar 9 speed, 10 memory sequence, 11 maze, 12 visual)
    profile/ (Layar 13)
    settings/ (Layar 14)
```

## Bank soal (ribuan, prosedural, offline)
`question_bank.dart` → `generateQuestion(categoryId, level, index)` deterministik
(seed = level*1000+index). Mencakup: aritmatika, pecahan/FPB, aljabar (cari x),
geometri Pythagoras, + fallback umum. `buildSession()` = 10 soal/sesi.
Distractor meniru "jebakan tipikal" wireframe (mis. 9/12 belum sederhana).
Tinggal ganti dengan CSV/Isar tanpa mengubah UI: `Question` sudah sesuai PRD
(`id, categoryId, subCategoryId, level, type, stem, options, answer,
explanation(steps), tags, estimatedTimeSec, xpReward`).

## Adaptive engine
`adaptive_engine.dart`: `nextLevel(pCorrect>0.75 / <0.55)`, `isMastery(3x benar)`,
`sm2Interval()` untuk review soal salah — sesuai PRD Fase 4.

## Menjalankan
```bash
flutter pub get
flutter run                    # debug Android/iOS
flutter build apk --release    # Android
flutter build ipa --release    # iOS (di macOS)
flutter test
```

## Kesesuaian wireframe
| # | Layar | File |
|---|-------|------|
| 1 | Onboarding | onboarding_screen.dart |
| 2 | Beranda | home_screen.dart |
| 3 | Katalog Modul | module_catalog_screen.dart |
| 4 | Daftar Kategori | category_list_screen.dart |
| 5 | Detail Materi | material_detail_screen.dart |
| 6 | Soal | question_screen.dart |
| 7 | Pembahasan | explanation_screen.dart |
| 8 | Hasil | result_screen.dart |
| 9 | Speed Training | speed_training_screen.dart |
| 10 | Memory Sequence | memory_sequence_screen.dart |
| 11 | Memory Maze + D-Pad + bom | memory_maze_screen.dart |
| 12 | Visual 3D rotasi (CustomPaint) | visual_training_screen.dart |
| 13 | Profil + radar pentagon | profile_screen.dart |
| 14 | Pengaturan | settings_screen.dart |

Catatan: Flutter SDK tidak tersedia di mesin build ini, jadi verifikasi
dilakukan secara statis (struktur file + konsistensi import/route).
Jalankan `flutter analyze` di mesin Anda sebelum release.
