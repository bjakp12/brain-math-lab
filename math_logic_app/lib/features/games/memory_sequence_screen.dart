import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';

/// Layar 10 — Memory Training urutan angka (working memory).
class MemorySequenceScreen extends StatefulWidget {
  const MemorySequenceScreen({super.key});
  @override
  State<MemorySequenceScreen> createState() => _MemorySeqState();
}

class _MemorySeqState extends State<MemorySequenceScreen> {
  List<int> target = [7, 2, 9, 4];
  List<int> input = [7, 2];
  int recallSecs = 2;
  bool recallPhase = true;
  Timer? timer;
  final rnd = Random(7);

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!recallPhase) return;
      if (recallSecs > 0) setState(() => recallSecs--);
      if (recallSecs == 0) setState(() => recallPhase = false);
    });
  }

  @override
  void dispose() { timer?.cancel(); super.dispose(); }

  void _newRound() {
    setState(() {
      target = List.generate(4, (_) => rnd.nextInt(10));
      input = [];
      recallSecs = 3;
      recallPhase = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => context.pop()),
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('URUTAN ANGKA', style: t.labelSmall),
          Text('Active Sequence Session', style: t.titleMedium),
        ]),
        actions: const [
          Chip(label: Text('Lv. 4'), avatar: Icon(Icons.military_tech, size: 14)),
          SizedBox(width: 6),
          Chip(label: Text('3'), avatar: Icon(Icons.favorite, size: 14, color: Colors.red)),
          SizedBox(width: 40),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: scheme.surfaceContainerLow, borderRadius: BorderRadius.circular(24)),
            child: Column(children: [
              Row(children: [
                Container(width: 28, height: 28, decoration: const BoxDecoration(color: AppColors.primaryContainer, shape: BoxShape.circle),
                    child: const Icon(Icons.psychology, size: 15, color: Colors.white)),
                const SizedBox(width: 8),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Latihan Kognitif', style: t.labelSmall),
                  Text('Level 5 (Aktif)', style: t.titleSmall),
                ]),
                const Spacer(),
                const Row(children: [
                  Icon(Icons.favorite, size: 16, color: Colors.red),
                  Icon(Icons.favorite, size: 16, color: Colors.red),
                  Icon(Icons.favorite_border, size: 16, color: AppColors.outline),
                  SizedBox(width: 4), Text('2/3', style: TextStyle(fontSize: 11)),
                ]),
              ]),
              const SizedBox(height: 8),
              Row(children: [
                Text('680', style: t.displaySmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w800)),
                const Text(' PTS', style: TextStyle(fontSize: 11)),
                const Spacer(),
                Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(color: AppColors.tertiaryContainer.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(999)),
                    child: const Text('Combo x2', style: TextStyle(fontSize: 11, color: AppColors.tertiary, fontWeight: FontWeight.w700))),
                const SizedBox(width: 6),
                Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(color: AppColors.secondaryFixed, borderRadius: BorderRadius.circular(999)),
                    child: const Text('Akurasi 94%', style: TextStyle(fontSize: 11, color: AppColors.onSecondaryFixedVariant))),
              ]),
            ]),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: scheme.surfaceContainer, borderRadius: BorderRadius.circular(18)),
            child: Column(children: [
              const Row(children: [
                PillLike('INGAT & KETIK URUTAN'),
                Spacer(),
                Text('Working Memory • 4 Digit', style: TextStyle(fontSize: 11)),
              ]),
              const SizedBox(height: 8),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Row(children: [Icon(Icons.timer_outlined, size: 14, color: AppColors.primary), SizedBox(width: 4), Text('Sisa Waktu Mengingat', style: TextStyle(fontSize: 11))]),
                Text('0$recallSecs dtk', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 12)),
              ]),
              const SizedBox(height: 4),
              ClipRRect(borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(value: recallSecs / 3, minHeight: 8,
                      backgroundColor: scheme.surfaceContainerHighest, valueColor: const AlwaysStoppedAnimation(AppColors.primary))),
            ]),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: scheme.surfaceContainerLow, borderRadius: BorderRadius.circular(24)),
            child: Column(children: [
              Row(children: [
                const Icon(Icons.psychology_alt_outlined, color: AppColors.primary, size: 18),
                const SizedBox(width: 4),
                Text('Target Urutan', style: t.titleSmall),
                const Spacer(),
                Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(color: AppColors.tertiaryContainer.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(999)),
                    child: Text(recallPhase ? 'Fase Visual' : 'Fase Input', style: const TextStyle(fontSize: 11, color: AppColors.tertiary))),
              ]),
              const SizedBox(height: 8),
              Row(children: [
                for (final n in target)
                  Expanded(child: Container(height: 62, margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(color: scheme.surfaceContainerLowest, borderRadius: BorderRadius.circular(16)),
                      child: Center(child: Text(recallPhase ? '$n' : '•',
                          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.primary))))),
              ]),
              const SizedBox(height: 8),
              const Text('Hafalkan posisi dan urutan angka sebelum kartu otomatis tertutup!', textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
            ]),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: scheme.surfaceContainerHighest.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(24)),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Masukkan Urutan Angka:', style: t.titleSmall),
                Text('${input.length} dari 4 digit', style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w700)),
              ]),
              const SizedBox(height: 8),
              Row(children: List.generate(4, (i) {
                final filled = i < input.length;
                final active = i == input.length;
                return Expanded(child: Container(height: 54, margin: EdgeInsets.only(right: i == 3 ? 0 : 8),
                    decoration: BoxDecoration(
                        color: filled ? AppColors.primaryContainer : active ? scheme.surfaceContainerLowest : scheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(16)),
                    child: Center(child: Text(filled ? '${input[i]}' : active ? '–' : '•',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800,
                            color: filled ? Colors.white : scheme.onSurfaceVariant)))));
              })),
            ]),
          ),
          const SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 3, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: 2.2,
            children: [
              for (var n = 1; n <= 9; n++)
                _Key(label: '$n', onTap: recallPhase ? null : () { if (input.length < 4) setState(() => input.add(n)); }),
              _Key(label: 'CLEAR', small: true, danger: true, onTap: () => setState(() => input.clear())),
              _Key(label: '0', onTap: recallPhase ? null : () { if (input.length < 4) setState(() => input.add(0)); }),
              _Key(icon: Icons.backspace_outlined, onTap: () { if (input.isNotEmpty) setState(() => input.removeLast()); }),
            ],
          ),
          const SizedBox(height: 10),
          FilledButton(
            onPressed: input.length < 4 ? null : () {
              final ok = input.join() == target.join();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(ok ? 'Benar! +25 XP 🎉' : 'Belum tepat. Target: ${target.join()}'),
                  backgroundColor: ok ? AppColors.tertiaryContainer : AppColors.error));
              if (ok) Future.delayed(const Duration(milliseconds: 600), _newRound);
            },
            child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('Konfirmasi Jawaban (+25 XP)'), SizedBox(width: 6), Icon(Icons.check_circle_outline, size: 18),
            ]),
          ),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: FilledButton.tonal(
                onPressed: () => setState(() { recallPhase = true; recallSecs = 3; }),
                child: const Text('Ulangi Pengingat (1 💡)', style: TextStyle(fontSize: 12)))),
            const SizedBox(width: 8),
            Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(color: scheme.surfaceContainerLow, borderRadius: BorderRadius.circular(999)),
                child: const Row(children: [
                  Icon(Icons.cloud_done_outlined, size: 14, color: AppColors.tertiary),
                  SizedBox(width: 4), Text('Mode Offline', style: TextStyle(fontSize: 11)),
                ])),
          ]),
        ]),
      ),
    );
  }
}

class PillLike extends StatelessWidget {
  final String text;
  const PillLike(this.text, {super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: AppColors.primaryContainer, borderRadius: BorderRadius.circular(999)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.visibility, size: 13, color: Colors.white),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w700)),
      ]),
    );
  }
}

class _Key extends StatelessWidget {
  final String? label; final IconData? icon; final VoidCallback? onTap; final bool small; final bool danger;
  const _Key({this.label, this.icon, this.onTap, this.small = false, this.danger = false});
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap, borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(color: danger ? scheme.surfaceContainerHigh : scheme.surfaceContainer, borderRadius: BorderRadius.circular(16)),
        child: Center(child: icon != null
            ? Icon(icon, size: 20)
            : Text(label!, style: TextStyle(fontSize: small ? 13 : 20, fontWeight: FontWeight.w800,
                color: danger ? AppColors.error : null))),
      ),
    );
  }
}
