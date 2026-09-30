import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/data/question_bank.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/app_widgets.dart';

/// Layar 5 — Detail Materi Pecahan & Desimal.
class MaterialDetailScreen extends StatelessWidget {
  final String categoryId;
  const MaterialDetailScreen({super.key, required this.categoryId});
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final subs = pecahanSubMateri();
    return Scaffold(
      appBar: const AppTopBar(title: 'Latihan Pecahan', showBack: true, timer: TimerBadge('00:45')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Row(children: [
            Pill('●  Bab 2 • Matematika Menengah', bg: AppColors.secondaryFixed, fg: AppColors.onSecondaryFixed),
            SizedBox(width: 6),
            Pill('⚡ Modul Cepat', bg: AppColors.tertiaryContainer, fg: Colors.white),
          ]),
          const SizedBox(height: 8),
          Text('Pecahan & Desimal', style: t.headlineMedium?.copyWith(fontWeight: FontWeight.w700)),
          Text('Pecahan Biasa, Senilai & Penyederhanaan FPB', style: t.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: scheme.surfaceContainerLow, borderRadius: BorderRadius.circular(24)),
            child: Column(children: [
              Row(children: [
                const Icon(Icons.donut_large, color: AppColors.primary, size: 18),
                const SizedBox(width: 6),
                Text('Progres Submateri', style: t.titleSmall),
                const Spacer(),
                Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(color: AppColors.primaryFixed, borderRadius: BorderRadius.circular(999)),
                    child: const Text('2 dari 4 Selesai (50%)',
                        style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w700))),
              ]),
              const SizedBox(height: 8),
              const Row(children: [
                Expanded(child: AppProgressBar(1.0, color: AppColors.tertiaryFixedDim)),
                SizedBox(width: 4),
                Expanded(child: AppProgressBar(1.0)),
                SizedBox(width: 4),
                Expanded(child: AppProgressBar(0.0)),
                SizedBox(width: 4),
                Expanded(child: AppProgressBar(0.0)),
              ]),
              const SizedBox(height: 10),
              const Row(children: [
                _MiniStat(icon: Icons.schedule, label: 'Estimasi', value: '15 Menit'),
                SizedBox(width: 8),
                _MiniStat(icon: Icons.stars, label: 'Reward', value: '+40 XP', valueColor: AppColors.primary),
                SizedBox(width: 8),
                _MiniStat(icon: Icons.crisis_alert, label: 'Target', value: '≥ 80%', valueColor: AppColors.tertiaryContainer),
              ]),
            ]),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: scheme.surfaceContainerHigh, borderRadius: BorderRadius.circular(24)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(width: 36, height: 36, decoration: BoxDecoration(color: AppColors.primaryContainer, borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.lightbulb, color: Colors.white, size: 20)),
                const SizedBox(width: 8),
                Text('Ringkasan Konsep Dasar', style: t.titleMedium),
                const Spacer(),
                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: scheme.surfaceContainerLowest, borderRadius: BorderRadius.circular(8)),
                    child: const Text('TEORI INTI', style: TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.w700))),
              ]),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: scheme.surfaceContainerLowest, borderRadius: BorderRadius.circular(16)),
                child: Column(children: [
                  const Text('Pecahan menyatakan porsi bagian dari keseluruhan dalam format a / b, di mana a adalah pembilang dan b adalah penyebut (b ≠ 0).'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: scheme.surfaceContainerLow, borderRadius: BorderRadius.circular(12)),
                    child: const Column(children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('Representasi Nilai Ekuivalen:', style: TextStyle(fontSize: 11)),
                        Text('Nilai Sama', style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w700)),
                      ]),
                      SizedBox(height: 6),
                      Row(children: [
                        _FracCell(v: '1/2', s: 'Sederhana', hl: true),
                        SizedBox(width: 6),
                        _FracCell(v: '2/4', s: 'Senilai'),
                        SizedBox(width: 6),
                        _FracCell(v: '0.5', s: 'Desimal'),
                        SizedBox(width: 6),
                        _FracCell(v: '50%', s: 'Persentase', green: true),
                      ]),
                    ]),
                  ),
                ]),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: AppColors.secondaryFixed, borderRadius: BorderRadius.circular(16)),
                child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Icon(Icons.verified, size: 18, color: AppColors.primary),
                  SizedBox(width: 6),
                  Expanded(child: Text('Aturan Utama: Membagi pembilang dan penyebut dengan FPB menghasilkan bentuk pecahan paling ringkas.',
                      style: TextStyle(fontSize: 12))),
                ]),
              ),
            ]),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: scheme.surfaceContainerLow, borderRadius: BorderRadius.circular(24)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(width: 30, height: 30, decoration: const BoxDecoration(color: AppColors.secondary, shape: BoxShape.circle),
                    child: const Icon(Icons.speed, size: 16, color: Colors.white)),
                const SizedBox(width: 8),
                Text('Contoh Kilat: Menyederhanakan 18/24', style: t.titleSmall),
              ]),
              const SizedBox(height: 8),
              const _StepRow(n: '1', text: 'Cari FPB dari 18 dan 24, diperoleh 6.'),
              const SizedBox(height: 6),
              const _StepRow(n: '2', text: 'Bagi serentak: 18 ÷ 6 = 3 dan 24 ÷ 6 = 4.'),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: scheme.surfaceContainerLowest, borderRadius: BorderRadius.circular(16)),
                child: Row(children: [
                  Container(width: 24, height: 24, decoration: const BoxDecoration(color: AppColors.tertiaryFixed, shape: BoxShape.circle),
                      child: const Center(child: Text('3', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800)))),
                  const SizedBox(width: 8),
                  const Text('Bentuk tersederhana:'),
                  const Spacer(),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                      decoration: BoxDecoration(color: AppColors.tertiaryFixed.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(10)),
                      child: const Text('3/4', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.tertiaryContainer))),
                ]),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: scheme.surfaceContainer, borderRadius: BorderRadius.circular(16)),
                child: const Row(children: [
                  Icon(Icons.tips_and_updates_outlined, color: AppColors.primary),
                  SizedBox(width: 8),
                  Expanded(child: Text('Tip Pintar: Langsung gunakan FPB tertinggi agar tidak perlu menyederhanakan berulang kali saat ujian dengan timer aktif.',
                      style: TextStyle(fontSize: 12))),
                ]),
              ),
            ]),
          ),
          const SizedBox(height: 14),
          Row(children: [
            Text('Daftar Submateri', style: t.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
            const Spacer(),
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(color: scheme.surfaceContainer, borderRadius: BorderRadius.circular(999)),
                child: const Text('4 Submateri', style: TextStyle(fontSize: 11))),
          ]),
          const SizedBox(height: 8),
          for (final s in subs) ...[
            _SubRow(sub: s),
            const SizedBox(height: 8),
          ],
        ]),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
        decoration: BoxDecoration(color: scheme.surface.withValues(alpha: 0.95),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 20, offset: const Offset(0, -4))]),
        child: SafeArea(
          top: false,
          child: Row(children: [
            FilledButton.tonal(onPressed: () {}, child: const Icon(Icons.menu_book_outlined)),
            const SizedBox(width: 10),
            Expanded(
              child: FilledButton(
                onPressed: () => context.push('/math/soal?cat=$categoryId&idx=0'),
                child: const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Row(children: [Icon(Icons.rocket_launch, size: 18), SizedBox(width: 6), Text('Mulai Latihan')]),
                  Text('10 Soal • +20 XP', style: TextStyle(fontSize: 11)),
                ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon; final String label; final String value; final Color? valueColor;
  const _MiniStat({required this.icon, required this.label, required this.value, this.valueColor});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainer, borderRadius: BorderRadius.circular(14)),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon, size: 13, color: AppColors.secondary), const SizedBox(width: 3),
            Text(label, style: const TextStyle(fontSize: 10)),
          ]),
          Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: valueColor)),
        ]),
      ),
    );
  }
}

class _FracCell extends StatelessWidget {
  final String v; final String s; final bool hl; final bool green;
  const _FracCell({required this.v, required this.s, this.hl = false, this.green = false});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerLowest, borderRadius: BorderRadius.circular(10)),
        child: Column(children: [
          Text(v, style: TextStyle(fontWeight: FontWeight.w800,
              color: hl ? AppColors.primary : green ? AppColors.tertiaryContainer : null)),
          Text(s, style: const TextStyle(fontSize: 10)),
        ]),
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  final String n; final String text;
  const _StepRow({required this.n, required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerLowest, borderRadius: BorderRadius.circular(16)),
      child: Row(children: [
        Container(width: 24, height: 24, decoration: const BoxDecoration(color: AppColors.primaryFixed, shape: BoxShape.circle),
            child: Center(child: Text(n, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.primary)))),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
      ]),
    );
  }
}

class _SubRow extends StatelessWidget {
  final SubMateri sub;
  const _SubRow({required this.sub});
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (sub.state == 'berjalan') {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.primaryContainer, borderRadius: BorderRadius.circular(24)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Row(children: [
            Text('MATERI UTAMA LATIHAN', style: TextStyle(fontSize: 10, color: Colors.white70, fontWeight: FontWeight.w700)),
            Spacer(),
            Text('Sedang Berjalan', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700)),
          ]),
          const SizedBox(height: 4),
          Text('3. Penyederhanaan Pecahan & FPB', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
          const Text('Mencari FPB pembilang-penyebut untuk bentuk paling sederhana dengan cara termudah.',
              style: TextStyle(fontSize: 12, color: Colors.white70)),
          const SizedBox(height: 8),
          const Row(children: [
            Pill('📖 10 Soal Tersedia', bg: AppColors.secondaryContainer, fg: Colors.white),
            SizedBox(width: 6),
            Pill('⏱ ~8 mnt', bg: AppColors.secondaryContainer, fg: Colors.white),
          ]),
        ]),
      );
    }
    final done = sub.state == 'selesai';
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: done ? scheme.surfaceContainerLowest : scheme.surfaceContainerLow, borderRadius: BorderRadius.circular(20)),
      child: Row(children: [
        Container(width: 40, height: 40,
            decoration: BoxDecoration(
                color: done ? AppColors.tertiaryContainer : scheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(14)),
            child: Icon(done ? Icons.check : Icons.lock, color: done ? Colors.white : scheme.outline)),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text(sub.title, style: Theme.of(context).textTheme.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis)),
            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: done ? AppColors.tertiaryFixed : scheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(8)),
                child: Text(sub.badge, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700))),
          ]),
          Text(sub.desc, style: Theme.of(context).textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
        ])),
      ]),
    );
  }
}
