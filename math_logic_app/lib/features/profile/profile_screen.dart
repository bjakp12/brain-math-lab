import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/data/app_state.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/app_widgets.dart';

/// Layar 13 — Profil & Progres: identitas, radar chart 5 pilar, performa
/// modul, lencana horizontal, riwayat latihan.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(profileProvider);
    final cog = ref.watch(cognitiveIndexProvider);
    final t = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const AppTopBar(title: 'Home'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: AppColors.primaryFixed.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(999)),
                child: Text('PROFIL KOGNITIF', style: t.labelSmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w800))),
            const Spacer(),
            InkWell(
              onTap: () => context.push('/pengaturan'),
              child: Stack(children: [
                Container(width: 40, height: 40, decoration: BoxDecoration(color: scheme.surfaceContainer, shape: BoxShape.circle),
                    child: const Icon(Icons.settings_outlined, size: 20)),
                Positioned(right: 10, top: 10, child: Container(width: 8, height: 8,
                    decoration: BoxDecoration(color: scheme.error, shape: BoxShape.circle, border: Border.all(color: scheme.surface, width: 1.5)))),
              ]),
            ),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            Stack(alignment: Alignment.bottomRight, children: [
              Container(width: 72, height: 72, decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppColors.primary, AppColors.secondary, AppColors.primaryContainer]),
                  borderRadius: BorderRadius.circular(22)),
                  child: const Icon(Icons.person, color: Colors.white, size: 40)),
              Container(width: 24, height: 24, decoration: const BoxDecoration(color: AppColors.tertiary, shape: BoxShape.circle),
                  child: const Icon(Icons.psychology, size: 13, color: Colors.white)),
            ]),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Flexible(child: Text(p.name, style: t.titleLarge?.copyWith(fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis)),
                const SizedBox(width: 4),
                const Icon(Icons.verified, size: 16, color: AppColors.primary),
              ]),
              Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: BoxDecoration(color: scheme.surfaceContainerHigh, borderRadius: BorderRadius.circular(999)),
                  child: Text('Level ${p.level} • ${p.title} Kognitif', style: t.labelSmall)),
              Text('Fokus: Aritmatika Cepat & Logika Deduktif', style: t.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
            ])),
          ]),
          const SizedBox(height: 10),
          Row(children: const [
            _StatTile(label: 'TOTAL XP', value: '14.250', sub: '+420 mg ini', icon: Icons.bolt, color: AppColors.primary),
            SizedBox(width: 8),
            _StatTile(label: 'STREAK', value: '5 Hari', sub: 'Rekor: 18 hari', icon: Icons.local_fire_department, color: AppColors.tertiary),
            SizedBox(width: 8),
            _StatTile(label: 'LIGA', value: 'Top 5%', sub: 'Liga Berlian', icon: Icons.military_tech, color: AppColors.secondary),
          ]),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: scheme.surfaceContainerLowest, borderRadius: BorderRadius.circular(24)),
            child: Column(children: [
              Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Indeks Kognitif & Otak', style: t.titleMedium),
                  Text('Update Terakhir: Hari ini, 09:30', style: t.labelSmall),
                ])),
                Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.tertiaryContainer.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(999)),
                    child: const Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.circle, size: 8, color: AppColors.tertiary),
                      SizedBox(width: 4), Text('Skor: 798', style: TextStyle(fontSize: 11, color: AppColors.tertiary, fontWeight: FontWeight.w700)),
                    ])),
              ]),
              const SizedBox(height: 6),
              SizedBox(height: 250, child: CustomPaint(painter: _RadarPainter(values: cog))),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: scheme.surfaceContainer, borderRadius: BorderRadius.circular(16)),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(width: 32, height: 32, decoration: BoxDecoration(color: AppColors.primaryFixed, borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.auto_awesome, size: 17, color: AppColors.primary)),
                  const SizedBox(width: 8),
                  const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Analisis AI Kognitif', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                    Text('Kekuatan utamamu di Logika Deduksi. Perbanyak Rotasi 3D Spasial untuk menyeimbangkan profil.',
                        style: TextStyle(fontSize: 12)),
                  ])),
                ]),
              ),
            ]),
          ),
          const SizedBox(height: 12),
          Row(children: [
            Text('Rincian Performa Modul', style: t.titleMedium),
            const Spacer(),
            Text('Bulan Ini', style: t.labelSmall?.copyWith(color: scheme.primary)),
          ]),
          const SizedBox(height: 8),
          const _PerfRow(icon: Icons.calculate, color: AppColors.tertiary, title: 'Matematika', sub: '45 Sesi Selesai • Rata-rata 22 dtk', pct: 0.82, label: '82%'),
          const SizedBox(height: 8),
          const _PerfRow(icon: Icons.psychology_alt, color: AppColors.primary, title: 'Logika & Nalar', sub: '30 Sesi Selesai • Rata-rata 18 dtk', pct: 0.88, label: '88%'),
          const SizedBox(height: 8),
          const _PerfRow(icon: Icons.memory_outlined, color: AppColors.secondary, title: 'Memory Training', sub: '20 Sesi Selesai • Rata-rata 35 dtk', pct: 0.74, label: '74%'),
          const SizedBox(height: 8),
          const _PerfRow(icon: Icons.view_in_ar, color: AppColors.outline, title: 'Visual & Spasial', sub: '15 Sesi Selesai • Rata-rata 42 dtk', pct: 0.70, label: '70%'),
          const SizedBox(height: 12),
          Row(children: [
            Text('Pencapaian & Lencana', style: t.titleMedium),
            const SizedBox(width: 6),
            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: AppColors.primaryFixed, borderRadius: BorderRadius.circular(999)),
                child: const Text('8/16', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.onPrimaryFixed))),
            const Spacer(),
            TextButton(onPressed: () {}, child: const Text('Lihat Semua', style: TextStyle(fontSize: 11))),
          ]),
          SizedBox(
            height: 150,
            child: ListView(scrollDirection: Axis.horizontal, children: const [
              _Badge(icon: Icons.bolt, title: 'Refleks Kilat', sub: 'Speed Math <1 dtk', open: true),
              SizedBox(width: 8),
              _Badge(icon: Icons.all_inclusive, title: 'Master Memori', sub: 'Urutan 7 Digit', open: true),
              SizedBox(width: 8),
              _Badge(icon: Icons.explore_outlined, title: 'Penjelajah Maze', sub: '0 Kesalahan', open: true),
              SizedBox(width: 8),
              _Badge(icon: Icons.lock, title: 'Arsitek 3D', sub: 'Butuh Lv. 15', open: false),
            ]),
          ),
          const SizedBox(height: 12),
          Row(children: [
            Text('Riwayat Latihan Terakhir', style: t.titleMedium),
            const Spacer(),
            TextButton(onPressed: () {}, child: const Text('Filter', style: TextStyle(fontSize: 11))),
          ]),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: scheme.surfaceContainerLowest, borderRadius: BorderRadius.circular(22)),
            child: Column(children: const [
              _Hist(icon: Icons.percent, title: 'Pecahan & Desimal', sub: 'Hari ini, 09:15 • Akurasi 80%', score: '80/100', xp: '+80 XP'),
              _Hist(icon: Icons.timer_outlined, title: 'Speed Math Aritmatika', sub: 'Kemarin, 19:40 • Akurasi 92%', score: '2.100 PTS', xp: '+60 XP'),
              _Hist(icon: Icons.grid_4x4, title: 'Memory Maze Level 3', sub: '2 hari lalu • Selesai Sempurna', score: '100%', xp: '+50 XP'),
            ]),
          ),
          const SizedBox(height: 10),
          Center(
            child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: scheme.surfaceContainer, borderRadius: BorderRadius.circular(999)),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.cloud_done_outlined, size: 14, color: AppColors.tertiary),
                  SizedBox(width: 4),
                  Text('Data tersimpan lokal & cloud tersinkronisasi 5 mnt lalu', style: TextStyle(fontSize: 10)),
                ])),
          ),
        ]),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label; final String value; final String sub; final IconData icon; final Color color;
  const _StatTile({required this.label, required this.value, required this.sub, required this.icon, required this.color});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerLowest, borderRadius: BorderRadius.circular(18)),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon, size: 14, color: color), const SizedBox(width: 3),
            Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
          ]),
          Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
          Text(sub, style: const TextStyle(fontSize: 10, color: AppColors.tertiary)),
        ]),
      ),
    );
  }
}

class _PerfRow extends StatelessWidget {
  final IconData icon; final Color color; final String title; final String sub; final double pct; final String label;
  const _PerfRow({required this.icon, required this.color, required this.title, required this.sub, required this.pct, required this.label});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerLowest, borderRadius: BorderRadius.circular(18)),
      child: Column(children: [
        Row(children: [
          Container(width: 36, height: 36, decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: 19)),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: Theme.of(context).textTheme.titleSmall),
            Text(sub, style: Theme.of(context).textTheme.labelSmall),
          ])),
          Text(label, style: TextStyle(fontWeight: FontWeight.w800, color: color)),
        ]),
        const SizedBox(height: 8),
        AppProgressBar(pct, color: color, height: 6),
      ]),
    );
  }
}

class _Badge extends StatelessWidget {
  final IconData icon; final String title; final String sub; final bool open;
  const _Badge({required this.icon, required this.title, required this.sub, required this.open});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130, padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: open ? Theme.of(context).colorScheme.surfaceContainerLowest : Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(18)),
      child: Column(children: [
        Container(width: 48, height: 48, decoration: BoxDecoration(
            color: open ? AppColors.primaryContainer : Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(14)),
            child: Icon(icon, color: open ? Colors.white : AppColors.outline)),
        const SizedBox(height: 6),
        Text(title, style: Theme.of(context).textTheme.titleSmall, maxLines: 1, textAlign: TextAlign.center),
        Text(sub, style: Theme.of(context).textTheme.labelSmall, textAlign: TextAlign.center, maxLines: 2),
        const SizedBox(height: 6),
        Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(color: open ? AppColors.tertiaryContainer.withValues(alpha: 0.15) : Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(999)),
            child: Text(open ? 'Terbuka' : 'Terkunci',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: open ? AppColors.tertiary : AppColors.outline))),
      ]),
    );
  }
}

class _Hist extends StatelessWidget {
  final IconData icon; final String title; final String sub; final String score; final String xp;
  const _Hist({required this.icon, required this.title, required this.sub, required this.score, required this.xp});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(children: [
        Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.primaryFixed.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: AppColors.primary, size: 19)),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: Theme.of(context).textTheme.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
          Text(sub, style: Theme.of(context).textTheme.labelSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(score, style: Theme.of(context).textTheme.titleSmall),
          const Text('+80 XP', style: TextStyle(fontSize: 10, color: AppColors.tertiary, fontWeight: FontWeight.w700)),
        ]),
      ]),
    );
  }
}

/// Radar chart pentagon: Matematika, Logika, Memori, Visual, Refleks.
class _RadarPainter extends CustomPainter {
  final Map<String, double> values;
  _RadarPainter({required this.values});
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2, cy = size.height / 2 + 6;
    const keys = ['Matematika', 'Logika', 'Memori', 'Visual', 'Refleks'];
    Offset pt(int i, double r) {
      final a = -pi / 2 + i * 2 * pi / 5;
      return Offset(cx + r * cos(a), cy + r * sin(a));
    }

    final grid = Paint()..color = AppColors.outlineVariant..style = PaintingStyle.stroke..strokeWidth = 1;
    for (final f in [1.0, 0.75, 0.5, 0.25]) {
      final path = Path();
      for (var i = 0; i < 5; i++) {
        final p = pt(i, 95 * f);
        i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
      }
      path.close();
      canvas.drawPath(path, grid);
    }
    final axis = Paint()..color = AppColors.surfaceDim..strokeWidth = 1;
    for (var i = 0; i < 5; i++) {
      final p = pt(i, 95);
      canvas.drawLine(Offset(cx, cy), p, axis);
    }
    final data = Path();
    for (var i = 0; i < 5; i++) {
      final v = (values[keys[i]] ?? 0.5).clamp(0.0, 1.0);
      final p = pt(i, 95 * v);
      i == 0 ? data.moveTo(p.dx, p.dy) : data.lineTo(p.dx, p.dy);
    }
    data.close();
    canvas.drawPath(data, Paint()..color = AppColors.primary.withValues(alpha: 0.22));
    canvas.drawPath(data, Paint()..color = AppColors.primary..style = PaintingStyle.stroke..strokeWidth = 2.5);
    for (var i = 0; i < 5; i++) {
      final v = (values[keys[i]] ?? 0.5).clamp(0.0, 1.0);
      final p = pt(i, 95 * v);
      canvas.drawCircle(p, 5, Paint()..color = AppColors.primary);
      canvas.drawCircle(p, 5, Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2);
    }
    // label
    void label(int i, String name, String pct, Color c) {
      final p = pt(i, 122);
      final tp = TextPainter(
          text: TextSpan(children: [
            TextSpan(text: '$name\n', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
            TextSpan(text: pct, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: c)),
          ]),
          textDirection: TextDirection.ltr, textAlign: TextAlign.center);
      tp.layout();
      tp.paint(canvas, p - Offset(tp.width / 2, tp.height / 2));
    }

    label(0, 'Matematika', '85%', AppColors.primary);
    label(1, 'Logika', '90%', AppColors.tertiary);
    label(2, 'Memori', '75%', AppColors.primary);
    label(3, 'Visual', '70%', AppColors.secondary);
    label(4, 'Refleks', '80%', AppColors.primary);
  }
  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
