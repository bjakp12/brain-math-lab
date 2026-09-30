import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/data/question_bank.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/app_widgets.dart';

/// Layar 4 — Daftar Kategori Matematika + search + filter + status.
class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});
  @override
  State<CategoryListScreen> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryListScreen> {
  String filter = 'Semua';
  String query = '';
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final cats = mathCategories().where((c) {
      final okF = filter == 'Semua' ||
          (filter == 'Dasar' && c.tingkat.contains('Dasar')) ||
          (filter == 'Menengah' && c.tingkat.contains('Menengah')) ||
          (filter == 'Lanjutan' && c.tingkat.contains('Lanjutan'));
      final okQ = query.isEmpty || (c.title + c.desc).toLowerCase().contains(query.toLowerCase());
      return okF && okQ;
    }).toList();
    return Scaffold(
      appBar: AppTopBar(title: 'Latihan Pecahan', showBack: true, timer: const TimerBadge('00:45')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(color: scheme.surfaceContainer, borderRadius: BorderRadius.circular(24)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.primaryFixed, borderRadius: BorderRadius.circular(999)),
                      child: const Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.auto_awesome, size: 13, color: AppColors.onPrimaryFixed),
                        SizedBox(width: 4),
                        Text('Pilar 1: Matematika & Aritmatika', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.onPrimaryFixed)),
                      ])),
                  const SizedBox(height: 6),
                  Text('Status Progres Modul', style: t.headlineSmall),
                  Text('18 dari 30 Materi Selesai', style: t.bodySmall),
                ])),
                SizedBox(width: 56, height: 56, child: Stack(alignment: Alignment.center, children: [
                  SizedBox(width: 56, height: 56, child: CircularProgressIndicator(value: 0.6, strokeWidth: 5,
                      backgroundColor: scheme.surfaceContainerHighest, valueColor: const AlwaysStoppedAnimation(AppColors.primary))),
                  Text('60%', style: t.titleSmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w800)),
                ])),
              ]),
              const SizedBox(height: 10),
              const AppProgressBar(0.6),
            ]),
          ),
          const SizedBox(height: 10),
          TextField(
            onChanged: (v) => setState(() => query = v),
            decoration: InputDecoration(hintText: 'Cari topik atau rumus (misal: pecahan, FPB)...',
                prefixIcon: const Icon(Icons.search), suffixIcon: const Icon(Icons.close),
                filled: true, fillColor: scheme.surfaceContainerLow,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none)),
          ),
          const SizedBox(height: 8),
          SizedBox(height: 36, child: ListView(scrollDirection: Axis.horizontal, children: [
            for (final f in ['Semua (4)', 'Dasar', 'Menengah', 'Lanjutan'])
              Padding(padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(label: Text(f.replaceAll(' (4)', '')),
                      selected: filter == f.replaceAll(' (4)', '') || (filter == 'Semua' && f.startsWith('Semua')),
                      onSelected: (_) => setState(() => filter = f.replaceAll(' (4)', '')),
                      selectedColor: AppColors.primary, labelStyle: TextStyle(color: (filter == f.replaceAll(' (4)', '')) ? Colors.white : null))),
          ])),
          const SizedBox(height: 10),
          if (cats.isEmpty)
            Column(children: [
              const SizedBox(height: 30),
              const Icon(Icons.search_off_outlined, size: 48, color: AppColors.outline),
              const SizedBox(height: 8),
              Text('Topik tidak ditemukan. Coba gunakan kata kunci lain.', style: t.bodyMedium),
              TextButton(onPressed: () => setState(() { query = ''; filter = 'Semua'; }), child: const Text('Reset Pencarian')),
            ])
          else
            for (final c in cats) ...[
              _CategoryCard(cat: c),
              const SizedBox(height: 10),
            ],
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: scheme.surfaceContainer, borderRadius: BorderRadius.circular(24)),
            child: Row(children: [
              Container(width: 48, height: 48, decoration: BoxDecoration(color: AppColors.primaryContainer, borderRadius: BorderRadius.circular(16)),
                  child: const Icon(Icons.bolt, color: Colors.white)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Latihan Soal Acak', style: t.titleMedium),
                Text('Uji Kecepatan 10 Soal Acak', style: t.bodySmall),
              ])),
              FilledButton(onPressed: () => context.push('/math/soal?cat=pecahan&idx=0'), child: const Text('Mulai')),
            ]),
          ),
        ]),
      ),
    );
  }
}

IconData _iconFor(String key) {
  switch (key) {
    case 'calculate': return Icons.calculate;
    case 'pie_chart': return Icons.pie_chart;
    case 'functions': return Icons.functions;
    case 'square_foot': return Icons.square_foot;
    case 'show_chart': return Icons.show_chart;
    case 'function_variant': return Icons.timeline;
    case 'bar_chart': return Icons.bar_chart_outlined;
    default: return Icons.format_list_numbered;
  }
}

class _CategoryCard extends StatelessWidget {
  final MathCategory cat;
  const _CategoryCard({required this.cat});
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final locked = cat.status == 'terkunci';
    final active = cat.status == 'aktif';
    return Opacity(
      opacity: locked ? 0.85 : 1,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: active ? scheme.surfaceContainerHighest : scheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(24),
          boxShadow: active ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.12), blurRadius: 20, offset: const Offset(0, 8))] : null,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(width: 48, height: 48,
                decoration: BoxDecoration(
                    color: cat.status == 'selesai' ? AppColors.tertiaryContainer : active ? AppColors.primary : locked ? scheme.surfaceContainer : AppColors.secondaryContainer,
                    borderRadius: BorderRadius.circular(16)),
                child: Icon(_iconFor(cat.icon), color: Colors.white, size: 26)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(cat.title, style: t.titleMedium?.copyWith(color: locked ? scheme.outline : null), maxLines: 1, overflow: TextOverflow.ellipsis),
              Text('Tingkat: ${cat.tingkat} • ${cat.materiCount} Materi', style: t.labelSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
            ])),
            if (cat.status == 'selesai')
              const Pill('Selesai', bg: AppColors.tertiaryFixed, fg: AppColors.onTertiaryFixedVariant, icon: Icons.check_circle)
            else if (active)
              Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.primaryContainer, borderRadius: BorderRadius.circular(999)),
                  child: const Text('Sedang Dipelajari', style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600)))
            else if (locked)
              Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: scheme.surfaceContainer, borderRadius: BorderRadius.circular(999)),
                  child: const Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.lock, size: 12), SizedBox(width: 4), Text('Level 5', style: TextStyle(fontSize: 11)),
                  ]))
            else
              Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: scheme.surfaceContainer, borderRadius: BorderRadius.circular(999)),
                  child: Text('Tersedia', style: t.labelSmall)),
          ]),
          const SizedBox(height: 8),
          Text(cat.desc, style: t.bodySmall?.copyWith(color: locked ? scheme.outline : null)),
          if (!locked) ...[
            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('${(cat.progress * cat.materiCount).round()} dari ${cat.materiCount} Materi Selesai',
                  style: t.labelSmall?.copyWith(color: active ? AppColors.primary : null, fontWeight: FontWeight.w600)),
              Text('${(cat.progress * 100).toInt()}%', style: t.labelSmall?.copyWith(fontWeight: FontWeight.w800)),
            ]),
            const SizedBox(height: 4),
            AppProgressBar(cat.progress, color: cat.status == 'selesai' ? AppColors.tertiary : null),
          ] else ...[
            const SizedBox(height: 8),
            Container(padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: scheme.surfaceContainer, borderRadius: BorderRadius.circular(14)),
                child: const Row(children: [
                  Icon(Icons.info_outline, size: 16), SizedBox(width: 6),
                  Expanded(child: Text('Selesaikan 80% Pecahan untuk membuka modul ini', style: TextStyle(fontSize: 11))),
                ])),
          ],
          if (active) ...[
            const SizedBox(height: 10),
            const Row(children: [
              _SubChip(done: true, label: '1. Pecahan Biasa'),
              SizedBox(width: 6),
              _SubChip(done: true, label: '2. Pecahan Senilai'),
            ]),
            const SizedBox(height: 6),
            const Row(children: [
              _SubChip(done: false, current: true, label: '3. Penjumlahan & FPB'),
              SizedBox(width: 6),
              _SubChip(done: false, locked: true, label: '4. Desimal & Persen'),
            ]),
            const SizedBox(height: 10),
            FilledButton(
              onPressed: () => context.push('/math/detail?cat=${cat.id}'),
              child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('Lanjutkan Belajar'), SizedBox(width: 6), Icon(Icons.arrow_forward, size: 18),
              ]),
            ),
          ] else if (!locked && cat.status != 'selesai') ...[
            const SizedBox(height: 10),
            FilledButton.tonal(
              onPressed: () => context.push('/math/detail?cat=${cat.id}'),
              child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('Buka Materi'), SizedBox(width: 6), Icon(Icons.arrow_forward, size: 18),
              ]),
            ),
          ],
        ]),
      ),
    );
  }
}

class _SubChip extends StatelessWidget {
  final bool done; final bool current; final bool locked; final String label;
  const _SubChip({this.done = false, this.current = false, this.locked = false, required this.label});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: current ? AppColors.primaryFixed : locked ? Theme.of(context).colorScheme.surfaceContainer : Theme.of(context).colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(children: [
          Icon(done ? Icons.check_circle : current ? Icons.play_circle : Icons.lock, size: 14,
              color: done ? AppColors.tertiary : current ? AppColors.primary : AppColors.outline),
          const SizedBox(width: 4),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis)),
        ]),
      ),
    );
  }
}
