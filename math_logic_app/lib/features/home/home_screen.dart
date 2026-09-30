import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/data/app_state.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/app_widgets.dart';

/// Layar 2 — Beranda. Greeting, target harian, statistik, lanjutkan materi,
/// rekomendasi horizontal, tantangan harian.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(profileProvider);
    final t = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final pct = (p.todayMinutes / p.dailyTargetMin).clamp(0.0, 1.0);
    return Scaffold(
      appBar: const AppTopBar(title: 'Home'),
      body: RefreshIndicator(
        onRefresh: () async => Future.delayed(const Duration(milliseconds: 500)),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Flexible(child: Text('Halo, ${p.name}!', style: t.headlineSmall, overflow: TextOverflow.ellipsis)),
                  const Text(' 👋', style: TextStyle(fontSize: 20)),
                ]),
                Text('Siap melatih ketajaman otakmu hari ini?', style: t.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
              ])),
              Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: scheme.surfaceContainerHigh, borderRadius: BorderRadius.circular(999)),
                  child: Row(children: [
                    const Icon(Icons.military_tech, size: 14, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text('Lv. ${p.level}', style: t.labelSmall?.copyWith(fontWeight: FontWeight.w700, color: scheme.onSurface)),
                  ])),
              const SizedBox(width: 8),
              Stack(children: [
                Container(width: 36, height: 36, decoration: BoxDecoration(color: scheme.surfaceContainer, shape: BoxShape.circle),
                    child: const Icon(Icons.notifications_outlined, size: 19)),
                Positioned(right: 8, top: 8, child: Container(width: 8, height: 8,
                    decoration: BoxDecoration(color: scheme.error, shape: BoxShape.circle, border: Border.all(color: scheme.surface, width: 1.5)))),
              ]),
            ]),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.pastelPurple, borderRadius: BorderRadius.circular(24),
                  boxShadow: [BoxShadow(color: AppColors.pastelPurpleDeep.withValues(alpha: 0.25), blurRadius: 16, offset: const Offset(0, 6))]),
              child: Column(children: [
                Row(children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      const Icon(Icons.track_changes, size: 16, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text('TARGET BELAJAR HARI INI', style: t.labelSmall?.copyWith(fontWeight: FontWeight.w700)),
                    ]),
                    const SizedBox(height: 4),
                    Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Text('${p.todayMinutes} / ${p.dailyTargetMin}', style: t.headlineMedium?.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(width: 6),
                      Padding(padding: const EdgeInsets.only(bottom: 4), child: Text('Menit', style: t.bodyMedium?.copyWith(color: scheme.onSurfaceVariant))),
                      const SizedBox(width: 6),
                      const Pill('80% Tercapai', bg: Color(0xFFD1FAE5), fg: AppColors.tertiary),
                    ]),
                  ])),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: Colors.amber.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(999)),
                      child: const Row(children: [
                        Icon(Icons.local_fire_department, size: 18, color: Colors.amber),
                        SizedBox(width: 4),
                        Text('5 Hari', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF92400E))),
                      ])),
                ]),
                const SizedBox(height: 10),
                AppProgressBar(pct, height: 12),
                const SizedBox(height: 8),
                Row(children: [
                  const Icon(Icons.stars, size: 14, color: Colors.amber),
                  const SizedBox(width: 4),
                  Expanded(child: Text('Pertahankan streak untuk bonus +20 XP!', style: t.bodySmall)),
                  Text('2m lagi', style: t.labelSmall?.copyWith(color: scheme.primary, fontWeight: FontWeight.w700)),
                ]),
              ]),
            ),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: MetricCard(label: 'Akurasi', value: '${(p.accuracy * 100).toInt()}%', sub: '', icon: Icons.check_circle, iconBg: const Color(0xFFD1FAE5), iconFg: AppColors.tertiary)),
              const SizedBox(width: 8),
              Expanded(child: MetricCard(label: 'XP Hari Ini', value: '+${p.todayXp}', sub: '', icon: Icons.bolt, iconBg: AppColors.primaryFixed, iconFg: AppColors.primary)),
              const SizedBox(width: 8),
              Expanded(child: MetricCard(label: 'Global Rank', value: p.globalRank <= 0 ? '–' : '#${p.globalRank}', sub: p.globalRank <= 0 ? 'Mainkan misi' : '', icon: Icons.public, iconBg: AppColors.secondaryFixed, iconFg: AppColors.secondary)),
            ]),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: scheme.surfaceContainerLowest, borderRadius: BorderRadius.circular(24)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.primaryFixed, borderRadius: BorderRadius.circular(999)),
                      child: Text('LANJUTKAN MATERI', style: t.labelSmall?.copyWith(color: AppColors.onPrimaryFixed, fontWeight: FontWeight.w800))),
                  const Spacer(),
                  Text('Bab 4 dari 8', style: t.labelSmall),
                ]),
                const SizedBox(height: 10),
                Row(children: [
                  Container(width: 48, height: 48, decoration: BoxDecoration(color: AppColors.pastelYellow, borderRadius: BorderRadius.circular(16)),
                      child: const Icon(Icons.calculate, color: AppColors.cocoaBrown, size: 26)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Pecahan & Desimal', style: t.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                    Text('Submateri 3: Operasi Penjumlahan & Pengurangan', style: t.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                  ])),
                ]),
                const SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Kelengkapan', style: t.labelSmall),
                  Text('60% selesai', style: t.labelSmall?.copyWith(color: scheme.primary, fontWeight: FontWeight.w700)),
                ]),
                const SizedBox(height: 4),
                const AppProgressBar(0.6),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () => context.push('/math/detail?cat=pecahan'),
                  child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text('Lanjutkan Latihan'), SizedBox(width: 6), Icon(Icons.play_arrow, size: 18),
                  ]),
                ),
              ]),
            ),
            const SizedBox(height: 14),
            Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Rekomendasi Cepat', style: t.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
                Text('Asah fokus otak dalam hitungan menit', style: t.bodySmall),
              ])),
              TextButton(onPressed: () => context.go('/modul'), child: const Text('Lihat Semua ›')),
            ]),
            SizedBox(
              height: 168,
              child: ListView(scrollDirection: Axis.horizontal, children: [
                _RecoCard(icon: Icons.bolt, iconBg: Colors.amber.withValues(alpha: 0.12), iconFg: Colors.amber.shade700,
                    tag: 'Refleks Cepat', title: 'Speed Math', sub: 'Aritmatika Kilat', meta: '3 mnt • +50 XP',
                    onPlay: () => context.push('/speed')),
                const SizedBox(width: 10),
                _RecoCard(icon: Icons.view_in_ar, iconBg: AppColors.secondaryFixed.withValues(alpha: 0.5), iconFg: AppColors.secondary,
                    tag: 'Visual', title: 'Pola Spasial', sub: 'Rotasi Dimensi 3D', meta: '5 mnt • +80 XP',
                    onPlay: () => context.push('/visual')),
                const SizedBox(width: 10),
                _RecoCard(icon: Icons.grid_4x4, iconBg: const Color(0xFFD1FAE5), iconFg: AppColors.tertiary,
                    tag: 'Daya Ingat', title: 'Memory Matrix', sub: 'Working Memory', meta: '4 mnt • +60 XP',
                    onPlay: () => context.push('/memory')),
              ]),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.inverseSurface, borderRadius: BorderRadius.circular(24)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.tertiaryContainer, borderRadius: BorderRadius.circular(999)),
                      child: const Row(children: [
                        Icon(Icons.flag_outlined, size: 13, color: Colors.white), SizedBox(width: 4),
                        Text('Tantangan Hari Ini', style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600)),
                      ])),
                  const Spacer(),
                  const Text('Berakhir dlm 4j', style: TextStyle(fontSize: 11, color: AppColors.inversePrimary)),
                ]),
                const SizedBox(height: 8),
                const Text('🏆 Selesaikan 3 Sesi Latihan Cepat',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                const Text('Satu sesi tersisa untuk mengklaim reward eksklusif!',
                    style: TextStyle(fontSize: 12, color: AppColors.inversePrimary)),
                const SizedBox(height: 10),
                const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Progres Misi', style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600)),
                  Text('2 / 3 Selesai', style: TextStyle(fontSize: 11, color: AppColors.tertiaryFixed, fontWeight: FontWeight.w700)),
                ]),
                const SizedBox(height: 4),
                const AppProgressBar(0.666, color: AppColors.tertiaryFixedDim),
                const SizedBox(height: 8),
                Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                    child: const Text('🎁 Hadiah: Lencana Kilat +100 XP',
                        style: TextStyle(fontSize: 11, color: Colors.white))),
                const SizedBox(height: 10),
                FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: AppColors.inversePrimary, foregroundColor: AppColors.onPrimaryFixed),
                  onPressed: () => context.push('/speed'),
                  child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text('Mulai Ronde Terakhir'), SizedBox(width: 6), Icon(Icons.arrow_forward, size: 18),
                  ]),
                ),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}

class _RecoCard extends StatelessWidget {
  final IconData icon; final Color iconBg; final Color iconFg;
  final String tag; final String title; final String sub; final String meta;
  final VoidCallback onPlay;
  const _RecoCard({required this.icon, required this.iconBg, required this.iconFg, required this.tag, required this.title, required this.sub, required this.meta, required this.onPlay});
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Container(
      width: 200, padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerLowest, borderRadius: BorderRadius.circular(20)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(width: 40, height: 40, decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: iconFg)),
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainer, borderRadius: BorderRadius.circular(999)),
              child: Text(tag, style: t.labelSmall)),
        ]),
        const SizedBox(height: 8),
        Text(title, style: t.titleMedium),
        Text(sub, style: t.bodySmall),
        const Spacer(),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(meta, style: t.labelSmall),
          InkWell(onTap: onPlay, child: Container(width: 32, height: 32,
              decoration: const BoxDecoration(color: AppColors.inkBlack, shape: BoxShape.circle),
              child: const Icon(Icons.play_arrow, size: 18, color: Colors.white))),
        ]),
      ]),
    );
  }
}
