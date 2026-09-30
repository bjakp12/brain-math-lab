import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/data/app_state.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/app_widgets.dart';

/// Layar 9 — Speed Training Aritmatika: ronde 4/10, timer, nyawa, grid 2x2.
class SpeedTrainingScreen extends ConsumerStatefulWidget {
  const SpeedTrainingScreen({super.key});
  @override
  ConsumerState<SpeedTrainingScreen> createState() => _SpeedState();
}

class _SpeedState extends ConsumerState<SpeedTrainingScreen> {
  int round = 4, score = 450, combo = 3, lives = 1, secs = 8;
  int a = 48, b = 6;
  int? selected;
  Timer? timer;
  final rnd = Random(42);

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secs > 0) setState(() => secs--);
      if (secs == 0) _next(false);
    });
  }

  @override
  void dispose() { timer?.cancel(); super.dispose(); }

  int get ans => a ~/ b;
  List<int> get opts => [ans - 2, ans - 1, ans, ans + 1];

  void _next(bool correct) {
    if (correct) {
      score += 50 + combo * 5;
      combo++;
      ref.read(profileProvider.notifier).addXp(15);
    } else {
      lives--;
      combo = 0;
      if (lives <= 0) {
        timer?.cancel();
        showDialog(context: context, builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Text('Sesi Selesai!'), content: Text('Skor akhir: $score PTS'),
          actions: [FilledButton(onPressed: () => context.go('/math/hasil?cat=aritmatika'), child: const Text('Lihat Hasil'))],
        ));
        return;
      }
    }
    if (round >= 10) {
      timer?.cancel();
      context.push('/math/hasil?cat=aritmatika');
      return;
    }
    setState(() {
      round++; secs = 8; selected = null;
      b = 2 + rnd.nextInt(9);
      final q = 2 + rnd.nextInt(9);
      a = q * b;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => showExitDialog(context, onExit: () => context.pop())),
        title: const Text('Speed Training Aritmatika'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: scheme.surfaceContainerLow, borderRadius: BorderRadius.circular(24)),
            child: Column(children: [
              Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Text('TARGET RONDE', style: t.labelSmall),
                    const SizedBox(width: 6),
                    Text('$round/10', style: t.titleSmall?.copyWith(color: scheme.primary, fontWeight: FontWeight.w800)),
                  ]),
                  const SizedBox(height: 4),
                  Row(children: List.generate(10, (i) => Container(
                    width: i == round - 1 ? 16 : 8, height: 8, margin: const EdgeInsets.only(right: 4),
                    decoration: BoxDecoration(color: i < round ? scheme.primary : scheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(999)),
                  ))),
                ])),
                Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: scheme.surfaceContainerHigh, borderRadius: BorderRadius.circular(999)),
                    child: Row(children: [
                      const Icon(Icons.bolt, size: 14, color: AppColors.primary),
                      Text('$score', style: const TextStyle(fontWeight: FontWeight.w800)), const Text(' PTS', style: TextStyle(fontSize: 10)),
                    ])),
                const SizedBox(width: 6),
                Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.tertiaryContainer, borderRadius: BorderRadius.circular(999)),
                    child: Text('Combo x$combo', style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w700))),
              ]),
              const SizedBox(height: 10),
              Row(children: [
                Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: scheme.surfaceContainerHighest.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(999)),
                    child: Row(children: [
                      const Icon(Icons.timer_outlined, size: 16, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text('00:${secs.toString().padLeft(2, '0')}', style: TextStyle(color: scheme.primary, fontWeight: FontWeight.w800)),
                      const Text(' detik', style: TextStyle(fontSize: 11)),
                    ])),
                const Spacer(),
                Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: AppColors.errorContainer.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(999)),
                    child: const Row(children: [
                      Text('Nyawa: ', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                      Icon(Icons.heart_broken, size: 16, color: AppColors.error),
                      Icon(Icons.heart_broken, size: 16, color: AppColors.error),
                      Icon(Icons.favorite, size: 16, color: AppColors.error),
                    ])),
              ]),
            ]),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity, padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(color: scheme.surfaceContainer, borderRadius: BorderRadius.circular(24)),
            child: Column(children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: scheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(999)),
                  child: const Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.circle, size: 8, color: AppColors.secondary),
                    SizedBox(width: 6),
                    Text('Level: Pembagian Cepat', style: TextStyle(fontSize: 11)),
                    SizedBox(width: 6),
                    Text('+50 Poin Kilat', style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w700)),
                  ])),
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('$a', style: t.displayMedium?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(width: 10),
                const Text('÷', style: TextStyle(fontSize: 40, color: AppColors.primary, fontWeight: FontWeight.w700)),
                const SizedBox(width: 10),
                Text('$b', style: t.displayMedium?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(width: 10),
                const Text('=', style: TextStyle(fontSize: 36, color: AppColors.outline)),
                const SizedBox(width: 10),
                Container(width: 52, height: 52, decoration: BoxDecoration(color: AppColors.primaryContainer.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(14)),
                    child: const Center(child: Text('?', style: TextStyle(fontSize: 30, color: AppColors.primary, fontWeight: FontWeight.w800)))),
              ]),
              const SizedBox(height: 6),
              Text('Sentuh opsi yang benar secepat mungkin!', style: t.labelSmall),
            ]),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.tertiaryContainer.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(18)),
            child: Row(children: [
              Container(width: 30, height: 30, decoration: const BoxDecoration(color: AppColors.tertiaryContainer, shape: BoxShape.circle),
                  child: const Icon(Icons.speed, size: 16, color: Colors.white)),
              const SizedBox(width: 8),
              const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Refleks: 0.85s (Kilat!)', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.tertiary, fontSize: 13)),
                Text('Optimal untuk akselerasi neuroplastik', style: TextStyle(fontSize: 11)),
              ])),
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: scheme.surfaceContainerLowest, borderRadius: BorderRadius.circular(8)),
                  child: const Text('+15 XP', style: TextStyle(fontSize: 11, color: AppColors.tertiary, fontWeight: FontWeight.w800))),
            ]),
          ),
          const SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 1.5,
            children: List.generate(4, (i) {
              final v = opts[i];
              final sel = selected == i;
              final isAns = v == ans;
              return InkWell(
                onTap: () {
                  setState(() => selected = i);
                  Future.delayed(const Duration(milliseconds: 350), () => _next(isAns));
                },
                borderRadius: BorderRadius.circular(22),
                child: Stack(clipBehavior: Clip.none, children: [
                  Container(
                    decoration: BoxDecoration(
                        color: sel ? AppColors.primary : scheme.surfaceContainerLow, borderRadius: BorderRadius.circular(22)),
                    child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Text('$v', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: sel ? Colors.white : null)),
                      Text('OPSI ${'ABCD'[i]}', style: TextStyle(fontSize: 11, color: sel ? Colors.white70 : scheme.outline)),
                    ])),
                  ),
                  if (sel && isAns)
                    Positioned(right: -6, top: -6, child: Container(width: 26, height: 26,
                        decoration: const BoxDecoration(color: AppColors.tertiaryContainer, shape: BoxShape.circle),
                        child: const Icon(Icons.check, size: 15, color: Colors.white))),
                ]),
              );
            }),
          ),
          const SizedBox(height: 10),
          const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.cloud_done_outlined, size: 14, color: AppColors.tertiary),
            SizedBox(width: 4),
            Text('Mode offline aktif • Skor disinkronkan otomatis', style: TextStyle(fontSize: 11)),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: FilledButton.tonal(
                onPressed: () => showDialog(context: context, builder: (_) => const AlertDialog(
                    title: Text('Jeda'), content: Text('Fokus kembali saat Anda siap!'))),
                child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.pause_circle_outline, size: 18), SizedBox(width: 6), Text('Jeda Latihan'),
                ]))),
            const SizedBox(width: 10),
            Expanded(child: FilledButton(
                style: FilledButton.styleFrom(backgroundColor: AppColors.errorContainer, foregroundColor: AppColors.onErrorContainer),
                onPressed: () => showExitDialog(context, onExit: () => context.pop()),
                child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.stop_circle_outlined, size: 18), SizedBox(width: 6), Text('Akhiri Sesi'),
                ]))),
          ]),
        ]),
      ),
    );
  }
}
