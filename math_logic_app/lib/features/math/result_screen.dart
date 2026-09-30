import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/data/app_state.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/app_widgets.dart';

/// Layar 8 — Hasil Latihan: skor hero, metrik 2x2, hadiah, evaluasi materi.
class ResultScreen extends ConsumerWidget {
  final String categoryId;
  const ResultScreen({super.key, required this.categoryId});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppTopBar(title: 'Latihan Pecahan', showBack: true, timer: const TimerBadge('00:45')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            Container(width: 32, height: 32, decoration: const BoxDecoration(color: AppColors.primaryContainer, shape: BoxShape.circle),
                child: const Icon(Icons.verified, color: Colors.white, size: 18)),
            const SizedBox(width: 8),
            Text('Sesi Selesai', style: t.titleSmall),
            const Spacer(),
            FilledButton.tonal(
              style: FilledButton.styleFrom(minimumSize: const Size(0, 36)),
              onPressed: () => Share.share('Saya meraih skor 80/100 pada Latihan Pecahan di Brain & Math Lab! 🎉'),
              child: const Row(children: [Icon(Icons.share_outlined, size: 16), SizedBox(width: 4), Text('Bagikan')]),
            ),
          ]),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(color: scheme.surfaceContainerLowest, borderRadius: BorderRadius.circular(24)),
            child: Column(children: [
              Stack(alignment: Alignment.bottomRight, children: [
                Container(width: 80, height: 80,
                    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.primary, width: 3)),
                    child: const Icon(Icons.emoji_events, size: 40, color: AppColors.secondary)),
                Container(width: 24, height: 24, decoration: const BoxDecoration(color: AppColors.tertiaryContainer, shape: BoxShape.circle),
                    child: const Icon(Icons.auto_awesome, size: 14, color: Colors.white)),
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('80', style: t.displayLarge?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w800)),
                Padding(padding: const EdgeInsets.only(bottom: 12), child: Text('/ 100', style: t.titleMedium?.copyWith(color: scheme.outline))),
              ]),
              Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.tertiaryFixed, borderRadius: BorderRadius.circular(999)),
                  child: const Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.military_tech, size: 14, color: AppColors.onTertiaryFixed),
                    SizedBox(width: 4),
                    Text('Luar Biasa!', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.onTertiaryFixed)),
                  ])),
              const SizedBox(height: 8),
              Text('Kamu telah menyelesaikan latihan Pecahan & Desimal dengan sangat baik!',
                  textAlign: TextAlign.center, style: t.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
              const SizedBox(height: 10),
              Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: scheme.surfaceContainerHigh.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(999)),
                  child: const Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.bolt, size: 14, color: AppColors.tertiary),
                    SizedBox(width: 4),
                    Text('Kecepatan kalkulasi meningkat +14%', style: TextStyle(fontSize: 11)),
                  ])),
            ]),
          ),
          const SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 1.35,
            children: const [
              MetricCard(label: 'Jawaban Benar', value: '8 / 10 Soal', sub: '80% Tercapai', icon: Icons.check, iconBg: AppColors.tertiaryFixed, iconFg: AppColors.onTertiaryFixed),
              MetricCard(label: 'Perlu Perbaikan', value: '2 / 10 Soal', sub: '2 Keliru', icon: Icons.close, iconBg: AppColors.errorContainer, iconFg: AppColors.onErrorContainer),
              MetricCard(label: 'Total Durasi', value: '04:12', sub: '25 detik / soal', icon: Icons.timer_outlined, iconBg: AppColors.surfaceHigh, iconFg: AppColors.primary),
              MetricCard(label: 'Akurasi Rata-rata', value: '80%', sub: 'Kategori Baik', icon: Icons.insights, iconBg: AppColors.secondaryFixed, iconFg: AppColors.onSecondaryFixedVariant),
            ],
          ),
          const SizedBox(height: 14),
          Row(children: [
            Text('Hadiah & Pencapaian', style: t.titleMedium),
            const Spacer(),
            Text('3 Diperoleh', style: t.labelSmall?.copyWith(color: scheme.primary)),
          ]),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: scheme.surfaceContainerLowest, borderRadius: BorderRadius.circular(18)),
            child: Column(children: const [
              _RewardRow(icon: Icons.stars, iconBg: AppColors.secondaryFixed, title: 'XP Latihan', sub: 'Sesi drill Pecahan harian', trailing: '+80 XP', primary: true),
              Divider(height: 20),
              _RewardRow(icon: Icons.workspace_premium, iconBg: AppColors.tertiaryFixed, title: 'Master Pecahan Lv. 2', sub: 'Terbuka setelah 5x latihan akurat', trailing: 'Baru!'),
              Divider(height: 20),
              _RewardRow(icon: Icons.local_fire_department, iconBg: AppColors.errorContainer, title: '5 Hari Streak Aktif', sub: 'Konsistensi berpikir terjaga', trailing: '+10 Bonus'),
            ]),
          ),
          const SizedBox(height: 14),
          Row(children: [
            Text('Evaluasi Materi', style: t.titleMedium),
            const Spacer(),
            Text('2 Kategori Soal', style: t.labelSmall),
          ]),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: scheme.surfaceContainerLowest, borderRadius: BorderRadius.circular(18)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Row(children: [
                Pill('Dikuasai', bg: AppColors.tertiaryFixed, fg: AppColors.onTertiaryFixed),
                SizedBox(width: 6),
                Text('100% Akurat', style: TextStyle(fontSize: 11, color: AppColors.tertiary)),
                Spacer(),
                Icon(Icons.task_alt, color: AppColors.tertiary),
              ]),
              const SizedBox(height: 4),
              Text('Pecahan Biasa & Senilai', style: t.titleSmall),
              Text('5 dari 5 soal dijawab dengan benar', style: t.bodySmall),
              const SizedBox(height: 6),
              const AppProgressBar(1.0, color: AppColors.tertiaryContainer),
            ]),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: scheme.surfaceContainerLowest, borderRadius: BorderRadius.circular(18)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Row(children: [
                Pill('Perlu Latihan', bg: AppColors.surfaceHigh, fg: AppColors.onSurface),
                SizedBox(width: 6),
                Text('60% Akurat', style: TextStyle(fontSize: 11, color: AppColors.error)),
                Spacer(),
                Icon(Icons.flag_outlined, color: AppColors.error),
              ]),
              const SizedBox(height: 4),
              Text('Penyederhanaan FPB', style: t.titleSmall),
              Text('3 dari 5 benar (2 keliru pada penyebut besar)', style: t.bodySmall),
              const SizedBox(height: 6),
              const AppProgressBar(0.6),
              TextButton(onPressed: null, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
                Text('Review 2 Soal Salah'), Icon(Icons.arrow_forward, size: 16),
              ])),
            ]),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () {
              ref.read(profileProvider.notifier).addXp(80);
              context.push('/math/soal?cat=$categoryId&idx=0');
            },
            child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.replay, size: 18), SizedBox(width: 6), Text('Coba Latihan Lagi'),
            ]),
          ),
          const SizedBox(height: 8),
          FilledButton.tonal(
            onPressed: () => context.go('/home'),
            child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.home_outlined, size: 18), SizedBox(width: 6), Text('Kembali ke Beranda'),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _RewardRow extends StatelessWidget {
  final IconData icon; final Color iconBg; final String title; final String sub; final String trailing; final bool primary;
  const _RewardRow({required this.icon, required this.iconBg, required this.title, required this.sub, required this.trailing, this.primary = false});
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(width: 40, height: 40, decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
          child: Icon(icon, size: 20, color: AppColors.primary)),
      const SizedBox(width: 10),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: Theme.of(context).textTheme.titleSmall),
        Text(sub, style: Theme.of(context).textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
      ])),
      Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: primary ? AppColors.primaryContainer : Theme.of(context).colorScheme.surfaceContainerHigh, borderRadius: BorderRadius.circular(999)),
          child: Text(trailing, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: primary ? Colors.white : null))),
    ]);
  }
}
