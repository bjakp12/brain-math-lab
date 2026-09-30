// Bank soal DINAMIS: setiap topik × tier (1 dasar, 2 menengah, 3 lanjut,
// 4 tantangan) × seed menghasilkan variasi angka berbeda — pengguna tidak
// bisa menghafal jawaban. Posisi kunci jawaban juga diacak dari seed.
// Setiap soal: stem, hint, 4 opsi, steps pembahasan, pitfall (jebakan).
import 'dart:math';
import 'curriculum.dart';
import 'question_bank.dart';

int _clampTier(int t) => t < 1 ? 1 : (t > 4 ? 4 : t);

Question _mk({
  required String topicId,
  required int tier,
  required int seed,
  required String stem,
  required String hint,
  required String correct,
  String correctSub = '',
  required List<List<String>> wrong, // [teks, sub] × 3
  required List<String> steps,
  required String pitfall,
}) {
  tier = _clampTier(tier);
  final pool = <List<String>>[
    [correct, correctSub],
    ...wrong,
  ];
  // Pengaman waktu development: setiap soal wajib tepat 4 opsi
  // (1 benar + 3 salah). Gagal di sini = bug generator, bukan data.
  assert(wrong.length == 3,
      '$topicId T$tier: wrong harus 3 opsi, dapat ${wrong.length}');
  final rot = seed % 4;
  final ordered = List<List<String>>.generate(4, (i) => pool[(i + rot) % 4]);
  var ansIdx = 0;
  for (var i = 0; i < 4; i++) {
    if (ordered[i][0] == correct && ordered[i][1] == correctSub) {
      ansIdx = i;
      break;
    }
  }
  const labels = ['A', 'B', 'C', 'D'];
  return Question(
    id: '$topicId-T$tier-$seed',
    categoryId: topicMeta(topicId)?.categoryId ?? 'tambahan',
    subCategoryId: topicId,
    level: tier,
    type: QuestionType.multipleChoice,
    stem: stem,
    hint: hint,
    options: List.generate(
        4, (i) => QOption(labels[i], ordered[i][0], ordered[i][1])),
    answer: labels[ansIdx],
    steps: steps,
    pitfall: pitfall,
    estimatedTimeSec: 25 + tier * 10,
    xpReward: 6 + tier * 2,
  );
}

int _fpb(int a, int b) => b == 0 ? a : _fpb(b, a % b);

String _b(bool v) => v ? 'benar' : 'salah';

// ---------------------------------------------------------------------------
// Generator utama
// ---------------------------------------------------------------------------
Question generateDynamic(String topicId, int tier, int seed) {
  tier = _clampTier(tier);
  final R = Random(seed * 911 + tier * 37 + 7);
  switch (topicId) {
    // ================= ARITMATIKA =================
    case 'ar_penjumlahan': {
      final m = [20, 200, 2000, 2000][tier - 1];
      final a = 2 + R.nextInt(m), b = 2 + R.nextInt(m);
      final ans = a + b;
      if (tier == 4) {
        final c = 2 + R.nextInt(500);
        final t = ans + c;
        return _mk(topicId: topicId, tier: tier, seed: seed,
          stem: 'Ibu membeli $a kg beras, $b kg gula, dan $c kg tepung. Total belanjaan Ibu?',
          hint: 'Jumlahkan ketiganya bertahap.', correct: '$t', correctSub: 'kg',
          wrong: [['${t - 10}', 'kg'], ['${t + 10}', 'kg'], ['${t - 100}', 'kg']],
          steps: ['$a + $b = $ans.', '$ans + $c = $t.'], pitfall: 'Lupa menjumlahkan salah satu barang.');
      }
      return _mk(topicId: topicId, tier: tier, seed: seed,
        stem: 'Berapakah $a + $b?', hint: 'Jumlahkan dari satuan.',
        correct: '$ans', wrong: [['${ans - 1}', ''], ['${ans + 1}', ''], ['${ans + 10}', '']],
        steps: ['$a + $b = $ans.'], pitfall: 'Salah menyimpan puluhan saat menjumlah satuan.');
    }
    case 'ar_pengurangan': {
      final m = [20, 200, 2000, 5000][tier - 1];
      var a = 5 + R.nextInt(m), b = 2 + R.nextInt(m);
      if (b > a) { final t = a; a = b; b = t; }
      final ans = a - b;
      return _mk(topicId: topicId, tier: tier, seed: seed,
        stem: tier == 4 ? 'Selisih pengunjung hari Sabtu ($a orang) dan Minggu ($b orang)?' : 'Berapakah $a − $b?',
        hint: 'Pinjam 10 bila angka atas lebih kecil.', correct: '$ans',
        wrong: [['${ans - 1}', ''], ['${ans + 1}', ''], ['${ans + 10}', '']],
        steps: ['$a − $b = $ans.'], pitfall: 'Lupa mengurangi 1 setelah meminjam puluhan.');
    }
    case 'ar_perkalian': {
      int a, b;
      if (tier == 1) { a = 1 + R.nextInt(10); b = 1 + R.nextInt(10); }
      else if (tier == 2) { a = 11 + R.nextInt(89); b = 2 + R.nextInt(8); }
      else if (tier == 3) { a = 11 + R.nextInt(89); b = 11 + R.nextInt(20); }
      else { a = 12 + R.nextInt(40); b = 12 + R.nextInt(40); }
      final ans = a * b;
      return _mk(topicId: topicId, tier: tier, seed: seed,
        stem: 'Berapakah $a × $b?', hint: 'Kalikan per nilai tempat lalu jumlahkan.',
        correct: '$ans', wrong: [['${ans - b}', ''], ['${ans + b}', ''], ['${ans + 10}', '']],
        steps: tier <= 2 ? ['$a × $b = $ans.'] : ['$a × ${b % 10} = ${a * (b % 10)}, $a × ${b - b % 10} = ${a * (b - b % 10)}.', 'Jumlah = $ans.'],
        pitfall: 'Salah menempatkan nilai tempat puluhan.');
    }
    case 'ar_pembagian': {
      final b = 2 + R.nextInt(5 + tier * 3);
      final q = 3 + R.nextInt(6 + tier * 6);
      final a = b * q;
      return _mk(topicId: topicId, tier: tier, seed: seed,
        stem: 'Berapakah $a ÷ $b?', hint: 'Ingat: $b × … = $a.',
        correct: '$q', wrong: [['${q - 1}', ''], ['${q + 1}', ''], ['${q + 2}', '']],
        steps: ['$b × $q = $a, jadi $a ÷ $b = $q.'], pitfall: 'Tertukar dengan ${q - 1} (kurang satu kelipatan $b).');
    }
    case 'ar_campuran': {
      final a = 2 + R.nextInt(8 + tier * 5);
      final b = 2 + R.nextInt(8 + tier * 5);
      final c = 2 + R.nextInt(8 + tier * 5);
      if (tier == 1) {
        final ans = a + b * c;
        return _mk(topicId: topicId, tier: tier, seed: seed,
          stem: 'Berapakah $a + $b × $c?', hint: 'Kali dulu, baru tambah.',
          correct: '$ans', wrong: [['${(a + b) * c}', ''], ['${ans + 2}', ''], ['${ans - 2}', '']],
          steps: ['$b × $c = ${b * c}.', '$a + ${b * c} = $ans.'],
          pitfall: 'Menjumlah dulu (${(a + b) * c}) adalah jebakan urutan operasi.');
      }
      if (tier == 2) {
        final ans = (a + b) * c;
        return _mk(topicId: topicId, tier: tier, seed: seed,
          stem: 'Berapakah ($a + $b) × $c?', hint: 'Kurung dikerjakan paling dulu.',
          correct: '$ans', wrong: [['${a + b * c}', ''], ['${ans + c}', ''], ['${ans - c}', '']],
          steps: ['$a + $b = ${a + b}.', '${a + b} × $c = $ans.'], pitfall: 'Mengabaikan tanda kurung.');
      }
      final d = 2 + R.nextInt(6);
      final e = d * (2 + R.nextInt(6));
      final ans = (a + b) * c - e ~/ d;
      return _mk(topicId: topicId, tier: tier, seed: seed,
        stem: 'Berapakah ($a + $b) × $c − $e ÷ $d?', hint: 'Kurung → kali/bagi → kurang.',
        correct: '$ans', wrong: [['${ans + 5}', ''], ['${ans - 5}', ''], ['${(a + b) * (c - e) ~/ d}', '']],
        steps: ['($a + $b) = ${a + b}; ${a + b} × $c = ${(a + b) * c}.', '$e ÷ $d = ${e ~/ d}; ${(a + b) * c} − ${e ~/ d} = $ans.'],
        pitfall: 'Mengerjakan strictly kiri-ke-kanan tanpa urutan operasi.');
    }
    case 'ar_pecahan': {
      if (tier == 1) {
        final f = 2 + R.nextInt(4);
        final p = (2 + R.nextInt(5)) * f, q = (3 + R.nextInt(5)) * f;
        final g = _fpb(p, q);
        return _mk(topicId: topicId, tier: tier, seed: seed,
          stem: 'Bentuk paling sederhana dari $p/$q?', hint: 'Bagi dengan FPB = $g.',
          correct: '${p ~/ g}/${q ~/ g}', correctSub: 'tersederhana',
          wrong: [['$p/$q', 'belum sederhana'], ['${p ~/ 2}/${q ~/ 2}', 'belum sederhana'], ['${p ~/ g + 1}/${q ~/ g}', '']],
          steps: ['FPB($p, $q) = $g.', '$p ÷ $g = ${p ~/ g}, $q ÷ $g = ${q ~/ g}.'],
          pitfall: 'Berhenti di ${p ~/ 2}/${q ~/ 2} (baru dibagi 2, bukan FPB).');
      }
      if (tier == 2) {
        final c = 4 + R.nextInt(6);
        final a = 1 + R.nextInt(c - 1), b = 1 + R.nextInt(c - 1);
        final s = a + b;
        return _mk(topicId: topicId, tier: tier, seed: seed,
          stem: 'Berapakah $a/$c + $b/$c?', hint: 'Penyebut sama: jumlahkan pembilang.',
          correct: '$s/$c', wrong: [['$s/${c * 2}', ''], ['${s + 1}/$c', ''], ['$a/${c + b}', '']],
          steps: ['($a + $b)/$c = $s/$c.'], pitfall: 'Ikut menjumlahkan penyebut.');
      }
      if (tier == 3) {
        return _mk(topicId: topicId, tier: tier, seed: seed,
          stem: 'Berapakah 1/2 + 1/3 + 1/6 dalam pecahan paling sederhana?',
          hint: 'Samakan penyebut ke 6.', correct: '1', correctSub: 'utuh',
          wrong: [['3/6', ''], ['5/6', ''], ['3/11', '']],
          steps: ['3/6 + 2/6 + 1/6 = 6/6 = 1.'], pitfall: 'Menjumlahkan pembilang dan penyebut sekaligus (3/11).');
      }
      final vals = ['0,25', '0,5', '0,75', '1,25'];
      final v = vals[R.nextInt(vals.length)];
      final pct = {'0,25': '25%', '0,5': '50%', '0,75': '75%', '1,25': '125%'}[v]!;
      return _mk(topicId: topicId, tier: tier, seed: seed,
        stem: 'Desimal $v sama dengan … persen?', hint: 'Kali 100, tambah simbol %.',
        correct: pct, wrong: [['${pct.replaceAll('%', '')}‰', ''], ['${int.parse(pct.replaceAll('%', '')) ~/ 10}%', ''], ['${int.parse(pct.replaceAll('%', '')) * 10}%', '']],
        steps: ['$v × 100% = $pct.'], pitfall: 'Lupa menggeser koma dua digit.');
    }

    // ================= ALJABAR =================
    case 'al_sederhana': {
      final a = 2 + R.nextInt(5 + tier * 3);
      final b = 2 + R.nextInt(5 + tier * 3);
      final c = 1 + R.nextInt(3 + tier * 2);
      if (tier >= 3) {
        final ans = a + b;
        return _mk(topicId: topicId, tier: tier, seed: seed,
          stem: 'Sederhanakan: ${a}x + $c + ${b}x − $c.',
          hint: 'Kelompokkan suku x dan konstanta.', correct: '${ans}x',
          wrong: [['${ans}x + $c', ''], ['${ans + 1}x', ''], ['${a + b + c}x', '']],
          steps: ['${a}x + ${b}x = ${ans}x.', '$c − $c = 0 → ${ans}x.'], pitfall: 'Menjumlahkan konstanta ke koefisien x.');
      }
      final ans = a + b - c;
      return _mk(topicId: topicId, tier: tier, seed: seed,
        stem: 'Sederhanakan: ${a}x + ${b}x − ${c}x.', hint: 'Jumlahkan koefisiennya.',
        correct: '${ans}x', wrong: [['${ans + 1}x', ''], ['${ans - 1}x', ''], ['${a + b + c}x', '']],
        steps: ['$a + $b − $c = $ans → ${ans}x.'], pitfall: 'Hanya menjumlah tanpa mengurang suku negatif.');
    }
    case 'al_nilai_x': {
      final m = 2 + R.nextInt(3 + tier * 2);
      final x = 2 + R.nextInt(4 + tier * 3);
      final c = R.nextInt(8 + tier * 4);
      final rhs = m * x + c;
      return _mk(topicId: topicId, tier: tier, seed: seed,
        stem: 'Tentukan x dari ${m}x + $c = $rhs.', hint: 'Kurangkan $c, lalu bagi $m.',
        correct: '$x', wrong: [['${x - 1}', ''], ['${x + 1}', ''], ['${x + 2}', '']],
        steps: ['${m}x = $rhs − $c = ${rhs - c}.', 'x = ${rhs - c} ÷ $m = $x.'],
        pitfall: 'Lupa membagi konstanta dengan $m.');
    }
    case 'al_koordinat': {
      if (tier == 1) {
        final sx = R.nextBool() ? 1 : -1, sy = R.nextBool() ? 1 : -1;
        final a = sx * (1 + R.nextInt(6)), b = sy * (1 + R.nextInt(6));
        final kuad = sx > 0 ? (sy > 0 ? 'I' : 'IV') : (sy > 0 ? 'II' : 'III');
        final opts = ['I', 'II', 'III', 'IV'];
        return _mk(topicId: topicId, tier: tier, seed: seed,
          stem: 'Titik ($a, $b) terletak di kuadran …', hint: 'Lihat tanda x dan y.',
          correct: kuad, correctSub: 'kuadran',
          wrong: opts.where((o) => o != kuad).map((o) => [o, 'kuadran']).toList(),
          steps: ['x ${sx > 0 ? 'positif' : 'negatif'}, y ${sy > 0 ? 'positif' : 'negatif'} → kuadran $kuad.'],
          pitfall: 'Tertukar urutan x dan y.');
      }
      if (tier == 2) {
        final m = 1 + R.nextInt(4), c = 1 + R.nextInt(6);
        return _mk(topicId: topicId, tier: tier, seed: seed,
          stem: 'Garis y = ${m}x + $c memotong sumbu Y di titik …',
          hint: 'Potongan Y terjadi saat x = 0.', correct: '(0, $c)',
          wrong: [['($c, 0)', ''], ['(0, ${c + m})', ''], ['($m, $c)', '']],
          steps: ['x = 0 → y = $c → (0, $c).'], pitfall: 'Tertukar dengan potongan sumbu X.');
      }
      if (tier == 3) {
        final x1 = R.nextInt(6), y1 = R.nextInt(6);
        final dx = 1 + R.nextInt(4), dy = 1 + R.nextInt(4);
        return _mk(topicId: topicId, tier: tier, seed: seed,
          stem: 'Gradien garis melalui ($x1, $y1) dan (${x1 + dx}, ${y1 + dy})?',
          hint: 'm = Δy / Δx.', correct: '$dy/$dx',
          wrong: [['$dx/$dy', ''], ['${dy + 1}/$dx', ''], ['$dy/${dx + 1}', '']],
          steps: ['Δy = $dy, Δx = $dx → m = $dy/$dx.'], pitfall: 'Membalik Δx dan Δy.');
      }
      final x1 = R.nextInt(8), y1 = R.nextInt(8);
      final x2 = x1 + 2 + R.nextInt(4), y2 = y1 + 2 + R.nextInt(4);
      return _mk(topicId: topicId, tier: tier, seed: seed,
        stem: 'Titik tengah ($x1, $y1) dan ($x2, $y2)?', hint: 'Rata-ratakan x dan y.',
        correct: '(${(x1 + x2) ~/ 2}, ${(y1 + y2) ~/ 2})',
        wrong: [['($x1, $y1)', ''], ['($x2, $y2)', ''], ['${x1 + x2}, ${y1 + y2}', '']],
        steps: ['x: ($x1+$x2)/2 = ${(x1 + x2) ~/ 2}, y: ($y1+$y2)/2 = ${(y1 + y2) ~/ 2}.'],
        pitfall: 'Lupa membagi dua setelah menjumlah.');
    }
    case 'al_faktor': {
      final p = 1 + R.nextInt(3 + tier * 2), q = 2 + R.nextInt(4 + tier * 2);
      return _mk(topicId: topicId, tier: tier, seed: seed,
        stem: 'Faktorkan: x² + ${p + q}x + ${p * q}.', hint: 'Cari p+q=${p + q}, p×q=${p * q}.',
        correct: '(x + $p)(x + $q)',
        wrong: [['(x + ${p + 1})(x + ${q - 1})', ''], ['(x + $p)(x − $q)', ''], ['(x − $p)(x − $q)', '']],
        steps: ['$p + $q = ${p + q}, $p × $q = ${p * q}.', 'Jadi (x + $p)(x + $q).'],
        pitfall: 'Salah tanda: hasil kali positif belum tentu keduanya positif — cek jumlahnya.');
    }
    case 'al_pertidaksamaan': {
      final m = 2 + R.nextInt(3 + tier);
      final x0 = 2 + R.nextInt(3 + tier * 2);
      final c = R.nextInt(8);
      final rhs = m * x0 + c;
      return _mk(topicId: topicId, tier: tier, seed: seed,
        stem: 'Himpunan penyelesaian ${m}x + $c > $rhs?', hint: 'Selesaikan seperti persamaan.',
        correct: 'x > $x0', wrong: [['x < $x0', ''], ['x ≥ ${x0 + 1}', ''], ['x > ${x0 + 1}', '']],
        steps: ['${m}x > $rhs − $c = ${rhs - c}.', 'x > ${rhs - c} ÷ $m = $x0.'],
        pitfall: 'Membalik tanda padahal tidak dikali/dibagi negatif.');
    }
    case 'al_persamaan': {
      final a = 2 + R.nextInt(3 + tier), b = R.nextInt(8);
      final c = 1 + R.nextInt(a - 1 + tier);
      final x = 2 + R.nextInt(3 + tier * 2);
      final d = (a - c) * x + b;
      return _mk(topicId: topicId, tier: tier, seed: seed,
        stem: 'Tentukan x dari ${a}x + $b = ${c}x + $d.', hint: 'Kumpulkan x di kiri.',
        correct: '$x', wrong: [['${x - 1}', ''], ['${x + 1}', ''], ['${x + 2}', '']],
        steps: ['${a - c}x = $d − $b = ${d - b}.', 'x = ${d - b} ÷ ${a - c} = $x.'],
        pitfall: 'Salah tanda saat memindah ${c}x ke kiri.');
    }
    case 'al_polinomial': {
      if (tier <= 2) {
        final a = 1 + R.nextInt(3 + tier), b = R.nextInt(6), c = 1 + R.nextInt(3), d = R.nextInt(6);
        final e = a + (tier == 2 ? c : 0), f = b + (tier == 2 ? 0 : 0);
        if (tier == 1) {
          return _mk(topicId: topicId, tier: tier, seed: seed,
            stem: 'Jumlahkan: (${a}x² + ${b}x) + (${c}x² + ${d}x).', hint: 'Gabungkan suku sejenis.',
            correct: '${a + c}x² + ${b + d}x',
            wrong: [['${a + c}x² + ${b + d}x²', ''], ['${a * c}x² + ${b + d}x', ''], ['${a + c}x + ${b + d}', '']],
            steps: ['x²: $a + $c = ${a + c}. x: $b + $d = ${b + d}.'], pitfall: 'Menjumlahkan pangkat ikut berubah.');
        }
        return _mk(topicId: topicId, tier: tier, seed: seed,
          stem: 'Derajat polinomial ${e}x³ + ${f}x + 7?', hint: 'Derajat = pangkat tertinggi.',
          correct: '3', wrong: [['2', ''], ['1', ''], ['${e + f + 7}', '']],
          steps: ['Pangkat tertinggi adalah 3.'], pitfall: 'Menjumlahkan semua pangkat/koefisien.');
      }
      final p = 1 + R.nextInt(4), q = 2 + R.nextInt(4);
      return _mk(topicId: topicId, tier: tier, seed: seed,
        stem: 'Jabarkan: (x + $p)(x + $q).', hint: 'Kali satu-satu (PLDT).',
        correct: 'x² + ${p + q}x + ${p * q}',
        wrong: [['x² + ${p * q}x + ${p + q}', ''], ['x² + ${p + q}x', ''], ['2x + ${p + q}', '']],
        steps: ['x·x + x·$q + $p·x + $p·$q.', '= x² + ${p + q}x + ${p * q}.'], pitfall: 'Lupa mengalikan konstanta $p × $q.');
    }
    case 'al_logika': {
      final pv = R.nextBool(), qv = R.nextBool();
      final ps = _b(pv), qs = _b(qv);
      final vals = <String, bool>{
        'p ∧ q': pv && qv,
        'p ∨ q': pv || qv,
        '¬p': !pv,
        'p → q': !pv || qv,
      };
      final trues =
          vals.entries.where((e) => e.value).map((e) => e.key).toList();
      final falses =
          vals.entries.where((e) => !e.value).map((e) => e.key).toList();
      if (trues.length == 1) {
        return _mk(topicId: topicId, tier: tier, seed: seed,
          stem: 'p $ps, q $qs. Manakah pernyataan yang BENAR?',
          hint: 'Uji tiap operator satu per satu.',
          correct: trues.first, correctSub: 'benar',
          wrong: [for (final f in falses) [f, 'salah']],
          steps: [
            'p∧q=${_b(pv && qv)}, p∨q=${_b(pv || qv)}.',
            '¬p=${_b(!pv)}, p→q=${_b(!pv || qv)}.',
          ],
          pitfall: 'Implikasi (→) salah hanya bila benar → salah.');
      }
      if (falses.length == 1) {
        return _mk(topicId: topicId, tier: tier, seed: seed,
          stem: 'p $ps, q $qs. Manakah pernyataan yang SALAH?',
          hint: 'Tiga di antaranya benar — cari pengecualiannya.',
          correct: falses.first, correctSub: 'salah',
          wrong: [for (final f in trues) [f, 'benar']],
          steps: [
            'p∧q=${_b(pv && qv)}, p∨q=${_b(pv || qv)}.',
            '¬p=${_b(!pv)}, p→q=${_b(!pv || qv)}.',
          ],
          pitfall: 'Jangan terkecoh operator yang terlihat meyakinkan.');
      }
      return generateDynamic(topicId, tier, seed + 1);
    }
    case 'al_kuadrat': {
      final r1 = 1 + R.nextInt(2 + tier * 2), r2 = 2 + R.nextInt(3 + tier * 2);
      if (tier <= 2) {
        return _mk(topicId: topicId, tier: tier, seed: seed,
          stem: 'Akar-akar x² − ${r1 + r2}x + ${r1 * r2} = 0?', hint: 'Faktorkan ke (x−…)(x−…).',
          correct: 'x = $r1 atau x = $r2',
          wrong: [['x = ${-r1} atau x = ${-r2}', ''], ['x = $r1 atau x = ${r2 + 1}', ''], ['x = ${r1 + r2}', '']],
          steps: ['(x−$r1)(x−$r2) = 0.', 'x = $r1 atau x = $r2.'], pitfall: 'Lupa tanda negatif pada faktor.');
      }
      if (tier == 3) {
        final D = (r1 - r2) * (r1 - r2);
        return _mk(topicId: topicId, tier: tier, seed: seed,
          stem: 'Diskriminan x² − ${r1 + r2}x + ${r1 * r2} = 0?', hint: 'D = b² − 4ac.',
          correct: '$D', correctSub: D > 0 ? 'dua akar real' : 'kembar',
          wrong: [['${D + 4}', ''], ['${D - 4}', ''], ['${(r1 + r2) * (r1 + r2)}', '']],
          steps: ['D = ${r1 + r2}² − 4×${r1 * r2} = $D.'], pitfall: 'Lupa mengalikan 4ac.');
      }
      return _mk(topicId: topicId, tier: tier, seed: seed,
        stem: 'Jika akarnya $r1 dan $r2, jumlah dan hasil kalinya?', hint: 'Jumlah = −b/a, kali = c/a.',
        correct: '${r1 + r2} dan ${r1 * r2}',
        wrong: [['${r1 * r2} dan ${r1 + r2}', ''], ['${r1 + r2 + 1} dan ${r1 * r2}', ''], ['${r1 - r2} dan ${r1 * r2}', '']],
        steps: ['Jumlah = $r1+$r2 = ${r1 + r2}. Kali = $r1×$r2 = ${r1 * r2}.'], pitfall: 'Tertukar jumlah dan hasil kali.');
    }
    case 'al_sifat': {
      final m = 2 + R.nextInt(3 + tier), n = 2 + R.nextInt(3 + tier);
      if (tier <= 2) {
        return _mk(topicId: topicId, tier: tier, seed: seed,
          stem: 'Sederhanakan: 2^$m × 2^$n.', hint: 'Basis sama: pangkat dijumlah.',
          correct: '2^${m + n}', correctSub: '= ${1 << (m + n)}',
          wrong: [['2^${m * n}', ''], ['4^${m + n}', ''], ['2^${m + n + 1}', '']],
          steps: ['2^$m × 2^$n = 2^${m + n} = ${1 << (m + n)}.'], pitfall: 'Mengalikan pangkatnya (2^${m * n}).');
      }
      return _mk(topicId: topicId, tier: tier, seed: seed,
        stem: 'Sederhanakan: (3^$m)^$n.', hint: 'Pangkat dari pangkat: dikalikan.',
        correct: '3^${m * n}',
        wrong: [['3^${m + n}', ''], ['9^${m * n}', ''], ['3^${m * n + 1}', '']],
        steps: ['(3^$m)^$n = 3^${m * n}.'], pitfall: 'Menjumlah pangkat padahal harus dikali.');
    }
    case 'al_spldv': {
      final x = 1 + R.nextInt(3 + tier * 2), y = 1 + R.nextInt(3 + tier * 2);
      final s1 = x + y;
      final rhsA = 2 * x + y;
      return _mk(topicId: topicId, tier: tier, seed: seed,
        stem: 'Selesaikan: x + y = $s1 dan 2x + y = $rhsA. Nilai x dan y?',
        hint: 'Kurangkan persamaan kedua dengan pertama.', correct: 'x = $x, y = $y',
        wrong: [['x = ${x + 1}, y = ${y - 1}', ''], ['x = $y, y = $x', ''], ['x = ${x - 1}, y = ${y + 1}', '']],
        steps: ['(2x+y) − (x+y) = $rhsA − $s1 → x = $x.', 'y = $s1 − $x = $y.'],
        pitfall: 'Salah mengurang (tanda y ikut berubah).');
    }
    case 'al_spltv': {
      final x = 1 + R.nextInt(3), y = 1 + R.nextInt(3), z = 1 + R.nextInt(3);
      final s1 = x + y + z, s2 = 2 * x + y + z;
      return _mk(topicId: topicId, tier: tier, seed: seed,
        stem: 'Diketahui x+y+z = $s1 dan 2x+y+z = $s2. Nilai x?',
        hint: 'Kurangkan persamaan kedua dengan pertama.', correct: '$x',
        wrong: [['${x + 1}', ''], ['${x - 1}', ''], ['$y', '']],
        steps: ['(2x+y+z) − (x+y+z) = $s2 − $s1.', 'x = ${s2 - s1} = $x.'], pitfall: 'Mencoba substitusi panjang padahal cukup eliminasi.');
    }

    // ================= FUNGSI =================
    case 'fn_linear': {
      final m = 1 + R.nextInt(3 + tier * 2);
      final c = R.nextInt(5 + tier * 3) * (R.nextBool() ? 1 : -1);
      final a = 2 + R.nextInt(3 + tier * 3);
      final ans = m * a + c;
      final cs = c >= 0 ? '+ $c' : '− ${-c}';
      return _mk(topicId: topicId, tier: tier, seed: seed,
        stem: 'f(x) = ${m}x $cs. Nilai f($a)?', hint: 'Ganti x dengan $a.',
        correct: '$ans', wrong: [['${ans + m}', ''], ['${ans - m}', ''], ['${m * a}', '']],
        steps: ['f($a) = $m×$a ${c >= 0 ? '+' : '−'} ${c.abs()} = $ans.'], pitfall: 'Lupa menambahkan konstanta $c.');
    }
    case 'fn_aljabar': {
      final a = 2 + R.nextInt(2 + tier * 2);
      final b = 1 + R.nextInt(4 + tier * 2), c = R.nextInt(6);
      final ans = a * a - b * a + c;
      return _mk(topicId: topicId, tier: tier, seed: seed,
        stem: 'f(x) = x² − ${b}x + $c. Nilai f($a)?', hint: 'Hitung pangkat dulu.',
        correct: '$ans', wrong: [['${ans + a}', ''], ['${ans - a}', ''], ['${a * a}', '']],
        steps: ['$a² = ${a * a}; $b×$a = ${b * a}.', '${a * a} − ${b * a} + $c = $ans.'],
        pitfall: 'Menghitung $a² sebagai ${a * 2}.');
    }
    case 'fn_grafik': {
      final m = 1 + R.nextInt(3 + tier), c = 1 + R.nextInt(5 + tier);
      if (tier <= 2) {
        return _mk(topicId: topicId, tier: tier, seed: seed,
          stem: 'Grafik y = ${m}x + $c memotong sumbu Y di …', hint: 'Potongan Y: x = 0.',
          correct: '(0, $c)', wrong: [['($c, 0)', ''], ['(0, ${c + m})', ''], ['($m, $c)', '']],
          steps: ['x=0 → y=$c → (0, $c).'], pitfall: 'Tertukar dengan potongan sumbu X.');
      }
      final m2 = m + 1 + R.nextInt(3);
      return _mk(topicId: topicId, tier: tier, seed: seed,
        stem: 'Garis yang SEJAJAR y = ${m}x + $c bergradien …', hint: 'Sejajar → gradien sama.',
        correct: '$m', wrong: [['$m2', ''], ['${-m}', ''], ['1/$m', '']],
        steps: ['Gradien garis acuan = $m, garis sejajar sama.'], pitfall: 'Sejajar disangka gradien berkebalikan.');
    }
    case 'fn_titik': {
      final m = 1 + R.nextInt(3 + tier), c = R.nextInt(5 + tier);
      final a = 1 + R.nextInt(4 + tier * 2);
      final b = m * a + c;
      return _mk(topicId: topicId, tier: tier, seed: seed,
        stem: 'Titik berikut yang terletak pada y = ${m}x + $c?', hint: 'Uji: masukkan x, cocokkan y.',
        correct: '($a, $b)',
        wrong: [['($a, ${b + 1})', ''], ['(${a + 1}, $b)', ''], ['($a, ${b - m})', '']],
        steps: ['x=$a → y = $m×$a+$c = $b. Cocok!'], pitfall: 'Hanya menebak tanpa substitusi.');
    }
    case 'fn_invers': {
      if (tier == 1) {
        final c = 2 + R.nextInt(8);
        return _mk(topicId: topicId, tier: tier, seed: seed,
          stem: 'Invers dari f(x) = x + $c?', hint: 'Balikkan tambah jadi kurang.',
          correct: 'x − $c', wrong: [['x + $c', ''], ['−x + $c', ''], ['$c − x', '']],
          steps: ['y = x + $c → x = y − $c → f⁻¹(x) = x − $c.'], pitfall: 'Tanda tidak dibalik.');
      }
      if (tier == 2) {
        final m = 2 + R.nextInt(3), c = 1 + R.nextInt(5);
        return _mk(topicId: topicId, tier: tier, seed: seed,
          stem: 'Invers dari f(x) = ${m}x + $c?', hint: 'y=${m}x+$c → x=(y−$c)/$m.',
          correct: '(x − $c)/$m',
          wrong: [['(x + $c)/$m', ''], ['$m(x − $c)', ''], ['x/$m + $c', '']],
          steps: ['Tukar: x = ${m}y + $c → y = (x−$c)/$m.'], pitfall: 'Lupa membagi konstanta dengan $m.');
      }
      final m = 2 + R.nextInt(2), c = 1 + R.nextInt(4);
      return _mk(topicId: topicId, tier: tier, seed: seed,
        stem: 'f(x) = (x − $c)/$m. Inversnya?', hint: 'Kalikan $m lalu tambah $c.',
        correct: '${m}x + $c', wrong: [['${m}x − $c', ''], ['x/$m + $c', ''], ['(x + $c)/$m', '']],
        steps: ['y=(x−$c)/$m → x = ${m}y+$c → f⁻¹(x) = ${m}x+$c.'], pitfall: 'Urutan operasi invers terbalik.');
    }
    case 'fn_komposisi': {
      final m1 = 2 + R.nextInt(2 + tier), c1 = R.nextInt(4);
      final m2 = 1 + R.nextInt(2 + tier), c2 = R.nextInt(4);
      final a = 1 + R.nextInt(2 + tier * 2);
      final inner = m2 * a + c2, ans = m1 * inner + c1;
      return _mk(topicId: topicId, tier: tier, seed: seed,
        stem: 'f(x)=${m1}x+$c1, g(x)=${m2}x+$c2. Nilai (f∘g)($a)?',
        hint: 'Hitung g($a) dulu, masukkan ke f.',
        correct: '$ans', wrong: [['${ans + m1}', ''], ['${ans - m1}', ''], ['${m1 * a + c1}', '']],
        steps: ['g($a) = $inner.', 'f($inner) = $ans.'], pitfall: 'Menghitung (g∘f) padahal diminta (f∘g).');
    }

    // ================= TRIGONOMETRI =================
    case 'tr_dasar': {
      final opts = [
        ['90°', 'π/2'], ['60°', 'π/3'], ['45°', 'π/4'], ['30°', 'π/6'], ['180°', 'π'],
      ];
      final pick = opts[R.nextInt(opts.length)];
      final others = opts.where((o) => o[0] != pick[0]).toList()..shuffle(R);
      return _mk(topicId: topicId, tier: tier, seed: seed,
        stem: 'Sudut ${pick[0]} sama dengan … radian?', hint: '180° = π.',
        correct: pick[1], wrong: others.take(3).map((o) => [o[1], 'rad']).toList(),
        steps: ['${pick[0]} × π/180 = ${pick[1]}.'], pitfall: 'Tertukar pembilang-penyebut pecahan π.');
    }
    case 'tr_rasio': {
      final triples = [
        [3, 4, 5], [5, 12, 13], [6, 8, 10], [9, 12, 15],
      ];
      final t = triples[R.nextInt(triples.length)];
      final kind = R.nextInt(3);
      final label = ['sin θ', 'cos θ', 'tan θ'][kind];
      final val = [ '${t[0]}/${t[2]}', '${t[1]}/${t[2]}', '${t[0]}/${t[1]}'][kind];
      final depan = t[0], samping = t[1], miring = t[2];
      return _mk(topicId: topicId, tier: tier, seed: seed,
        stem: 'Segitiga siku-siku: depan=$depan, samping=$samping, miring=$miring. Nilai $label?',
        hint: kind == 0 ? 'sin = depan/miring.' : kind == 1 ? 'cos = samping/miring.' : 'tan = depan/samping.',
        correct: val,
        wrong: kind == 0
            ? [['$samping/$miring', ''], ['$depan/$samping', ''], ['$miring/$depan', '']]
            : kind == 1
                ? [['$depan/$miring', ''], ['$samping/$depan', ''], ['$miring/$samping', '']]
                : [['$samping/$depan', ''], ['$depan/$miring', ''], ['$samping/$miring', '']],
        steps: ['$label = $val.'], pitfall: 'Tertukar depan dan samping.');
    }
    case 'tr_identitas': {
      final triples = [
        [3, 4, 5], [5, 12, 13], [8, 15, 17],
      ];
      final t = triples[R.nextInt(triples.length)];
      return _mk(topicId: topicId, tier: tier, seed: seed,
        stem: 'Jika sin θ = ${t[0]}/${t[2]} (lancip), cos θ = …?',
        hint: 'sin² + cos² = 1.', correct: '${t[1]}/${t[2]}',
        wrong: [['${t[0]}/${t[1]}', ''], ['${t[2]}/${t[1]}', ''], ['${t[1] - 1}/${t[2]}', '']],
        steps: ['cos θ = √((1 − ${t[0]}²/${t[2]}²)) = ${t[1]}/${t[2]}.'], pitfall: 'Menjawab tan sebagai cos.');
    }
    case 'tr_persamaan': {
      final sols = ['30° dan 150°', '45° dan 315°', '60° dan 120°', '0° dan 180°'];
      final eqs = ['sin x = 1/2', 'cos x = √2/2', 'sin x = √3/2', 'tan x = 0'];
      final i = R.nextInt(sols.length);
      final others = List.of(sols)..removeAt(i)..shuffle(R);
      return _mk(topicId: topicId, tier: tier, seed: seed,
        stem: 'Himpunan ${eqs[i]} untuk 0° ≤ x ≤ 360°?', hint: 'Cari sudut acuan lalu cerminkan.',
        correct: sols[i], wrong: others.take(3).map((o) => [o, '']).toList(),
        steps: ['Sudut acuan memenuhi, cerminkan ke kuadran bertanda sama → ${sols[i]}.'],
        pitfall: 'Hanya mengambil satu sudut, lupa pasangannya.');
    }
    case 'tr_invers': {
      final items = [
        ['arcsin 1', '90°'], ['arccos 0', '90°'], ['arctan 1', '45°'], ['arcsin 1/2', '30°'], ['arccos 1/2', '60°'],
      ];
      final pick = items[R.nextInt(items.length)];
      final others = items.where((o) => o[1] != pick[1]).toList()..shuffle(R);
      return _mk(topicId: topicId, tier: tier, seed: seed,
        stem: 'Nilai ${pick[0]}?', hint: 'Sudut berapa yang rasionya demikian?',
        correct: pick[1], wrong: others.take(3).map((o) => [o[1], '']).toList(),
        steps: ['${pick[0]} = ${pick[1]}.'], pitfall: 'Menjawab dalam radian saat diminta derajat.');
    }

    // ================= GEOMETRI =================
    case 'ge_sudut': {
      final a = 30 + R.nextInt(40 + tier * 10), b = 30 + R.nextInt(40 + tier * 10);
      final x = 180 - a - b;
      if (x <= 10) return generateDynamic(topicId, tier, seed + 1);
      return _mk(topicId: topicId, tier: tier, seed: seed,
        stem: 'Dua sudut segitiga $a° dan $b°. Sudut ketiga (x)?', hint: 'Jumlah = 180°.',
        correct: '$x°', wrong: [['${x + 10}°', ''], ['${x - 10}°', ''], ['${a + b}°', '']],
        steps: ['x = 180° − $a° − $b° = $x°.'], pitfall: 'Menjawab $a+$b tanpa mengurang dari 180°.');
    }
    case 'ge_pythagoras': {
      final triples = [
        [3, 4, 5], [5, 12, 13], [6, 8, 10], [9, 12, 15], [8, 15, 17], [7, 24, 25],
      ];
      final t = triples[R.nextInt(min(triples.length, 2 + tier * 2))];
      final askLeg = tier >= 3 && R.nextBool();
      if (askLeg) {
        return _mk(topicId: topicId, tier: tier, seed: seed,
          stem: 'Sisi miring ${t[2]}, satu sisi siku ${t[0]}. Sisi siku lain?',
          hint: 'a = √(c² − b²).', correct: '${t[1]}',
          wrong: [['${t[1] + 1}', ''], ['${t[1] - 1}', ''], ['${t[0]}', '']],
          steps: ['√(${t[2]}² − ${t[0]}²) = √${t[1] * t[1]} = ${t[1]}.'], pitfall: 'Menjumlah bukan mengurang kuadratnya.');
      }
      return _mk(topicId: topicId, tier: tier, seed: seed,
        stem: 'Sisi siku-siku ${t[0]} dan ${t[1]}. Sisi miring?', hint: 'c² = a² + b².',
        correct: '${t[2]}', wrong: [['${t[2] - 1}', ''], ['${t[2] + 1}', ''], ['${t[0] + t[1]}', '']],
        steps: ['c² = ${t[0] * t[0]} + ${t[1] * t[1]} = ${t[2] * t[2]} → c = ${t[2]}.'],
        pitfall: 'Menjumlah sisi tanpa menguadratkan (${t[0] + t[1]}).');
    }
    case 'ge_lingkaran': {
      final k = 1 + R.nextInt(2 + tier);
      final r = 7 * k;
      if (tier <= 2) {
        return _mk(topicId: topicId, tier: tier, seed: seed,
          stem: 'Keliling lingkaran r = $r (π = 22/7)?', hint: 'K = 2πr.',
          correct: '${2 * 22 * k}', wrong: [['${2 * 22 * k + 7}', ''], ['${22 * k * k}', ''], ['${2 * 22 * k - 7}', '']],
          steps: ['K = 2 × 22/7 × $r = ${2 * 22 * k}.'], pitfall: 'Tertukar dengan rumus luas.');
      }
      if (tier == 3) {
        return _mk(topicId: topicId, tier: tier, seed: seed,
          stem: 'Luas lingkaran r = $r (π = 22/7)?', hint: 'L = πr².',
          correct: '${22 * k * r}', wrong: [['${2 * 22 * k}', ''], ['${22 * k * r + r}', ''], ['${11 * k * r}', '']],
          steps: ['L = 22/7 × $r × $r = ${22 * k * r}.'], pitfall: 'Lupa menguadratkan jari-jari.');
      }
      final sudut = [60, 90, 120][R.nextInt(3)];
      final busur = 2 * 22 * k * sudut ~/ 360;
      return _mk(topicId: topicId, tier: tier, seed: seed,
        stem: 'Panjang busur $sudut° lingkaran r = $r (π = 22/7)?',
        hint: 'Busur = sudut/360 × keliling.', correct: '$busur',
        wrong: [['${busur + 5}', ''], ['${2 * 22 * k}', ''], ['${busur ~/ 2}', '']],
        steps: ['$sudut/360 × ${2 * 22 * k} = $busur.'], pitfall: 'Lupa mengalikan fraksi sudut.');
    }
    case 'ge_sincos': {
      final miring = [10, 12, 20][R.nextInt(3)];
      final sudut = R.nextBool() ? 30 : 60;
      if (sudut == 30) {
        final d = miring ~/ 2;
        return _mk(topicId: topicId, tier: tier, seed: seed,
          stem: 'Sisi miring $miring, sudut 30°. Sisi depan sudut?', hint: 'sin 30° = 1/2.',
          correct: '$d', wrong: [['${d + 1}', ''], ['$miring', ''], ['${d * 2}', '']],
          steps: ['depan = $miring × 1/2 = $d.'], pitfall: 'Memakai cos padahal yang ditanya sisi depan.');
      }
      return _mk(topicId: topicId, tier: tier, seed: seed,
        stem: 'Sisi samping sudut 60° adalah ${miring ~/ 2}, sisi miring?', hint: 'cos 60° = 1/2.',
        correct: '$miring', wrong: [['${miring ~/ 2}', ''], ['${miring + 2}', ''], ['${miring * 2}', '']],
        steps: ['miring = ${miring ~/ 2} ÷ 1/2 = $miring.'], pitfall: 'Membalik pembilang-penyebut rasio.');
    }
    case 'ge_koordinat': {
      if (tier == 1) {
        final dx = 3, dy = 4, k = 1 + R.nextInt(1 + tier);
        return _mk(topicId: topicId, tier: tier, seed: seed,
          stem: 'Jarak (0, 0) ke (${dx * k}, ${dy * k})?', hint: 'Jarak = √(Δx² + Δy²).',
          correct: '${5 * k}', wrong: [['${5 * k + 1}', ''], ['${7 * k}', ''], ['${dx * k + dy * k}', '']],
          steps: ['√(${(dx * k) * (dx * k)} + ${(dy * k) * (dy * k)}) = ${5 * k}.'], pitfall: 'Menjumlah Δx+Δy tanpa Pythagoras.');
      }
      final x1 = R.nextInt(6), y1 = R.nextInt(6);
      final dx = 2 + R.nextInt(3 + tier), dy = 2 + R.nextInt(3 + tier);
      return _mk(topicId: topicId, tier: tier, seed: seed,
        stem: 'Gradien garis ($x1, $y1) ke (${x1 + dx}, ${y1 + dy})?', hint: 'm = Δy/Δx.',
        correct: '$dy/$dx', wrong: [['$dx/$dy', ''], ['${dy + 1}/$dx', ''], ['$dy/${dx + 1}', '']],
        steps: ['m = $dy/$dx.'], pitfall: 'Membalik Δx dan Δy.');
    }
    case 'ge_luasvol': {
      if (tier == 1) {
        final p = 3 + R.nextInt(8), l = 3 + R.nextInt(8);
        return _mk(topicId: topicId, tier: tier, seed: seed,
          stem: 'Luas persegi panjang $p × $l?', hint: 'L = p × l.',
          correct: '${p * l}', wrong: [['${2 * (p + l)}', ''], ['${p * l + p}', ''], ['${p + l}', '']],
          steps: ['$p × $l = ${p * l}.'], pitfall: 'Tertukar dengan keliling.');
      }
      if (tier == 2) {
        final a = 4 + R.nextInt(8), t = 3 + R.nextInt(6);
        return _mk(topicId: topicId, tier: tier, seed: seed,
          stem: 'Luas segitiga alas $a tinggi $t?', hint: 'L = ½ × a × t.',
          correct: '${a * t ~/ 2}', wrong: [['${a * t}', ''], ['${a * t ~/ 2 + t}', ''], ['${a + t}', '']],
          steps: ['½ × $a × $t = ${a * t ~/ 2}.'], pitfall: 'Lupa membagi dua.');
      }
      final p = 2 + R.nextInt(5), l = 2 + R.nextInt(5), t = 2 + R.nextInt(5);
      return _mk(topicId: topicId, tier: tier, seed: seed,
        stem: 'Volume balok $p × $l × $t?', hint: 'V = p × l × t.',
        correct: '${p * l * t}', wrong: [['${2 * (p * l + p * t + l * t)}', ''], ['${p * l * t + p}', ''], ['${p + l + t}', '']],
        steps: ['$p × $l × $t = ${p * l * t}.'], pitfall: 'Memakai rumus luas permukaan.');
    }
    case 'ge_translasi': {
      final x = -3 + R.nextInt(7 + tier), y = -3 + R.nextInt(7 + tier);
      final a = -4 + R.nextInt(9), b = -4 + R.nextInt(9);
      return _mk(topicId: topicId, tier: tier, seed: seed,
        stem: 'Titik ($x, $y) digeser T($a, $b). Bayangannya?', hint: 'Tambahkan komponennya.',
        correct: '(${x + a}, ${y + b})',
        wrong: [['(${x - a}, ${y - b})', ''], ['(${x + a}, ${y - b})', ''], ['($x, $y)', '']],
        steps: ['x: $x+($a) = ${x + a}; y: $y+($b) = ${y + b}.'],         pitfall: 'Mengurang padahal rumusnya langsung tambah.');
    }
    case 'ge_rotasi': {
      final x = 1 + R.nextInt(3 + tier * 2), y = 1 + R.nextInt(3 + tier * 2);
      final sx = R.nextBool() ? 1 : -1, sy = R.nextBool() ? 1 : -1;
      final px = sx * x, py = sy * y;
      return _mk(topicId: topicId, tier: tier, seed: seed,
        stem: 'Titik ($px, $py) dirotasi 90° berlawanan jarum jam tentang O. Hasilnya?',
        hint: '(x, y) → (−y, x).', correct: '(${-py}, $px)',
        wrong: [['($py, ${-px})', ''], ['($px, $py)', ''], ['(${-px}, ${-py})', '']],
        steps: ['Tukar: ($px,$py) → ($py,$px), negasikan depan → (${-py}, $px).'],
        pitfall: 'Memutar searah jarum jam ($py, ${-px}).');
    }
    case 'ge_refleksi': {
      final x = 1 + R.nextInt(4 + tier * 2), y = 1 + R.nextInt(4 + tier * 2);
      final mode = R.nextInt(tier >= 3 ? 3 : 2);
      final ans = mode == 0 ? '($x, ${-y})' : mode == 1 ? '(${-x}, $y)' : '($y, $x)';
      final nm = mode == 0 ? 'sumbu X' : mode == 1 ? 'sumbu Y' : 'garis y = x';
      return _mk(topicId: topicId, tier: tier, seed: seed,
        stem: 'Titik ($x, $y) dicerminkan terhadap $nm. Hasilnya?', hint: 'Negasikan yang tegak lurus cermin.',
        correct: ans,
        wrong: mode == 0
            ? [['(${-x}, $y)', ''], ['($x, $y)', ''], ['($y, $x)', '']]
            : mode == 1
                ? [['($x, ${-y})', ''], ['($x, $y)', ''], ['($y, $x)', '']]
                : [['($x, ${-y})', ''], ['(${-x}, $y)', ''], ['($x, $y)', '']],
        steps: ['Terhadap $nm → $ans.'], pitfall: 'Mencerminkan terhadap sumbu yang salah.');
    }
    case 'ge_dilatasi': {
      final k = 2 + R.nextInt(1 + tier);
      final x = 1 + R.nextInt(3 + tier * 2), y = 1 + R.nextInt(3 + tier * 2);
      return _mk(topicId: topicId, tier: tier, seed: seed,
        stem: 'Titik ($x, $y) didilatasi skala $k pusat O. Hasilnya?',
        hint: 'Kalikan semua dengan $k.', correct: '(${x * k}, ${y * k})',
        wrong: [['(${x + k}, ${y + k})', ''], ['(${x * k}, $y)', ''], ['($x, ${y * k})', '']],
        steps: ['($x×$k, $y×$k) = (${x * k}, ${y * k}).'], pitfall: 'Menambah k, bukan mengali.');
    }
    case 'ge_komposisi': {
      final x = R.nextInt(4), y = R.nextInt(4);
      final a = 1 + R.nextInt(3), b = 1 + R.nextInt(3);
      final ix = x + a, iy = y + b;
      return _mk(topicId: topicId, tier: tier, seed: seed,
        stem: '($x, $y) → translasi T($a, $b) → cermin sumbu X. Hasil akhir?',
        hint: 'Translasi dulu, baru cerminkan.', correct: '($ix, ${-iy})',
        wrong: [['($ix, $iy)', ''], ['(${ix - a}, ${-iy})', ''], ['(${-ix}, ${-iy})', '']],
        steps: ['T: ($x,$y) → ($ix,$iy).', 'Cermin X → ($ix, ${-iy}).'], pitfall: 'Mencerminkan dulu sebelum translasi.');
    }
    case 'ge_datar': {
      if (tier <= 2) {
        final s = 4 + R.nextInt(4 + tier * 3);
        return _mk(topicId: topicId, tier: tier, seed: seed,
          stem: 'Keliling dan luas persegi sisi $s?', hint: 'K = 4s, L = s².',
          correct: '${4 * s} dan ${s * s}',
          wrong: [['${s * s} dan ${4 * s}', ''], ['${4 * s + 1} dan ${s * s}', ''], ['$s dan ${s * s}', '']],
          steps: ['K = 4×$s = ${4 * s}; L = $s² = ${s * s}.'], pitfall: 'Tertukar keliling dan luas.');
      }
      return _mk(topicId: topicId, tier: tier, seed: seed,
        stem: 'Jumlah sudut dalam segiempat?', hint: 'Dua segitiga = 2×180°.',
        correct: '360°', wrong: [['180°', ''], ['270°', ''], ['540°', '']],
        steps: ['Segiempat = 2 segitiga → 360°.'], pitfall: 'Disamakan dengan segitiga (180°).');
    }
    case 'ge_ruang': {
      if (tier <= 2) {
        final s = 2 + R.nextInt(3 + tier * 2);
        return _mk(topicId: topicId, tier: tier, seed: seed,
          stem: 'Volume kubus sisi $s?', hint: 'V = s³.',
          correct: '${s * s * s}', wrong: [['${6 * s * s}', ''], ['${s * s}', ''], ['${3 * s}', '']],
          steps: ['$s³ = ${s * s * s}.'], pitfall: 'Memakai rumus luas permukaan (6s²).');
      }
      return _mk(topicId: topicId, tier: tier, seed: seed,
        stem: 'Banyak rusuk kubus?', hint: 'Gambar kubus, hitung garisnya.',
        correct: '12', correctSub: 'rusuk',
        wrong: [['8', 'rusuk'], ['6', 'rusuk'], ['10', 'rusuk']],
        steps: ['Kubus: 12 rusuk, 8 titik, 6 sisi.'], pitfall: 'Tertukar dengan titik sudut (8).');
    }

    // ================= TAMBAHAN =================
    case 'tb_peluang': {
      if (tier == 1) {
        return _mk(topicId: topicId, tier: tier, seed: seed,
          stem: 'Peluang muncul mata dadu 5?', hint: 'Disukai / mungkin = 1/6.',
          correct: '1/6', wrong: [['1/5', ''], ['5/6', ''], ['1/2', '']],
          steps: ['1 sisi dari 6 → 1/6.'], pitfall: 'Penyebut memakai 5.');
      }
      if (tier == 2) {
        return _mk(topicId: topicId, tier: tier, seed: seed,
          stem: 'Peluang kartu As dari 52 kartu?', hint: 'Ada 4 As.',
          correct: '1/13', correctSub: '= 4/52',
          wrong: [['1/52', ''], ['4/13', ''], ['1/4', '']],
          steps: ['4/52 = 1/13.'], pitfall: 'Lupa menyederhanakan 4/52.');
      }
      return _mk(topicId: topicId, tier: tier, seed: seed,
        stem: 'Dilempar 2 koin. Peluang keduanya gambar?', hint: '½ × ½.',
        correct: '1/4', wrong: [['1/2', ''], ['1/3', ''], ['3/4', '']],
        steps: ['½ × ½ = 1/4.'], pitfall: 'Menjumlah (½+½=1) bukan mengali.');
    }
    case 'tb_statistika': {
      if (tier <= 2) {
        final a = 3 + R.nextInt(6), d = 1 + R.nextInt(3);
        final data = [a - d, a, a + d];
        return _mk(topicId: topicId, tier: tier, seed: seed,
          stem: 'Rata-rata ${data.join(', ')}?', hint: 'Jumlah ÷ banyaknya.',
          correct: '$a', wrong: [['${a - 1}', ''], ['${a + 1}', ''], ['${3 * a}', '']],
          steps: ['(${data.join('+')}) ÷ 3 = $a.'], pitfall: 'Lupa membagi dengan banyak data.');
      }
      if (tier == 3) {
        final a = [4 + R.nextInt(5), 6 + R.nextInt(5), 8 + R.nextInt(5), 10 + R.nextInt(4), 12 + R.nextInt(4)];
        a.sort();
        return _mk(topicId: topicId, tier: tier, seed: seed,
          stem: 'Median ${a.join(', ')}?', hint: 'Urutkan, ambil tengah.',
          correct: '${a[2]}', wrong: [['${a[1]}', ''], ['${a[3]}', ''], ['${a[0]}', '']],
          steps: ['Terurut, tengah = ${a[2]}.'], pitfall: 'Mengambil rata-rata sebagai median.');
      }
      final m = 5 + R.nextInt(5);
      final data = [m, m + 2, m, m + 5, m + 2, m];
      return _mk(topicId: topicId, tier: tier, seed: seed,
        stem: 'Modus ${data.join(', ')}?', hint: 'Paling sering muncul.',
        correct: '$m', wrong: [['${m + 2}', ''], ['${m + 5}', ''], ['${(data.reduce((x, y) => x + y)) ~/ data.length}', '']],
        steps: ['$m muncul 3×, terbanyak.'], pitfall: 'Menjawab rata-rata sebagai modus.');
    }
    case 'tb_barisan': {
      final a = 2 + R.nextInt(5 + tier * 2), b = 2 + R.nextInt(3 + tier * 2);
      final n = 4 + R.nextInt(3 + tier * 2);
      final un = a + (n - 1) * b;
      return _mk(topicId: topicId, tier: tier, seed: seed,
        stem: 'Barisan $a, ${a + b}, ${a + 2 * b}, … Suku ke-$n (U$n)?',
        hint: 'Un = a + (n−1)b.', correct: '$un',
        wrong: [['${un - b}', ''], ['${un + b}', ''], ['${a + n * b}', '']],
        steps: ['U$n = $a + ${n - 1}×$b = $un.'], pitfall: 'Memakai n×b tanpa kurang 1.');
    }
    case 'tb_barisan_geo': {
      final a = 2 + R.nextInt(2 + tier), r = 2 + R.nextInt(1 + tier);
      if (tier <= 2) {
        final n = 3 + R.nextInt(2);
        var un = a;
        for (var i = 1; i < n; i++) {
          un *= r;
        }
        return _mk(topicId: topicId, tier: tier, seed: seed,
          stem: 'Barisan geometri suku pertama $a rasio $r. U$n?', hint: 'Un = a·rⁿ⁻¹.',
          correct: '$un', wrong: [['${un ~/ r}', ''], ['${un * r}', ''], ['${a + (n - 1) * r}', '']],
          steps: ['U$n = $a × $r^${n - 1} = $un.'], pitfall: 'Memakai rumus aritmatika.');
      }
      var sn = 0, p = a;
      for (var i = 0; i < 3; i++) {
        sn += p;
        p *= r;
      }
      return _mk(topicId: topicId, tier: tier, seed: seed,
        stem: 'Jumlah 3 suku pertama (a=$a, r=$r)?', hint: 'Jumlahkan U₁+U₂+U₃.',
        correct: '$sn', wrong: [['${sn + a}', ''], ['${sn - a}', ''], ['${3 * a}', '']],
        steps: ['$a + ${a * r} + ${a * r * r} = $sn.'], pitfall: 'Hanya menjumlah 2 suku.');
    }
    case 'tb_subjek': {
      final v = 2 + R.nextInt(4 + tier), t = 2 + R.nextInt(4 + tier);
      final s = v * t;
      return _mk(topicId: topicId, tier: tier, seed: seed,
        stem: 'Dari s = v×t dengan s=$s, v=$v. Nilai t?', hint: 't = s/v.',
        correct: '$t', wrong: [['${t + 1}', ''], ['${s - v}', ''], ['${s + v}', '']],
        steps: ['t = $s ÷ $v = $t.'], pitfall: 'Mengurang (s−v) bukan membagi.');
    }
    case 'tb_sosial': {
      if (tier <= 2) {
        final beli = (5 + R.nextInt(10 + tier * 5)) * 10000;
        final pct = [10, 20, 25][R.nextInt(3)];
        final untung = beli * pct ~/ 100;
        return _mk(topicId: topicId, tier: tier, seed: seed,
          stem: 'Modal Rp$beli, untung $pct%. Harga jual?', hint: 'Jual = modal + untung.',
          correct: 'Rp${beli + untung}',
          wrong: [['Rp${beli - untung}', ''], ['Rp${beli + untung ~/ 2}', ''], ['Rp$untung', '']],
          steps: ['Untung = $pct% × $beli = $untung.', 'Jual = ${beli + untung}.'],
          pitfall: 'Persen dihitung dari harga jual.');
      }
      final harga = (8 + R.nextInt(12)) * 10000;
      final disc = [10, 20, 50][R.nextInt(3)];
      final bayar = harga * (100 - disc) ~/ 100;
      return _mk(topicId: topicId, tier: tier, seed: seed,
        stem: 'Harga Rp$harga diskon $disc%. Dibayar?', hint: 'Bayar (100−diskon)%.',
        correct: 'Rp$bayar', wrong: [['Rp${harga - harga * disc ~/ 1000}', ''], ['Rp${harga * disc ~/ 100}', ''], ['Rp$harga', '']],
        steps: ['Diskon = $disc% × $harga.', 'Bayar = $bayar.'], pitfall: 'Membayar sebesar diskonnya saja.');
    }
    case 'tb_balik': {
      final p1 = 4 + R.nextInt(4 + tier * 2), h1 = 6 + R.nextInt(6 + tier * 3);
      final p2 = p1 + 2 + R.nextInt(3 + tier);
      final h2 = p1 * h1 ~/ p2;
      if (p1 * h1 % p2 != 0) return generateDynamic(topicId, tier, seed + 1);
      return _mk(topicId: topicId, tier: tier, seed: seed,
        stem: '$p1 pekerja selesai $h1 hari. Oleh $p2 pekerja, selesai … hari?',
        hint: 'Balik satu ruas: $p1×$h1 ÷ $p2.', correct: '$h2 hari',
        wrong: [['${h2 + 2} hari', ''], ['${p1 * h1 ~/ (p2 - 1)} hari', ''], ['${h1 + 2} hari', '']],
        steps: ['$p1×$h1 = ${p1 * h1} satuan kerja.', '÷ $p2 = $h2 hari.'], pitfall: 'Memakai perbandingan senilai (hari ikut bertambah).');
    }
    case 'tb_senilai': {
      final kg = 2 + R.nextInt(3 + tier), rp = (10 + R.nextInt(15 + tier * 5)) * 1000;
      final n = kg + 1 + R.nextInt(2 + tier);
      final ans = rp * n ~/ kg;
      if (rp * n % kg != 0) return generateDynamic(topicId, tier, seed + 1);
      return _mk(topicId: topicId, tier: tier, seed: seed,
        stem: '$kg kg Rp$rp. Harga $n kg?', hint: 'Kali silang.',
        correct: 'Rp$ans', wrong: [['Rp${ans + rp ~/ kg}', ''], ['Rp${rp + (n - kg) * 1000}', ''], ['Rp${ans - rp ~/ kg}', '']],
        steps: ['$n × $rp ÷ $kg = $ans.'], pitfall: 'Menambah selisih, bukan skala lipat.');
    }
    case 'tb_cerita': {
      final a = 2 + R.nextInt(3 + tier), pa = (10 + R.nextInt(10 + tier * 5)) * 1000;
      final b = 1 + R.nextInt(2 + tier), pb = (5 + R.nextInt(8 + tier * 4)) * 1000;
      final total = a * pa + b * pb;
      final bayar = ((total ~/ 50000) + 1) * 50000;
      return _mk(topicId: topicId, tier: tier, seed: seed,
        stem: 'Beli $a × Rp$pa dan $b × Rp$pb, bayar Rp$bayar. Kembalian?',
        hint: 'Total dulu, baru kurangkan.', correct: 'Rp${bayar - total}',
        wrong: [['Rp${bayar - total + 5000}', ''], ['Rp$total', ''], ['Rp${bayar - total - 5000}', '']],
        steps: ['Total = ${a * pa}+${b * pb} = $total.', 'Kembali = $bayar−$total = ${bayar - total}.'],
        pitfall: 'Salah hitung salah satu subtotal.');
    }
    case 'tb_imajinasi': {
      if (tier == 1) {
        return _mk(topicId: topicId, tier: tier, seed: seed,
          stem: 'Banyak sisi kubus?', hint: 'Atas, bawah + 4 keliling.',
          correct: '6', correctSub: 'sisi',
          wrong: [['8', 'sisi'], ['12', 'sisi'], ['4', 'sisi']],
          steps: ['Kubus punya 6 sisi.'], pitfall: 'Tertukar dengan titik sudut (8).');
      }
      if (tier == 2) {
        return _mk(topicId: topicId, tier: tier, seed: seed,
          stem: 'Banyak rusuk balok?', hint: '4 rusuk × 3 arah.',
          correct: '12', correctSub: 'rusuk',
          wrong: [['8', 'rusuk'], ['6', 'rusuk'], ['10', 'rusuk']],
          steps: ['Balok: 12 rusuk.'], pitfall: 'Menghitung sisi (6).');
      }
      return _mk(topicId: topicId, tier: tier, seed: seed,
        stem: 'Kubus 3×3×3 dicat luar. Kubus kecil berhias tepat 2 sisi?',
        hint: 'Tengah tiap rusuk: 12 rusuk × 1.', correct: '12',
        wrong: [['8', ''], ['6', ''], ['24', '']],
        steps: ['Rusuk kubus 12, tiap tengah rusuk 1 kubus → 12.'], pitfall: 'Menjawab sudut (8) yang berhias 3 sisi.');
    }
    default: { // tb_cacah
      if (tier <= 2) {
        final a = 2 + R.nextInt(3 + tier * 2), b = 2 + R.nextInt(3 + tier * 2);
        return _mk(topicId: topicId, tier: tier, seed: seed,
          stem: '$a baju dan $b celana. Banyak setelan?', hint: 'Kalikan pilihannya.',
          correct: '${a * b}', correctSub: 'setelan',
          wrong: [['${a + b}', 'setelan'], ['${a * b + a}', 'setelan'], ['${a * b - 1}', 'setelan']],
          steps: ['$a × $b = ${a * b}.'], pitfall: 'Menjumlah pilihan, bukan mengali.');
      }
      if (tier == 3) {
        final n = 4 + R.nextInt(2);
        return _mk(topicId: topicId, tier: tier, seed: seed,
          stem: 'Susunan juara 1–2 dari $n peserta (P($n,2))?', hint: '$n × ${n - 1}.',
          correct: '${n * (n - 1)}', wrong: [['${n * (n - 1) ~/ 2}', ''], ['${n * n}', ''], ['${n + (n - 1)}', '']],
          steps: ['P($n,2) = $n × ${n - 1} = ${n * (n - 1)}.'], pitfall: 'Membagi 2 (itu kombinasi).');
      }
      final n = 4 + R.nextInt(2);
      final c = n * (n - 1) ~/ 2;
      return _mk(topicId: topicId, tier: tier, seed: seed,
        stem: 'Jabat tangan tiap pasang dari $n orang (C($n,2))?', hint: 'Bagi permutasi dengan 2.',
        correct: '$c', wrong: [['${n * (n - 1)}', ''], ['${c + 1}', ''], ['${n * n ~/ 2}', '']],
        steps: ['C($n,2) = $n×${n - 1}÷2 = $c.'], pitfall: 'Lupa membagi 2 (urutan tak penting).');
    }
  }
}

// ---------------------------------------------------------------------------
// Sesi: latihan bertahap (pemanasan + inti) & evaluasi akhir
// ---------------------------------------------------------------------------
List<Question> buildPractice(String topicId, int tier) {
  tier = _clampTier(tier);
  final out = <Question>[];
  final base = tier > 1 ? tier - 1 : tier;
  out.add(generateDynamic(topicId, base, 1));
  out.add(generateDynamic(topicId, base, 2));
  for (var i = 0; i < 4; i++) {
    out.add(generateDynamic(topicId, tier, 10 + i));
  }
  return out;
}

List<Question> buildEvaluation(String topicId) {
  return [
    generateDynamic(topicId, 1, 101),
    generateDynamic(topicId, 2, 102),
    generateDynamic(topicId, 2, 103),
    generateDynamic(topicId, 3, 104),
    generateDynamic(topicId, 4, 105),
  ];
}

// ---------------------------------------------------------------------------
// Routing kategori lama (Layar 4) → rotasi subtopik baru.
// 'pecahan' dipertahankan memakai generator legacy agar sama persis dengan
// wireframe demo (18/24, kunci B).
// ---------------------------------------------------------------------------
Question generateForCategory(String categoryId, int level, int index) {
  final tier = level < 1 ? 1 : (level > 4 ? 4 : level);
  switch (categoryId) {
    case 'aritmatika':
      final ids = ['ar_penjumlahan', 'ar_pengurangan', 'ar_perkalian', 'ar_pembagian', 'ar_campuran', 'ar_pecahan'];
      return generateDynamic(ids[index % ids.length], tier, index * 7 + 1);
    case 'aljabar':
      final ids = ['al_sederhana', 'al_nilai_x', 'al_koordinat', 'al_faktor', 'al_pertidaksamaan', 'al_persamaan', 'al_polinomial', 'al_logika', 'al_kuadrat', 'al_sifat', 'al_spldv', 'al_spltv'];
      return generateDynamic(ids[index % ids.length], tier, index * 7 + 2);
    case 'fungsi':
      final ids = ['fn_linear', 'fn_aljabar', 'fn_grafik', 'fn_titik', 'fn_invers', 'fn_komposisi'];
      return generateDynamic(ids[index % ids.length], tier, index * 7 + 3);
    case 'trigono':
      final ids = ['tr_dasar', 'tr_rasio', 'tr_identitas', 'tr_persamaan', 'tr_invers'];
      return generateDynamic(ids[index % ids.length], tier, index * 7 + 4);
    case 'geometri':
      final ids = ['ge_sudut', 'ge_pythagoras', 'ge_lingkaran', 'ge_sincos', 'ge_koordinat', 'ge_luasvol', 'ge_translasi', 'ge_rotasi', 'ge_refleksi', 'ge_dilatasi', 'ge_komposisi', 'ge_datar', 'ge_ruang'];
      return generateDynamic(ids[index % ids.length], tier, index * 7 + 5);
    case 'peluang':
      final ids = ['tb_peluang', 'tb_statistika', 'tb_cacah'];
      return generateDynamic(ids[index % ids.length], tier, index * 7 + 6);
    case 'barisan':
      final ids = ['tb_barisan', 'tb_barisan_geo'];
      return generateDynamic(ids[index % ids.length], tier, index * 7 + 7);
    default:
      return generateQuestion(categoryId, level, index);
  }
}
