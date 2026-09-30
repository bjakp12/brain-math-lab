import 'dart:convert';
import 'package:flutter/services.dart';
import 'question_bank.dart';

/// Memuat bank soal hasil `dart run tool/export_bank.dart` dari aset.
/// Generator dinamis tetap sumber utama (tak terbatas); bank JSON adalah
/// artefak rilis: bisa diaudit, dihitung, dan dipakai mode paket offline.
class BankLoader {
  static List<Question>? _cache;

  static Future<List<Question>> load() async {
    if (_cache != null) return _cache!;
    final raw = await rootBundle.loadString('assets/bank/bank.json');
    final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    _cache = [for (final m in list) _fromJson(m)];
    return _cache!;
  }

  static Future<List<Question>> byTopic(String topicId) async =>
      (await load()).where((q) => q.subCategoryId == topicId).toList();

  static Future<int> count() async => (await load()).length;

  static Question _fromJson(Map<String, dynamic> m) {
    final opts = (m['options'] as List).cast<Map<String, dynamic>>();
    return Question(
      id: m['id'] as String,
      categoryId: m['category'] as String,
      subCategoryId: m['topic'] as String,
      level: m['tier'] as int,
      type: QuestionType.multipleChoice,
      stem: m['stem'] as String,
      hint: m['hint'] as String,
      options: [
        for (final o in opts)
          QOption(o['label'] as String, o['text'] as String,
              (o['sub'] ?? '') as String)
      ],
      answer: m['answer'] as String,
      steps: (m['steps'] as List).cast<String>(),
      pitfall: m['pitfall'] as String,
      estimatedTimeSec: m['estimatedSec'] as int,
      xpReward: m['xp'] as int,
    );
  }
}
