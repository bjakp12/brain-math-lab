import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/data/generators.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/app_widgets.dart';

/// Layar 6 — Halaman Soal. Progress, kartu soal + visual pecahan,
/// opsi A-D, hint collapsible, CTA Periksa Jawaban.
class QuestionScreen extends StatefulWidget {
  final String categoryId; final int index;
  const QuestionScreen({super.key, required this.categoryId, required this.index});
  @override
  State<QuestionScreen> createState() => _QuestionState();
}

class _QuestionState extends State<QuestionScreen> {
  String? picked = 'B';
  bool showHint = false;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final q = generateForCategory(widget.categoryId, 2, widget.index);
    final total = 10;
    final pct = (widget.index + 1) / total;
    return Scaffold(
      appBar: AppTopBar(title: 'Latihan Pecahan', showBack: true, timer: const TimerBadge('00:45')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            Text('SOAL ${widget.index + 1} DARI $total', style: t.labelMedium?.copyWith(color: scheme.primary, fontWeight: FontWeight.w800)),
            const SizedBox(width: 6),
            Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.outlineVariant, shape: BoxShape.circle)),
            const SizedBox(width: 6),
            Text('Pecahan Aljabar', style: t.bodySmall),
            const Spacer(),
            const Pill('⚡ Menengah', bg: Color(0xFFE0E7FF), fg: AppColors.secondary),
          ]),
          const SizedBox(height: 6),
          AppProgressBar(pct, height: 10),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: scheme.surfaceContainerLow, borderRadius: BorderRadius.circular(24)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(width: 32, height: 32, decoration: BoxDecoration(color: AppColors.primaryContainer.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.functions, color: AppColors.primary)),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(q.stem, style: t.headlineSmall?.copyWith(fontSize: 20)),
                  const SizedBox(height: 4),
                  Text('Sederhanakan pembilang dan penyebut dengan mencari faktor persekutuan terbesar (FPB).',
                      style: t.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
                ])),
              ]),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: scheme.surfaceContainerLowest, borderRadius: BorderRadius.circular(18)),
                child: Column(children: [
                  Row(children: [
                    const Icon(Icons.pie_chart_outline, size: 16, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text('Representasi 18 Bagian dari 24', style: t.labelMedium),
                    const Spacer(),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(color: scheme.surfaceContainerHigh, borderRadius: BorderRadius.circular(999)),
                        child: const Text('75% Penuh', style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w700))),
                  ]),
                  const SizedBox(height: 10),
                  SizedBox(width: 170, height: 170, child: Stack(alignment: Alignment.center, children: [
                    SizedBox(width: 170, height: 170, child: CircularProgressIndicator(value: 0.75, strokeWidth: 16,
                        backgroundColor: scheme.surfaceContainer, valueColor: const AlwaysStoppedAnimation(AppColors.primary))),
                    SizedBox(width: 110, height: 110, child: CircularProgressIndicator(value: 0.75, strokeWidth: 8,
                        backgroundColor: scheme.surfaceContainerHighest, valueColor: const AlwaysStoppedAnimation(AppColors.secondaryContainer))),
                    Column(mainAxisSize: MainAxisSize.min, children: [
                      Text('18', style: t.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                      Container(width: 26, height: 2, color: AppColors.outlineVariant, margin: const EdgeInsets.symmetric(vertical: 3)),
                      Text('24', style: t.headlineSmall?.copyWith(color: scheme.onSurfaceVariant)),
                    ]),
                  ])),
                  const SizedBox(height: 8),
                  const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    _Legend(dot: AppColors.primary, label: 'Nilai pecahan (18/24)'),
                    SizedBox(width: 12),
                    _Legend(dot: AppColors.secondaryContainer, label: 'Bentuk ekuivalen (3/4)'),
                  ]),
                ]),
              ),
            ]),
          ),
          const SizedBox(height: 12),
          for (final o in q.options) ...[
            _OptionCard(
              label: o.label, text: o.text, sub: _subFor(o.label),
              selected: picked == o.label,
              onTap: () => setState(() => picked = o.label),
            ),
            const SizedBox(height: 8),
          ],
          Center(
            child: TextButton.icon(
              onPressed: () => setState(() => showHint = !showHint),
              icon: const Icon(Icons.lightbulb_outline, color: AppColors.secondary),
              label: Text(showHint ? 'Tutup Petunjuk' : 'Butuh bantuan? Buka Petunjuk'),
              style: TextButton.styleFrom(backgroundColor: scheme.surfaceContainerHigh, shape: const StadiumBorder()),
            ),
          ),
          if (showHint)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.primaryFixed.withValues(alpha: 0.35), borderRadius: BorderRadius.circular(16)),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Icon(Icons.tips_and_updates, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(child: Text(q.hint, style: t.bodySmall)),
              ]),
            ),
        ]),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
        decoration: BoxDecoration(color: scheme.surface.withValues(alpha: 0.95),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 20, offset: const Offset(0, -4))]),
        child: SafeArea(
          top: false,
          child: Row(children: [
            FilledButton.tonal(onPressed: () {}, child: const Icon(Icons.draw_outlined)),
            const SizedBox(width: 10),
            Expanded(
              child: FilledButton(
                onPressed: picked == null ? null : () => context.push('/math/bahas?cat=${widget.categoryId}&idx=${widget.index}&pick=$picked'),
                child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('Periksa Jawaban'), SizedBox(width: 6), Icon(Icons.arrow_forward, size: 18),
                ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

String _subFor(String label) {
  switch (label) {
    case 'A': return 'Dua pertiga';
    case 'B': return 'Tiga perempat (Tersederhana)';
    case 'C': return 'Empat perlima';
    default: return 'Sembilan perduabelas (Belum paling sederhana)';
  }
}

class _Legend extends StatelessWidget {
  final Color dot; final String label;
  const _Legend({required this.dot, required this.label});
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(width: 10, height: 10, decoration: BoxDecoration(color: dot, shape: BoxShape.circle)),
      const SizedBox(width: 4),
      Text(label, style: const TextStyle(fontSize: 10)),
    ]);
  }
}

class _OptionCard extends StatelessWidget {
  final String label; final String text; final String sub;
  final bool selected; final VoidCallback onTap;
  const _OptionCard({required this.label, required this.text, required this.sub, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap, borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryFixed.withValues(alpha: 0.45) : scheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(22),
          border: selected ? Border.all(color: AppColors.primary, width: 1.5) : null,
        ),
        child: Row(children: [
          Container(width: 40, height: 40,
              decoration: BoxDecoration(color: selected ? AppColors.primary : scheme.surfaceContainerHigh, borderRadius: BorderRadius.circular(14)),
              child: Center(child: Text(label, style: TextStyle(fontWeight: FontWeight.w800, color: selected ? Colors.white : null)))),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(text, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
            Text(sub, style: TextStyle(fontSize: 11, color: selected ? AppColors.primary : scheme.onSurfaceVariant)),
          ])),
          Container(width: 24, height: 24,
              decoration: BoxDecoration(shape: BoxShape.circle, color: selected ? AppColors.primary : scheme.surfaceContainerHigh),
              child: selected ? const Icon(Icons.check, size: 14, color: Colors.white) : null),
        ]),
      ),
    );
  }
}
