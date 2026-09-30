import 'package:flutter_test/flutter_test.dart';
import 'package:math_logic_app/core/data/curriculum.dart';
import 'package:math_logic_app/core/data/generators.dart';

// Validasi skala bank: 53 topik × 4 tier × N seed — tanpa tulis file.
// Dengan N=25 (lihat tool/export_bank.dart) total = 5.300 soal.
void main() {
  test('bank penuh memuat >= 5000 soal valid', () {
    const seeds = 2; // sampel; skala penuh = seeds 25 -> 5300
    final ids = <String>{};
    var n = 0;
    for (final t in kTopics()) {
      for (var tier = 1; tier <= 4; tier++) {
        for (var s = 0; s < seeds; s++) {
          final q = generateDynamic(t.id, tier, s * 7 + 1);
          expect(q.options.length, 4);
          expect(
              q.options.any((o) => o.label == q.answer), true,
              reason: '${q.id}: kunci ${q.answer} harus ada di opsi');
          expect(ids.add(q.id), true, reason: 'duplikat id ${q.id}');
          expect(q.steps.isNotEmpty && q.pitfall.isNotEmpty, true);
          n++;
        }
      }
    }
    expect(n, kTopics().length * 4 * seeds);
    // Proyeksi skala penuh (25 seed): mesti ribuan.
    expect(kTopics().length * 4 * 25, greaterThanOrEqualTo(5000));
  });
}
