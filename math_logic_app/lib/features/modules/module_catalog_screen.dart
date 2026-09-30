import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/app_widgets.dart';

/// Layar 3 — Katalog Modul (5 pilar + asesmen mingguan).
class ModuleCatalogScreen extends StatefulWidget {
  const ModuleCatalogScreen({super.key});
  @override
  State<ModuleCatalogScreen> createState() => _ModuleCatalogState();
}

class _ModuleCatalogState extends State<ModuleCatalogScreen> {
  String filter = 'Semua';
  String query = '';
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final mods = _modules();
    final filtered = mods.where((m) {
      final okF = filter == 'Semua' || m.pillar == filter;
      final okQ = query.isEmpty || (m.title + m.desc).toLowerCase().contains(query.toLowerCase());
      return okF && okQ;
    }).toList();
    return Scaffold(
      appBar: const AppTopBar(title: 'Katalog Modul'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Pilih Modul Pelatihan', style: t.headlineSmall),
              Text('Pilih pilar kemampuan yang ingin kamu asah hari ini:', style: t.bodySmall),
            ])),
            Container(width: 40, height: 40, decoration: BoxDecoration(color: scheme.surfaceContainer, borderRadius: BorderRadius.circular(14)),
                child: const Icon(Icons.tune, color: AppColors.primary)),
          ]),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: scheme.surfaceContainerLow, borderRadius: BorderRadius.circular(16)),
            child: Row(children: [
              Container(width: 32, height: 32, decoration: BoxDecoration(color: const Color(0xFFD1FAE5).withValues(alpha: 0.5), borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.psychology, size: 18, color: AppColors.tertiary)),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Keseimbangan Otak', style: t.labelMedium),
                Text('4 dari 5 pilar aktif terlatih minggu ini', style: t.bodySmall),
              ])),
              const Pill('80% Harmonis', bg: Color(0xFFD1FAE5), fg: AppColors.tertiary),
            ]),
          ),
          const SizedBox(height: 10),
          TextField(
            onChanged: (v) => setState(() => query = v),
            decoration: InputDecoration(
              hintText: 'Cari materi, rumus, logika...', prefixIcon: const Icon(Icons.search),
              filled: true, fillColor: scheme.surfaceContainerLowest,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 34,
            child: ListView(scrollDirection: Axis.horizontal, children: [
              for (final f in ['Semua', 'Angka', 'Logika', 'Memori', 'Visual'])
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(f), selected: filter == f,
                    onSelected: (_) => setState(() => filter = f),
                    selectedColor: AppColors.primary, labelStyle: TextStyle(color: filter == f ? Colors.white : null),
                  ),
                ),
            ]),
          ),
          const SizedBox(height: 10),
          for (final m in filtered) ...[
            _ModuleCard(data: m),
            const SizedBox(height: 10),
          ],
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(color: AppColors.inverseSurface, borderRadius: BorderRadius.circular(24)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Row(children: [
                Icon(Icons.auto_awesome, size: 18, color: AppColors.inversePrimary),
                SizedBox(width: 6),
                Text('TANTANGAN KOMPREHENSIF', style: TextStyle(fontSize: 11, color: AppColors.inversePrimary, fontWeight: FontWeight.w700)),
              ]),
              const SizedBox(height: 6),
              const Text('Asesmen Kognitif Mingguan', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
              const Text('Evaluasi performa 5 pilar otakmu dan perbarui matriks kecerdasan adaptif.',
                  style: TextStyle(fontSize: 12, color: AppColors.inversePrimary)),
              const SizedBox(height: 10),
              Row(children: [
                const Row(children: [
                  Icon(Icons.schedule, size: 14, color: AppColors.inversePrimary),
                  SizedBox(width: 4),
                  Text('8 Menit • 25 Soal', style: TextStyle(fontSize: 11, color: AppColors.inversePrimary)),
                ]),
                const Spacer(),
                FilledButton(onPressed: () => context.push('/math/soal?cat=pecahan&idx=0'), child: const Text('Mulai Tes')),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _Mod {
  final String title; final String desc; final String pillar; final String badge;
  final Color badgeBg; final Color badgeFg; final IconData icon; final Color iconBg;
  final String footLeft; final String footRight; final double? progress; final String route;
  _Mod(this.title, this.desc, this.pillar, this.badge, this.badgeBg, this.badgeFg, this.icon, this.iconBg, this.footLeft, this.footRight, this.progress, this.route);
}

List<_Mod> _modules() => [
      _Mod('Matematika', 'Aritmatika, Pecahan, Aljabar & Geometri', 'Angka', 'Sedang Aktif',
          AppColors.primaryFixed, AppColors.primary, Icons.calculate, AppColors.primary,
          '4 Kategori • 30 Materi', '65% Selesai', 0.65, '/math'),
      _Mod('Logika & Nalar', 'Silogisme, Pola Deret & Deduksi Logis', 'Logika', 'Tersedia',
          AppColors.secondaryFixed, AppColors.secondary, Icons.psychology_alt, AppColors.secondaryContainer,
          '3 Kategori • 20 Materi', '35% Selesai', 0.35, '/math?cat=aljabar'),
      _Mod('Speed Training', 'Kalkulasi Kilat, Refleks & Waktu Mundur', 'Angka', 'Populer',
          AppColors.tertiaryFixed, AppColors.onTertiaryFixedVariant, Icons.bolt, AppColors.primaryContainer,
          'Mode Cepat • 10 Ronde/Sesi', '2.450 Poin Rekor', null, '/speed'),
      _Mod('Memory Training', 'Pola Spasial, Angka Acak & Working Memory', 'Memori', '2 Baru',
          AppColors.primaryFixed, AppColors.onPrimaryFixedVariant, Icons.extension, AppColors.surfaceHigh,
          'Level 14 (Master)', 'Daya Ingat Jangka Pendek', null, '/memory'),
      _Mod('Visual Training', 'Rotasi Objek 3D & Persepsi Ruang', 'Visual', 'Tersedia',
          AppColors.tertiaryFixed, AppColors.tertiary, Icons.view_in_ar, AppColors.tertiary,
          'Pemetaan Ruang • Isometrik', '50% Selesai', 0.5, '/visual'),
    ];

class _ModuleCard extends StatelessWidget {
  final _Mod data;
  const _ModuleCard({required this.data});
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return InkWell(
      onTap: () => context.push(data.route),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerLowest, borderRadius: BorderRadius.circular(20)),
        child: Column(children: [
          Row(children: [
            Container(width: 48, height: 48, decoration: BoxDecoration(color: data.iconBg, borderRadius: BorderRadius.circular(16)),
                child: Icon(data.icon, color: Colors.white)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Flexible(child: Text(data.title, style: t.titleMedium)),
                const SizedBox(width: 6),
                Pill(data.badge, bg: data.badgeBg, fg: data.badgeFg),
              ]),
              Text(data.desc, style: t.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
            ])),
            const Icon(Icons.arrow_forward, size: 18),
          ]),
          const SizedBox(height: 10),
          if (data.progress != null) ...[
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(data.footLeft, style: t.labelSmall),
              Text(data.footRight, style: t.labelSmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
            ]),
            const SizedBox(height: 4),
            AppProgressBar(data.progress!),
          ] else
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(data.footLeft, style: t.labelSmall),
              Pill(data.footRight, bg: const Color(0xFFD1FAE5).withValues(alpha: 0.6), fg: AppColors.tertiary),
            ]),
        ]),
      ),
    );
  }
}
