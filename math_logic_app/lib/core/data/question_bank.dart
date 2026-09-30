// Struktur data soal sesuai PRD Fase 2 + bank soal prosedural offline.
// Target: ribuan soal via generator deterministik per kategori/level.
import 'dart:math';

enum QuestionType { multipleChoice, inputNumber, trueFalse }

class QOption {
  final String label; // A/B/C/D
  final String text;
  final String sub;
  const QOption(this.label, this.text, [this.sub = '']);
}

class Question {
  final String id;
  final String categoryId;
  final String subCategoryId;
  final int level;
  final QuestionType type;
  final String stem;
  final String hint;
  final List<QOption> options;
  final String answer; // label benar, mis. 'B'
  final List<String> steps;
  final String pitfall;
  final int estimatedTimeSec;
  final int xpReward;
  const Question({
    required this.id, required this.categoryId, required this.subCategoryId,
    required this.level, required this.type, required this.stem,
    required this.hint, required this.options, required this.answer,
    required this.steps, required this.pitfall,
    this.estimatedTimeSec = 45, this.xpReward = 10,
  });
}

class MathCategory {
  final String id;
  final String title;
  final String desc;
  final String tingkat;
  final int materiCount;
  final double progress; // 0..1
  final String status; // selesai | aktif | tersedia | terkunci
  final String icon; // material icon name key
  const MathCategory({
    required this.id, required this.title, required this.desc,
    required this.tingkat, required this.materiCount, required this.progress,
    required this.status, required this.icon,
  });
}

class SubMateri {
  final String id;
  final String title;
  final String desc;
  final String state; // selesai | berjalan | terkunci
  final String badge;
  const SubMateri(this.id, this.title, this.desc, this.state, this.badge);
}

/// Katalog kategori matematika (Pilar 1) — sesuai wireframe Layar 4.
List<MathCategory> mathCategories() => const [
      MathCategory(id: 'aritmatika', title: 'Aritmatika Dasar', desc: 'Operasi hitung bilangan bulat, sifat asosiatif, estimasi cepat.', tingkat: 'Dasar', materiCount: 12, progress: 1.0, status: 'selesai', icon: 'calculate'),
      MathCategory(id: 'pecahan', title: 'Pecahan & Desimal', desc: 'Pecahan senilai, penyederhanaan FPB, konversi desimal & persen.', tingkat: 'Menengah', materiCount: 8, progress: 0.5, status: 'aktif', icon: 'pie_chart'),
      MathCategory(id: 'aljabar', title: 'Aljabar & Persamaan', desc: 'Persamaan linear satu variabel, substitusi, pemfaktoran aljabar.', tingkat: 'Menengah - Lanjutan', materiCount: 6, progress: 0.2, status: 'tersedia', icon: 'functions'),
      MathCategory(id: 'geometri', title: 'Geometri & Pengukuran', desc: 'Keliling, luas poligon, volume bangun ruang dan teorema Pythagoras.', tingkat: 'Lanjutan', materiCount: 4, progress: 0.0, status: 'terkunci', icon: 'square_foot'),
      MathCategory(id: 'trigono', title: 'Trigonometri', desc: 'Rasio sin cos tan, identitas, persamaan & aplikasi.', tingkat: 'Lanjutan', materiCount: 10, progress: 0.0, status: 'terkunci', icon: 'show_chart'),
      MathCategory(id: 'fungsi', title: 'Fungsi', desc: 'Linear, kuadrat, invers, komposisi & analisis grafik.', tingkat: 'Menengah', materiCount: 9, progress: 0.0, status: 'tersedia', icon: 'function_variant'),
      MathCategory(id: 'peluang', title: 'Peluang & Statistika', desc: 'Mean median modus, peluang dasar, kombinatorika.', tingkat: 'Menengah', materiCount: 7, progress: 0.0, status: 'tersedia', icon: 'bar_chart'),
      MathCategory(id: 'barisan', title: 'Barisan & Deret', desc: 'Aritmatika, geometri, tak hingga & notasi sigma.', tingkat: 'Lanjutan', materiCount: 6, progress: 0.0, status: 'tersedia', icon: 'format_list_numbered'),
    ];

List<SubMateri> pecahanSubMateri() => const [
      SubMateri('p1', '1. Pengenalan Pecahan Biasa', 'Konsep dasar bagian utuh dan pembagian proporsional', 'selesai', '100% Selesai'),
      SubMateri('p2', '2. Pecahan Senilai & Perbandingan', 'Perkalian silang dan ekuivalensi pecahan', 'selesai', 'Skor 100'),
      SubMateri('p3', '3. Penyederhanaan Pecahan & FPB', 'Mencari FPB pembilang-penyebut untuk bentuk paling sederhana', 'berjalan', 'Sedang Berjalan'),
      SubMateri('p4', '4. Konversi Desimal & Persen', 'Selesaikan Submateri 3 terlebih dahulu', 'terkunci', 'Terkunci'),
    ];

int _fpb(int a, int b) => b == 0 ? a : _fpb(b, a % b);

/// Generator deterministik: seed = level*1000 + index.
/// Mencakup: aritmatika, pecahan/FPB, aljabar (cari x), fungsi linear,
/// trigonometri rasio, geometri pythagoras, peluang, barisan.
Question generateQuestion(String categoryId, int level, int index) {
  final rnd = Random(level * 1000 + index);
  switch (categoryId) {
    case 'pecahan': {
      final f = 2 + rnd.nextInt(3 + level); // faktor
      final p = (2 + rnd.nextInt(6 + level)) * f;
      final q = (3 + rnd.nextInt(7 + level)) * f;
      final g = _fpb(p, q);
      final sp = p ~/ g, sq = q ~/ g;
      // distractors: belum sederhana, salah FPB, dst
      final opts = <QOption>[
        QOption('A', '${p ~/ 2}/${q ~/ 2}', 'Belum paling sederhana'),
        QOption('B', '$sp/$sq', 'Tersederhana'),
        QOption('C', '${sp + 1}/$sq', 'Empat perlima'),
        QOption('D', '$p/$q', 'Belum paling sederhana'),
      ];
      // acak posisi kunci sederhana: tetap B untuk konsistensi wireframe demo
      return Question(
        id: 'pecahan-L$level-$index', categoryId: categoryId,
        subCategoryId: 'penyederhanaan_fpb', level: level,
        type: QuestionType.multipleChoice,
        stem: 'Berapakah bentuk paling sederhana dari pecahan $p/$q?',
        hint: 'Faktor dari $p dan $q. Bagi dengan FPB = $g.',
        options: opts, answer: 'B',
        steps: [
          'Tentukan FPB dari $p dan $q = $g.',
          'Bagi pembilang & penyebut: $p ÷ $g = $sp dan $q ÷ $g = $sq.',
          'Diperoleh bentuk paling sederhana $sp/$sq.',
        ],
        pitfall: 'Memilih (A) adalah jebakan karena baru membagi dengan faktor 2, bukan FPB = $g.',
      );
    }
    case 'aritmatika': {
      final a = 6 + rnd.nextInt(10 + level * 8);
      final b = 2 + rnd.nextInt(9);
      final ans = a ~/ b * b == a ? a ~/ b : (a - a % b) ~/ b + 1;
      final aa = ans * b;
      return Question(
        id: 'arit-L$level-$index', categoryId: categoryId,
        subCategoryId: 'pembagian_cepat', level: level,
        type: QuestionType.multipleChoice,
        stem: 'Berapakah hasil dari $aa ÷ $b?',
        hint: 'Ingat tabel perkalian $b.',
        options: [QOption('A', '${ans - 2}'), QOption('B', '${ans - 1}'), QOption('C', '$ans'), QOption('D', '${ans + 1}')],
        answer: 'C',
        steps: ['$b × $ans = $aa.', 'Jadi $aa ÷ $b = $ans.'],
        pitfall: 'Hati-hati tertukar dengan ${ans - 1} (kurang satu kelipatan $b).',
      );
    }
    case 'aljabar': {
      final x = 2 + rnd.nextInt(5 + level);
      final m = 2 + rnd.nextInt(4);
      final c = rnd.nextInt(10);
      final rhs = m * x + c;
      return Question(
        id: 'alj-L$level-$index', categoryId: categoryId,
        subCategoryId: 'mencari_nilai_x', level: level,
        type: QuestionType.multipleChoice,
        stem: 'Tentukan nilai x dari ${m}x + $c = $rhs.',
        hint: 'Kurangkan $c kedua ruas, lalu bagi $m.',
        options: [QOption('A', '${x - 1}'), QOption('B', '$x'), QOption('C', '${x + 1}'), QOption('D', '${x + 2}')],
        answer: 'B',
        steps: ['${m}x = $rhs − $c = ${rhs - c}.', 'x = ${rhs - c} ÷ $m = $x.'],
        pitfall: 'Jangan lupa membagi konstanta juga dengan $m.',
      );
    }
    case 'geometri': {
      final a = 3 + rnd.nextInt(3 + level);
      final b = 4 + rnd.nextInt(3 + level);
      final c2 = a * a + b * b;
      final c = sqrt(c2).toInt();
      final cc = c * c == c2 ? c : 5;
      return Question(
        id: 'geo-L$level-$index', categoryId: categoryId,
        subCategoryId: 'pythagoras', level: level,
        type: QuestionType.multipleChoice,
        stem: 'Segitiga siku-siku memiliki sisi $a dan $b. Berapa sisi miringnya?',
        hint: 'c² = a² + b².',
        options: [QOption('A', '${cc - 1}'), QOption('B', '$cc'), QOption('C', '${cc + 1}'), QOption('D', '${cc + 2}')],
        answer: 'B',
        steps: ['c² = $a² + $b² = ${a * a} + ${b * b} = ${a * a + b * b}.', 'c = $cc.'],
        pitfall: 'Sisi miring selalu terpanjang — jangan pilih nilai < $b.',
      );
    }
    default: {
      final a = 2 + rnd.nextInt(12);
      final b = 2 + rnd.nextInt(12);
      return Question(
        id: '$categoryId-L$level-$index', categoryId: categoryId,
        subCategoryId: 'umum', level: level,
        type: QuestionType.multipleChoice,
        stem: 'Berapakah $a + $b?',
        hint: 'Jumlahkan satuan lalu puluhan.',
        options: [QOption('A', '${a + b - 2}'), QOption('B', '${a + b}'), QOption('C', '${a + b + 1}'), QOption('D', '${a + b + 2}')],
        answer: 'B',
        steps: ['$a + $b = ${a + b}.'],
        pitfall: 'Teliti menyimpan puluhan.',
      );
    }
  }
}

/// Sesi latihan: 10 soal adaptif untuk kategori tertentu.
List<Question> buildSession(String categoryId, int startLevel) {
  return List.generate(10, (i) => generateQuestion(categoryId, startLevel + (i ~/ 4), i));
}
