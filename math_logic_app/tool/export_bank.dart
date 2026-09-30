// Mengekspor SELURUH bank soal ke assets/bank/bank.json (53 topik ×
// 4 tier × 25 seed = 5.300 soal). Jalankan:  dart run tool/export_bank.dart
// File ini yang dihitung Play Console sebagai konten + dipakai mode paket offline.
import 'dart:convert';
import 'dart:io';
import 'package:math_logic_app/core/data/curriculum.dart';
import 'package:math_logic_app/core/data/generators.dart';

Future<void> main() async {
  const seedsPerTier = 25;
  final out = <Map<String, dynamic>>[];
  for (final t in kTopics()) {
    for (var tier = 1; tier <= 4; tier++) {
      for (var s = 0; s < seedsPerTier; s++) {
        final seed = s * 7 + 1;
        try {
          final q = generateDynamic(t.id, tier, seed);
          out.add({
          'id': q.id,
          'topic': q.subCategoryId,
          'category': q.categoryId,
          'tier': q.level,
          'type': 'multipleChoice',
          'stem': q.stem,
          'hint': q.hint,
          'options': [
            for (final o in q.options)
              {'label': o.label, 'text': o.text, 'sub': o.sub}
          ],
          'answer': q.answer,
          'steps': q.steps,
          'pitfall': q.pitfall,
          'estimatedSec': q.estimatedTimeSec,
          'xp': q.xpReward,
          });
        } catch (e) {
          // Gagal dengan konteks topik — jangan telan errornya.
          throw StateError('Export gagal di ${t.id} T$tier seed $seed: $e');
        }
      }
    }
  }
  Directory('assets/bank').createSync(recursive: true);
  final f = File('assets/bank/bank.json');
  f.writeAsStringSync(jsonEncode(out));
  final kb = f.lengthSync() ~/ 1024;
  print('topics=${kTopics().length} tiers=4 seeds=$seedsPerTier '
      'total=${out.length} size=${kb}KB -> ${f.path}');
}
