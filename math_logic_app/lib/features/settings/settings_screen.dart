import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/data/app_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/auth/auth_providers.dart';
import '../../shared/widgets/avatar_widget.dart';
import '../donation/donation_sheet.dart';

/// Layar 14 — Pengaturan: profil mini, tema, aksen, audio/haptik,
/// gamifikasi, sinkronisasi, aksesibilitas, keluar.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsProvider);
    final not = ref.read(settingsProvider.notifier);
    final p = ref.watch(profileProvider);
    final t = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
        title: const Text('Pengaturan'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.help_outline)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: scheme.surfaceContainerLow, borderRadius: BorderRadius.circular(24)),
            child: Row(children: [
              Stack(alignment: Alignment.bottomRight, children: [
                AvatarWidget(
                    name: p.name,
                    photoUrl: p.photoUrl,
                    size: 54,
                    fontSize: 20),
                Container(width: 18, height: 18, decoration: BoxDecoration(color: AppColors.tertiaryContainer, shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2)),
                    child: const Icon(Icons.verified, size: 10, color: Colors.white)),
              ]),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Flexible(child: Text(p.name, style: t.titleMedium, overflow: TextOverflow.ellipsis)),
                  const SizedBox(width: 6),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: AppColors.secondaryContainer.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(999)),
                      child: const Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.school, size: 11, color: AppColors.primary),
                        SizedBox(width: 2), Text('Pelajar', style: TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.w700)),
                      ])),
                ]),
                Container(margin: const EdgeInsets.only(top: 2), padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(999)),
                    child: Text('Level ${p.level} • ${p.title}', style: const TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.w700))),
                Text(p.email, style: t.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                const Row(children: [
                  Icon(Icons.circle, size: 8, color: AppColors.tertiary),
                  SizedBox(width: 4),
                  Text('Akun Premium Aktif (s.d. Nov 2025)', style: TextStyle(fontSize: 10, color: AppColors.tertiary, fontWeight: FontWeight.w600)),
                ]),
              ])),
              const Icon(Icons.chevron_right),
            ]),
          ),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(
                child: FilledButton.tonal(
                    onPressed: () => context.go('/profil'),
                    child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.account_circle_outlined, size: 18),
                          SizedBox(width: 6),
                          Text('Akun Google',
                              style: TextStyle(fontSize: 12)),
                        ]))),
            const SizedBox(width: 10),
            Expanded(
                child: FilledButton.tonal(
                    onPressed: () => showDonationSheet(context),
                    child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.volunteer_activism_outlined, size: 18),
                          SizedBox(width: 6),
                          Text('Donasi',
                              style: TextStyle(fontSize: 12)),
                        ]))),
          ]),
          const SizedBox(height: 10),
          _Section(
            title: 'Tampilan & Tema Visual', icon: Icons.palette_outlined, trailing: 'Adaptif',
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Mode Tampilan Layar', style: t.labelMedium),
                Text(s.themeMode == ThemeMode.light ? 'Terang aktif' : s.themeMode == ThemeMode.dark ? 'Gelap aktif' : 'Sistem',
                    style: const TextStyle(fontSize: 11, color: AppColors.primary)),
              ]),
              const SizedBox(height: 8),
              Row(children: [
                _ThemePick(label: 'Terang', sub: 'Mencerahkan fokus', icon: Icons.light_mode,
                    selected: s.themeMode == ThemeMode.light, onTap: () => not.setTheme(ThemeMode.light)),
                const SizedBox(width: 8),
                _ThemePick(label: 'Gelap', sub: 'Meredam lelah mata', icon: Icons.dark_mode,
                    selected: s.themeMode == ThemeMode.dark, onTap: () => not.setTheme(ThemeMode.dark)),
                const SizedBox(width: 8),
                _ThemePick(label: 'Sistem', sub: 'Sesuai jadwal OS', icon: Icons.brightness_auto,
                    selected: s.themeMode == ThemeMode.system, onTap: () => not.setTheme(ThemeMode.system)),
              ]),
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Aksen Warna Kognitif', style: t.titleSmall),
                  Text('Pilih palet stimulasi fokus latihan', style: t.bodySmall),
                ]),
                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: AppColors.primaryFixed, borderRadius: BorderRadius.circular(999)),
                    child: const Text('Kinetic Indigo', style: TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.w700))),
              ]),
              const SizedBox(height: 8),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                for (final a in ['indigo', 'emerald', 'cyan', 'amber', 'rose'])
                  _AccentDot(name: a, selected: s.accent == a, onTap: () => not.setAccent(a)),
              ]),
            ],
          ),
          const SizedBox(height: 10),
          _Section(
            title: 'Suara & Umpan Balik Sensorik', icon: Icons.spatial_audio_off_outlined,
            children: [
              _SwitchRow(icon: Icons.volume_up_outlined, title: 'Efek Suara (SFX)', sub: 'Umpan balik audio respons kalkulasi',
                  value: s.sfx, onChanged: (_) => not.toggleSfx()),
              _SwitchRow(icon: Icons.vibration, title: 'Getaran Haptik', sub: 'Respon sentuhan tactile pad keypad',
                  value: s.haptic, onChanged: (_) => not.toggleHaptic()),
              _SwitchRow(icon: Icons.music_note_outlined, title: 'Musik Latar (BGM)', sub: 'Gelombang binaural penunjang konsentrasi',
                  value: s.bgm, onChanged: (_) => not.toggleBgm()),
            ],
          ),
          const SizedBox(height: 10),
          _Section(
            title: 'Pelatihan & Gamifikasi', icon: Icons.psychology_outlined,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Bahasa Pembelajaran', style: t.titleSmall),
                  Text('Istilah teori pecahan & logika', style: t.bodySmall),
                ]),
                Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: scheme.surfaceContainerHigh, borderRadius: BorderRadius.circular(999)),
                    child: const Row(children: [
                      Icon(Icons.language, size: 14, color: AppColors.primary),
                      SizedBox(width: 4), Text('Bahasa Indonesia', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      Icon(Icons.expand_more, size: 14),
                    ])),
              ]),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: scheme.surfaceContainer, borderRadius: BorderRadius.circular(18)),
                child: Column(children: [
                  Row(children: [
                    Container(width: 32, height: 32, decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.alarm, size: 17, color: AppColors.primary)),
                    const SizedBox(width: 8),
                    Text('Alarm Rutin Latihan', style: t.titleSmall),
                    const Spacer(),
                    Switch(
                        value: s.dailyReminder,
                        onChanged: (_) => not.toggleReminder()),
                  ]),
                  const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('19:00 WIB', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.primary)),
                      Text('Setiap hari (Disarankan malam hari)', style: TextStyle(fontSize: 11)),
                    ]),
                    Chip(label: Text('Ubah Jam', style: TextStyle(fontSize: 11))),
                  ]),
                ]),
              ),
              const SizedBox(height: 8),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Tingkat Kesulitan Awal', style: t.titleSmall),
                  Text('Menyesuaikan kalkulasi cerdas', style: t.bodySmall),
                ]),
                Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: scheme.surfaceContainerHigh, borderRadius: BorderRadius.circular(999)),
                    child: const Row(children: [
                      Icon(Icons.tune, size: 14, color: AppColors.tertiary),
                      SizedBox(width: 4), Text('Menengah (Adaptif)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    ])),
              ]),
              _SwitchRow(icon: Icons.timer_outlined, title: 'Timer Hitung Mundur',
                  sub: 'Tampilkan countdown visual di modul latihan', value: s.countdownTimer, onChanged: (_) => not.toggleTimer()),
            ],
          ),
          const SizedBox(height: 10),
          _Section(
            title: 'Sinkronisasi & Penyimpanan', icon: Icons.cloud_sync_outlined,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: scheme.surfaceContainerLowest, borderRadius: BorderRadius.circular(18)),
                child: Column(children: [
                  const Row(children: [
                    Icon(Icons.cloud_done, color: AppColors.tertiary),
                    SizedBox(width: 8),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Tersinkronisasi ke Cloud', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                      Text('Hari ini, 09:30 WIB', style: TextStyle(fontSize: 11)),
                    ])),
                    Icon(Icons.circle, size: 10, color: AppColors.tertiaryFixedDim),
                  ]),
                  SizedBox(height: 8),
                  ClipRRect(borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(value: 1.0, minHeight: 6,
                          backgroundColor: scheme.surfaceContainerHighest, valueColor: const AlwaysStoppedAnimation(AppColors.primary))),
                  SizedBox(height: 8),
                  FilledButton.tonal(
                      onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Berhasil Disinkronkan ✅'))),
                      child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Icon(Icons.sync, size: 16), SizedBox(width: 6), Text('Sinkronkan Sekarang'),
                      ])),
                ]),
              ),
              _SwitchRow(icon: Icons.sd_storage_outlined, title: 'Mode Penyimpanan Offline  24.8 MB',
                  sub: 'Bank modul kognitif tersimpan offline', value: s.offlineMode, onChanged: (_) => not.toggleOffline()),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Bersihkan Cache Sementara', style: t.titleSmall),
                  Text('Membebaskan ruang tanpa hapus skor', style: t.bodySmall),
                ]),
                FilledButton.tonal(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cache Terhapus!'))),
                    child: const Text('Hapus Cache', style: TextStyle(fontSize: 12))),
              ]),
            ],
          ),
          const SizedBox(height: 10),
          _Section(
            title: 'Aksesibilitas & Keterbacaan', icon: Icons.accessibility_new_outlined,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Ukuran Font Rumus & Teks', style: t.labelMedium),
                Text(s.fontScale == 0.9 ? 'Kecil' : s.fontScale >= 1.15 ? 'Besar' : 'Sedang (100%)',
                    style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w700)),
              ]),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: scheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(16)),
                child: Row(children: [
                  _FontBtn(label: 'Kecil', selected: s.fontScale == 0.9, onTap: () => not.setFont(0.9)),
                  _FontBtn(label: 'Sedang', selected: s.fontScale == 1.0, onTap: () => not.setFont(1.0)),
                  _FontBtn(label: 'Besar', selected: s.fontScale == 1.15, onTap: () => not.setFont(1.15)),
                ]),
              ),
              _SwitchRow(icon: Icons.contrast_outlined, title: 'Kontras Tinggi (High Contrast)',
                  sub: 'Mempertegas garis pecahan dan tombol', value: s.highContrast, onChanged: (_) => not.toggleContrast()),
              _SwitchRow(icon: Icons.motion_photos_off_outlined, title: 'Kurangi Animasi (Reduce Motion)',
                  sub: 'Menghilangkan transisi pegas saat menjawab', value: s.reduceMotion, onChanged: (_) => not.toggleReduceMotion()),
            ],
          ),
          const SizedBox(height: 14),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.errorContainer, foregroundColor: AppColors.error),
            onPressed: () => showDialog(context: context, builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              title: const Text('Keluar dari Akun?'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
                FilledButton(onPressed: () async { Navigator.pop(context); await signOutAction(ref); if (context.mounted) context.go('/onboarding'); }, child: const Text('Ya, Keluar')),
              ],
            )),
            child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.logout, size: 18), SizedBox(width: 6), Text('Keluar dari Akun'),
            ]),
          ),
          const SizedBox(height: 12),
          const Text('●  Cognitive Kinetic Lab  •  v1.4.2 (Build 2401)', style: TextStyle(fontSize: 11)),
          const Text('Algoritma Neuro-Math Terverifikasi • Hak Cipta Dilindungi', style: TextStyle(fontSize: 11, color: AppColors.outline)),
        ]),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title; final IconData icon; final String? trailing; final List<Widget> children;
  const _Section({required this.title, required this.icon, this.trailing, required this.children});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerLow, borderRadius: BorderRadius.circular(24)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 6),
          Expanded(child: Text(title, style: Theme.of(context).textTheme.titleSmall)),
          if (trailing != null)
            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(999)),
                child: Text(trailing!, style: const TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.w700))),
        ]),
        const SizedBox(height: 10),
        for (var i = 0; i < children.length; i++) ...[
          children[i],
          if (i != children.length - 1) const SizedBox(height: 10),
        ],
      ]),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final IconData icon; final String title; final String sub; final bool value; final ValueChanged<bool> onChanged;
  const _SwitchRow({required this.icon, required this.title, required this.sub, required this.value, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(width: 36, height: 36, decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHigh, borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, size: 19, color: AppColors.primary)),
      const SizedBox(width: 10),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: Theme.of(context).textTheme.titleSmall),
        Text(sub, style: Theme.of(context).textTheme.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
      ])),
      Switch(value: value, onChanged: onChanged),
    ]);
  }
}

class _ThemePick extends StatelessWidget {
  final String label; final String sub; final IconData icon; final bool selected; final VoidCallback onTap;
  const _ThemePick({required this.label, required this.sub, required this.icon, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Expanded(
      child: InkWell(
        onTap: onTap, borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? scheme.surfaceContainerLowest : scheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
            border: selected ? Border.all(color: AppColors.primary, width: 1.5) : null,
          ),
          child: Column(children: [
            Icon(icon, size: 19, color: selected ? AppColors.primary : scheme.onSurfaceVariant),
            Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: selected ? AppColors.primary : null)),
            Text(sub, style: const TextStyle(fontSize: 9), textAlign: TextAlign.center, maxLines: 2),
          ]),
        ),
      ),
    );
  }
}

class _AccentDot extends StatelessWidget {
  final String name; final bool selected; final VoidCallback onTap;
  const _AccentDot({required this.name, required this.selected, required this.onTap});
  Color get color {
    switch (name) {
      case 'emerald': return const Color(0xFF059669);
      case 'cyan': return const Color(0xFF0284C7);
      case 'amber': return const Color(0xFFD97706);
      case 'rose': return const Color(0xFFE11D48);
      default: return const Color(0xFF4F46E5);
    }
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, borderRadius: BorderRadius.circular(12),
      child: Column(children: [
        Container(width: 32, height: 32, decoration: BoxDecoration(color: color, shape: BoxShape.circle,
            border: selected ? Border.all(color: AppColors.primary, width: 2) : null),
            child: selected ? const Icon(Icons.check, size: 15, color: Colors.white) : null),
        Text(name[0].toUpperCase() + name.substring(1), style: const TextStyle(fontSize: 9)),
      ]),
    );
  }
}

class _FontBtn extends StatelessWidget {
  final String label; final bool selected; final VoidCallback onTap;
  const _FontBtn({required this.label, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap, borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: selected ? Theme.of(context).colorScheme.surfaceContainerLowest : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(child: Text(label,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                  color: selected ? AppColors.primary : null))),
        ),
      ),
    );
  }
}
