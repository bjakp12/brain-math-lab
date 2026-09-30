import 'package:flutter_test/flutter_test.dart';
import 'package:math_logic_app/core/logic/learner_model.dart';

Attempt _a(String topic, int tier, bool ok,
        {int sec = 20, int est = 45, int conf = 2}) =>
    Attempt(topicId: topic, tier: tier, correct: ok,
        seconds: sec, estimatedSec: est, confidence: conf);

void main() {
  test('remedial terpicu saat akurasi < 55% (3+ upaya)', () {
    final m = LearnerModel();
    m.record(_a('al_faktor', 2, false));
    m.record(_a('al_faktor', 2, false));
    m.record(_a('al_faktor', 2, true));
    m.record(_a('al_faktor', 2, false));
    expect(m.needsRemedial('al_faktor'), true);
    final rec = m.recommend().firstWhere((r) => r.topicId == 'al_faktor');
    expect(rec.kind, RecKind.remedial);
    expect(rec.tier, 1); // turun 1 tier
  });

  test('naik level otomatis saat ≥85% akurat + cepat', () {
    final m = LearnerModel();
    for (var i = 0; i < 4; i++) {
      m.record(_a('ar_campuran', 2, true, sec: 15, conf: 3));
    }
    expect(m.readyToLevelUp('ar_campuran'), true);
    final rec = m.recommend().firstWhere((r) => r.topicId == 'ar_campuran');
    expect(rec.kind, RecKind.naikLevel);
    expect(rec.tier, 3);
  });

  test('tidak naik level bila lambat walau akurat', () {
    final m = LearnerModel();
    for (var i = 0; i < 4; i++) {
      m.record(_a('ge_pythagoras', 2, true, sec: 120, est: 45, conf: 3));
    }
    expect(m.readyToLevelUp('ge_pythagoras'), false);
  });

  test('ulasan cepat saat sering ragu walau benar', () {
    final m = LearnerModel();
    for (var i = 0; i < 4; i++) {
      m.record(_a('tr_identitas', 2, true, conf: 1));
    }
    final kinds = m.recommend().map((r) => r.kind).toSet();
    expect(kinds.contains(RecKind.ulasanCepat), true);
  });

  test('weakestTopics mengurutkan topik terlemah dulu', () {
    final m = LearnerModel();
    for (var i = 0; i < 3; i++) {
      m.record(_a('al_spldv', 2, false));
      m.record(_a('ar_penjumlahan', 1, true, conf: 3));
    }
    expect(m.weakestTopics(2).first, 'al_spldv');
  });

  test('model kosong menyarankan topik fondasi baru', () {
    final m = LearnerModel();
    final rec = m.recommend();
    expect(rec.isNotEmpty, true);
    expect(rec.first.kind, RecKind.topikBaru);
    expect(rec.first.tier, 1);
  });

  test('remedial diprioritaskan sebelum naik level', () {
    final m = LearnerModel();
    for (var i = 0; i < 4; i++) {
      m.record(_a('al_kuadrat', 3, false));
      m.record(_a('fn_linear', 1, true, sec: 10, conf: 3));
    }
    final rec = m.recommend();
    expect(rec.first.kind, RecKind.remedial);
    expect(rec.first.topicId, 'al_kuadrat');
  });
}
