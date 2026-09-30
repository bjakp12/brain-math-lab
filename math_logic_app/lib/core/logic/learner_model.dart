// Model pembelajar adaptif (murni Dart, teruji):
// mencatat benar/salah, waktu, kepercayaan diri per upaya; lalu menentukan
// topik lemah, latihan remedial, kenaikan level otomatis, dan rekomendasi
// latihan berikutnya. Dipakai layar latihan + "Rekomendasi Cepat" Beranda.
import 'dart:math';
import '../data/curriculum.dart';

/// Satu upaya menjawab. confidence: 1 ragu, 2 biasa, 3 yakin.
class Attempt {
  final String topicId;
  final int tier;
  final bool correct;
  final int seconds;
  final int estimatedSec;
  final int confidence;
  const Attempt({
    required this.topicId, required this.tier, required this.correct,
    required this.seconds, required this.estimatedSec, this.confidence = 2,
  });
  double get timeRatio => seconds / max(1, estimatedSec);
}

enum RecKind { remedial, latihan, naikLevel, evaluasi, ulasanCepat, topikBaru }

class Recommendation {
  final String topicId;
  final int tier;
  final RecKind kind;
  final String reason;
  const Recommendation(this.topicId, this.tier, this.kind, this.reason);
}

class TopicStat {
  final int attempts;
  final double accuracyRecent; // 5 terakhir (atau semua bila <5)
  final double avgTimeRatio;
  final double lowConfidenceRate;
  final int bestTier;
  final int streak;
  const TopicStat({
    required this.attempts, required this.accuracyRecent,
    required this.avgTimeRatio, required this.lowConfidenceRate,
    required this.bestTier, required this.streak,
  });
}

class LearnerModel {
  final Map<String, List<Attempt>> _log = {};
  final Map<String, int> _tier = {}; // tier berjalan per topik

  void record(Attempt a) {
    (_log[a.topicId] ??= []).add(a);
    final cur = _tier[a.topicId] ?? a.tier;
    if (a.correct) {
      _tier[a.topicId] = min(4, max(cur, a.tier));
    }
  }

  int tierOf(String topicId, [int fallback = 1]) =>
      _tier[topicId] ?? fallback;

  TopicStat stat(String topicId) {
    final all = _log[topicId] ?? const [];
    if (all.isEmpty) {
      return const TopicStat(
          attempts: 0, accuracyRecent: 0, avgTimeRatio: 1,
          lowConfidenceRate: 0, bestTier: 1, streak: 0);
    }
    final recent = all.length <= 5 ? all : all.sublist(all.length - 5);
    final acc = recent.where((a) => a.correct).length / recent.length;
    final time = recent.map((a) => a.timeRatio).reduce((x, y) => x + y) / recent.length;
    final lowConf = recent.where((a) => a.confidence <= 1).length / recent.length;
    var streak = 0;
    for (var i = all.length - 1; i >= 0 && all[i].correct; i--) {
      streak++;
    }
    return TopicStat(
      attempts: all.length, accuracyRecent: acc, avgTimeRatio: time,
      lowConfidenceRate: lowConf,
      bestTier: all.map((a) => a.tier).reduce(max), streak: streak,
    );
  }

  /// Skor penguasaan 0..1 (akurasi recent dibobot waktu & kepercayaan diri).
  double mastery(String topicId) {
    final s = stat(topicId);
    if (s.attempts == 0) return 0;
    var m = s.accuracyRecent;
    if (s.avgTimeRatio > 1.3) m -= 0.1; // lambat → belum lancar
    if (s.lowConfidenceRate > 0.5) m -= 0.1; // sering ragu
    return m.clamp(0.0, 1.0);
  }

  /// Topik lemah: sudah dicoba, mastery terendah.
  List<String> weakestTopics([int n = 3]) {
    final tried = _log.keys.toList();
    tried.sort((a, b) => mastery(a).compareTo(mastery(b)));
    return tried.take(n).toList();
  }

  bool needsRemedial(String topicId) {
    final s = stat(topicId);
    return s.attempts >= 3 && s.accuracyRecent < 0.55;
  }

  bool readyToLevelUp(String topicId) {
    final s = stat(topicId);
    return s.attempts >= 3 &&
        s.accuracyRecent >= 0.85 &&
        s.avgTimeRatio <= 1.0 &&
        tierOf(topicId) < 4;
  }

  /// Daftar rekomendasi terprioritas: remedial dulu, lalu naik level,
  /// latihan penguatan, ulasan cepat (sering ragu), topik baru, evaluasi.
  List<Recommendation> recommend({int limit = 4}) {
    final out = <Recommendation>[];
    // 1. Remedial: akurasi < 55% → turun 1 tier + penjelasan tambahan.
    for (final t in _log.keys) {
      if (needsRemedial(t)) {
        final s = stat(t);
        out.add(Recommendation(t, max(1, tierOf(t) - 1), RecKind.remedial,
            'Akurasi ${(s.accuracyRecent * 100).round()}% di ${_title(t)} — tampilkan penjelasan tambahan + latihan remedial.'));
      }
    }
    // 2. Naik level otomatis: akurasi ≥ 85% + cepat.
    for (final t in _log.keys) {
      if (readyToLevelUp(t)) {
        out.add(Recommendation(t, tierOf(t) + 1, RecKind.naikLevel,
            'Menguasai ${_title(t)} — tingkat kesulitan naik otomatis.'));
      }
    }
    // 3. Penguatan: 55–85% → latihan tier sama.
    for (final t in _log.keys) {
      final s = stat(t);
      if (s.attempts >= 2 && s.accuracyRecent >= 0.55 && s.accuracyRecent < 0.85 && !needsRemedial(t)) {
        out.add(Recommendation(t, tierOf(t), RecKind.latihan,
            'Penguatan ${_title(t)} (${(s.accuracyRecent * 100).round()}% akurat).'));
      }
    }
    // 4. Ulasan cepat: sering ragu walau benar.
    for (final t in _log.keys) {
      final s = stat(t);
      if (s.attempts >= 3 && s.lowConfidenceRate > 0.5 && s.accuracyRecent >= 0.55) {
        out.add(Recommendation(t, tierOf(t), RecKind.ulasanCepat,
            'Sering ragu di ${_title(t)} — ulasan konsep 2 menit.'));
      }
    }
    // 5. Topik baru yang belum dicoba (fondasi dulu).
    for (final topic in kTopics()) {
      if (out.length >= limit) break;
      if (!_log.containsKey(topic.id)) {
        out.add(Recommendation(topic.id, 1, RecKind.topikBaru,
            'Mulai fondasi ${topic.title}.'));
        break;
      }
    }
    // 6. Evaluasi akhir bila satu topik sudah 6+ upaya & stabil ≥ 70%.
    for (final t in _log.keys) {
      if (out.length >= limit) break;
      final s = stat(t);
      if (s.attempts >= 6 && s.accuracyRecent >= 0.7) {
        out.add(Recommendation(t, tierOf(t), RecKind.evaluasi,
            'Siap evaluasi akhir ${_title(t)}.'));
        break;
      }
    }
    return out.take(limit).toList();
  }

  String _title(String topicId) =>
      topicMeta(topicId)?.title ?? topicId;
}
