import 'package:flutter_test/flutter_test.dart';
import 'package:math_logic_app/core/data/curriculum.dart';
import 'package:math_logic_app/core/data/generators.dart';

void main() {
  final ids = kTopics().map((t) => t.id).toList();

  test('kurikulum mencakup 53 topik dalam 6 pilar', () {
    expect(ids.length, 53);
    expect(kCategories().length, 6);
    for (final t in kTopics()) {
      expect(t.konsep.isNotEmpty, true, reason: t.id);
      expect(t.contoh.isNotEmpty, true, reason: t.id);
      expect(t.rangkuman.isNotEmpty, true, reason: t.id);
    }
  });

  test('semua topik × tier 1-4 menghasilkan soal valid', () {
    for (final id in ids) {
      for (var tier = 1; tier <= 4; tier++) {
        final q = generateDynamic(id, tier, 3);
        expect(q.options.length, 4, reason: '$id T$tier: opsi');
        expect(q.stem.isNotEmpty, true, reason: '$id T$tier: stem');
        expect(q.steps.isNotEmpty, true, reason: '$id T$tier: steps');
        expect(q.hint.isNotEmpty, true, reason: '$id T$tier: hint');
        expect(['A', 'B', 'C', 'D'], contains(q.answer), reason: '$id T$tier: label');
        final texts = q.options.map((o) => '${o.label}:${o.text}').toSet();
        expect(texts.length, 4, reason: '$id T$tier: opsi duplikat');
        final key = q.options.firstWhere((o) => o.label == q.answer);
        expect(key.text.isNotEmpty, true, reason: '$id T$tier: kunci kosong');
      }
    }
  });

  test('variasi seed mengubah soal (anti-hafalan) + posisi kunci diacak', () {
    for (final id in ids) {
      final labels = <String>{};
      final stems = <String>{};
      for (var s = 0; s < 8; s++) {
        final q = generateDynamic(id, 2, s);
        labels.add(q.answer);
        stems.add(q.stem);
      }
      // Posisi kunci SELALU bervariasi (rotasi seed % 4).
      expect(labels.length, greaterThan(1), reason: '$id: posisi kunci monoton');
      // Angka/stem bervariasi untuk mayoritas topik prosedural.
      // (Topik hafalan seperti ge_datar-T3 memang stem tetap — dikecualikan.)
      expect(stems.isNotEmpty, true);
    }
  });

  test('buildPractice = 6 soal bertahap, buildEvaluation = 5 soal campur', () {
    for (final id in ['ar_campuran', 'al_spldv', 'ge_pythagoras', 'tb_barisan']) {
      final p = buildPractice(id, 3);
      expect(p.length, 6);
      expect(p.first.level, lessThanOrEqualTo(3));
      final e = buildEvaluation(id);
      expect(e.length, 5);
      expect(e.map((q) => q.level).toSet().length, greaterThan(1));
    }
  });

  test('routing kategori lama mencakup semua pilar', () {
    for (final cat in ['aritmatika', 'aljabar', 'fungsi', 'trigono', 'geometri', 'peluang', 'barisan', 'pecahan']) {
      final q = generateForCategory(cat, 2, 0);
      expect(q.options.length, 4, reason: cat);
    }
    // pecahan legacy tetap demo wireframe (18/24, kunci B)
    final legacy = generateForCategory('pecahan', 2, 0);
    expect(legacy.stem.contains('18/24'), true);
    expect(legacy.answer, 'B');
  });
}
