import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/data/generators.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/app_widgets.dart';

/// Layar 7 — Pembahasan Jawaban (banner benar/salah + langkah + jebakan).
class ExplanationScreen extends StatelessWidget {
  final String categoryId; final int index; final String picked;
  const ExplanationScreen({super.key, required this.categoryId, required this.index, required this.picked});
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final q = generateForCategory(categoryId, 2, index);
    final correct = picked == q.answer;
    final last = index >= 9;
    return Scaffold(
      appBar: AppTopBar(title: 'Latihan Pecahan', showBack: true, timer: const TimerBadge('00:45')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: correct ? AppColors.tertiaryContainer : AppColors.errorContainer,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(width: 32, height: 32, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
                    child: Icon(correct ? Icons.check_circle : Icons.cancel, color: Colors.white)),
                const SizedBox(width: 8),
                Text(correct ? 'JAWABAN KAMU\nBENAR!' : 'JAWABAN KURANG\nTEPAT',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white, height: 1.1)),
              ]),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Text(correct ? 'Luar biasa! Konsep penyederhanaan pecahanmu sangat tepat.'
                    : 'Tidak apa-apa, pelajari langkahnya lalu coba lagi!',
                    style: const TextStyle(color: Colors.white70, fontSize: 13)),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Wrap(spacing: 8, children: const [
                  Pill('+10 Poin', bg: Colors.white24, fg: Colors.white, icon: Icons.stars),
                  Pill('15 detik', bg: Colors.white24, fg: Colors.white, icon: Icons.timer_outlined),
                  Pill('🔥 3x Streak', bg: AppColors.tertiaryFixed, fg: AppColors.onTertiaryFixed),
                ]),
              ),
            ]),
          ),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: _AnsCard(title: 'Jawaban Kamu', value: '($picked) ${q.options.firstWhere((o) => o.label == picked).text}',
                foot: correct ? 'Sesuai Kunci' : 'Kurang tepat', ok: correct)),
            const SizedBox(width: 10),
            Expanded(child: _AnsCard(title: 'Kunci Jawaban', value: '(${q.answer}) ${q.options.firstWhere((o) => o.label == q.answer).text}',
                foot: 'Bentuk Sederhana', ok: true, keyAns: true)),
          ]),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: scheme.surfaceContainerLowest, borderRadius: BorderRadius.circular(24)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(width: 36, height: 36, decoration: BoxDecoration(color: AppColors.primaryFixed, borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.functions, color: AppColors.primary)),
                const SizedBox(width: 8),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Langkah Penyelesaian', style: t.titleMedium),
                  Text('Sederhanakan pecahan 18/24', style: t.bodySmall),
                ])),
                Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: scheme.surfaceContainerHigh, borderRadius: BorderRadius.circular(999)),
                    child: const Text('Metode FPB', style: TextStyle(fontSize: 11))),
              ]),
              const SizedBox(height: 10),
              for (var i = 0; i < q.steps.length; i++)
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Column(children: [
                    Container(width: 28, height: 28, decoration: const BoxDecoration(color: AppColors.primaryContainer, shape: BoxShape.circle),
                        child: Center(child: Text('${i + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)))),
                    if (i != q.steps.length - 1) Container(width: 2, height: 28, color: scheme.surfaceContainerHighest, margin: const EdgeInsets.symmetric(vertical: 4)),
                  ]),
                  const SizedBox(width: 10),
                  Expanded(child: Padding(padding: const EdgeInsets.only(top: 4), child: Text(q.steps[i], style: t.bodyMedium))),
                ]),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: scheme.surfaceContainerLow, borderRadius: BorderRadius.circular(14)),
                child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('18 ÷ 6', style: TextStyle(fontWeight: FontWeight.w700)),
                  SizedBox(width: 8), Text('=', style: TextStyle(fontWeight: FontWeight.w700)), SizedBox(width: 8),
                  Text('3/4', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.primary)),
                ]),
              ),
              const Row(children: [
                Icon(Icons.check_circle, size: 14, color: AppColors.tertiary),
                SizedBox(width: 4),
                Text('Diperoleh bentuk paling sederhana 3/4.', style: TextStyle(fontSize: 12, color: AppColors.tertiary)),
              ]),
            ]),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: scheme.surfaceContainerHigh, borderRadius: BorderRadius.circular(18)),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(width: 36, height: 36, decoration: BoxDecoration(color: AppColors.errorContainer, borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.warning_amber_rounded, color: AppColors.error)),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Waspadai Kesalahan Umum', style: t.titleSmall),
                const SizedBox(height: 2),
                Text(q.pitfall, style: t.bodySmall),
              ])),
            ]),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () {
              if (last) { context.push('/math/hasil?cat=$categoryId'); }
              else { context.push('/math/soal?cat=$categoryId&idx=${index + 1}'); }
            },
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(last ? 'Lihat Hasil Akhir' : 'Lanjut Soal Berikutnya'),
              const SizedBox(width: 6), const Icon(Icons.arrow_forward, size: 18),
            ]),
          ),
          const SizedBox(height: 8),
          FilledButton.tonal(
            onPressed: () => context.push('/math/detail?cat=$categoryId'),
            child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.menu_book_outlined, size: 18), SizedBox(width: 6), Text('Ulangi Teori Pecahan'),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _AnsCard extends StatelessWidget {
  final String title; final String value; final String foot; final bool ok; final bool keyAns;
  const _AnsCard({required this.title, required this.value, required this.foot, required this.ok, this.keyAns = false});
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: keyAns ? scheme.surfaceContainer : scheme.surfaceContainerLow, borderRadius: BorderRadius.circular(18)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(title, style: Theme.of(context).textTheme.labelMedium),
          Icon(ok ? Icons.check_circle : Icons.cancel,
              size: 18, color: ok ? AppColors.tertiaryContainer : AppColors.error),
        ]),
        const SizedBox(height: 6),
        Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800, color: keyAns ? AppColors.primary : ok ? AppColors.tertiaryContainer : null)),
        Text(foot, style: const TextStyle(fontSize: 11)),
      ]),
    );
  }
}
