import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../logic/learner_model.dart';

/// Outbox tersimpan: setiap upaya/XP dicatat lokal dulu, dikirim saat online.
/// Ini "backend" aplikasi: 100% berfungsi offline; sinkronisasi cloud aktif
/// segera setelah RemoteBackend dikonfigurasi (lihat BACKEND.md — Firebase).
class OutboxEntry {
  final String id;
  final String type; // attempt | xp | session
  final Map<String, dynamic> payload;
  final String createdAt;
  const OutboxEntry({
    required this.id, required this.type,
    required this.payload, required this.createdAt,
  });

  Map<String, dynamic> toJson() =>
      {'id': id, 'type': type, 'payload': payload, 'createdAt': createdAt};

  static OutboxEntry fromJson(Map<String, dynamic> m) => OutboxEntry(
        id: m['id'] as String,
        type: m['type'] as String,
        payload: Map<String, dynamic>.from(m['payload'] as Map),
        createdAt: m['createdAt'] as String,
      );
}

/// Tujuan kirim saat online. Default: dev/null (log). Ganti dengan
/// FirebaseBackend/SupabaseBackend mengikuti BACKEND.md.
typedef RemoteSender = Future<void> Function(List<Map<String, dynamic>> batch);

Future<void> _devNullSender(List<Map<String, dynamic>> batch) async {
  // ignore: avoid_print
  print('[sync] ${batch.length} entri siap dikirim (remote belum dikonfigurasi).');
}

Future<bool> _defaultIsOnline() async {
  final r = await Connectivity().checkConnectivity();
  return r.contains(ConnectivityResult.mobile) ||
      r.contains(ConnectivityResult.wifi) ||
      r.contains(ConnectivityResult.ethernet);
}

class SyncEngine {
  static const _key = 'sync_outbox_v1';
  final RemoteSender remote;
  final Future<bool> Function() isOnline;
  const SyncEngine(
      {this.remote = _devNullSender, this.isOnline = _defaultIsOnline});

  Future<List<OutboxEntry>> pending() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? const [];
    return [
      for (final s in raw)
        OutboxEntry.fromJson(
            Map<String, dynamic>.from(jsonDecode(s) as Map)),
    ];
  }

  Future<void> enqueue(OutboxEntry e) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? <String>[];
    raw.add(jsonEncode(e.toJson()));
    await prefs.setStringList(_key, raw);
  }

  Future<void> recordAttempt(Attempt a) => enqueue(OutboxEntry(
        id: 'a-${DateTime.now().microsecondsSinceEpoch}',
        type: 'attempt',
        payload: {
          'topic': a.topicId,
          'tier': a.tier,
          'correct': a.correct,
          'seconds': a.seconds,
          'confidence': a.confidence,
        },
        createdAt: DateTime.now().toIso8601String(),
      ));

  /// Kirim antrean (batch 50). Berhasil -> antrean dikosongkan.
  /// Mengembalikan sisa antrean.
  Future<int> flush() async {
    if (!await isOnline()) return (await pending()).length;
    final all = await pending();
    if (all.isEmpty) return 0;
    const batchSize = 50;
    for (var i = 0; i < all.length; i += batchSize) {
      final batch = all.sublist(
          i, i + batchSize > all.length ? all.length : i + batchSize);
      await remote([for (final e in batch) e.toJson()]);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
    return 0;
  }
}

final syncEngineProvider = Provider<SyncEngine>((ref) => SyncEngine());

