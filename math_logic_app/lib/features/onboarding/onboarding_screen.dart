import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/data/app_state.dart';
import '../../core/theme/app_colors.dart';

/// Layar 1 — Onboarding. Sesuai wireframe Stitch: hero brand, 3 value
/// badges, pilih kemampuan (Pemula/Menengah/Mahir), target harian 2x2.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});
  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingState();
}

class _OnboardingState extends ConsumerState<OnboardingScreen> {
  SkillLevel skill = SkillLevel.menengah;
  int minutes = 10;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: scheme.surfaceContainer, borderRadius: BorderRadius.circular(999)),
                child: Row(children: [
                  Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
                  const SizedBox(width: 6),
                  Text('LANGKAH 1 DARI 1', style: t.labelSmall),
                ]),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppColors.tertiaryFixed.withValues(alpha: 0.35), borderRadius: BorderRadius.circular(999)),
                child: Row(children: [
                  const Icon(Icons.cloud_done, size: 14, color: AppColors.tertiary),
                  const SizedBox(width: 4),
                  Text('Siap Offline', style: t.labelSmall?.copyWith(color: AppColors.tertiary, fontWeight: FontWeight.w700)),
                ]),
              ),
            ]),
            const SizedBox(height: 20),
            Center(
              child: Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryContainer, AppColors.secondary]),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.25), blurRadius: 18, offset: const Offset(0, 8))],
                ),
                child: const Icon(Icons.all_inclusive, color: Colors.white, size: 44),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(color: AppColors.primaryFixed, borderRadius: BorderRadius.circular(999)),
                child: Text('BRAIN & MATH LAB  •  v1.4.2', style: t.labelSmall?.copyWith(color: AppColors.onPrimaryFixed, fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(height: 8),
            Text('Tingkatkan Logika, Fokus, dan Kecepatan Berhitung',
                textAlign: TextAlign.center, style: t.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text('Latih 5 pilar kognitif otakmu dengan sesi interaktif adaptif hanya 10 menit sehari.',
                textAlign: TextAlign.center, style: t.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
            const SizedBox(height: 14),
            Row(children: const [
              _ValueBadge(icon: Icons.bolt, title: '10 Mnt/Hari', sub: 'Retensi Otak'),
              SizedBox(width: 8),
              _ValueBadge(icon: Icons.auto_fix_high, title: 'Adaptif AI', sub: 'Personal Level'),
              SizedBox(width: 8),
              _ValueBadge(icon: Icons.military_tech, title: 'XP & Streak', sub: 'Lencana Unik'),
            ]),
            const SizedBox(height: 18),
            Text('PILIH TINGKAT KEMAMPUAN AWAL', style: t.titleSmall),
            Text('Kamu dapat mengubahnya kapan saja di menu pengaturan.', style: t.labelSmall),
            const SizedBox(height: 8),
            _SkillCard(
              emoji: '🌱', title: 'Pemula', desc: 'Fokus fondasi konsep dasar, aritmatika & relaksasi nalar',
              selected: skill == SkillLevel.pemula, onTap: () => setState(() => skill = SkillLevel.pemula),
            ),
            const SizedBox(height: 8),
            _SkillCard(
              emoji: '⚡', title: 'Menengah', desc: 'Latihan rutin pecahan, aljabar linear & kalkulasi kilat',
              badge: 'Direkomendasikan', selected: skill == SkillLevel.menengah,
              onTap: () => setState(() => skill = SkillLevel.menengah),
            ),
            const SizedBox(height: 8),
            _SkillCard(
              emoji: '🚀', title: 'Mahir', desc: 'Tantangan logika kompleks, visual spasial 3D & olimpiade',
              selected: skill == SkillLevel.mahir, onTap: () => setState(() => skill = SkillLevel.mahir),
            ),
            const SizedBox(height: 16),
            Text('TARGET BELAJAR HARIAN', style: t.titleSmall),
            const SizedBox(height: 8),
            GridView.count(
              crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 2.1,
              children: [
                _MinuteChip(label: '5 Menit', xp: '+20 XP', sub: 'Santai & Rileks', selected: minutes == 5, onTap: () => setState(() => minutes = 5)),
                _MinuteChip(label: '10 Menit', xp: '+40 XP', sub: 'Ideal Rekomendasi', selected: minutes == 10, onTap: () => setState(() => minutes = 10)),
                _MinuteChip(label: '15 Menit', xp: '+60 XP', sub: 'Intensif & Terarah', selected: minutes == 15, onTap: () => setState(() => minutes = 15)),
                _MinuteChip(label: '20 Menit', xp: '+80 XP', sub: 'Master Kognitif', selected: minutes == 20, onTap: () => setState(() => minutes = 20)),
              ],
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: loading ? null : () async {
                setState(() => loading = true);
                ref.read(profileProvider.notifier).setSkill(skill);
                ref.read(profileProvider.notifier).setDailyTarget(minutes);
                ref.read(profileProvider.notifier).addXp(50);
                await Future.delayed(const Duration(milliseconds: 700));
                if (mounted) context.go('/home');
              },
              child: loading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      const Text('Mulai Belajar Sekarang  →'),
                      Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.25), borderRadius: BorderRadius.circular(999)),
                          child: const Text('+50 XP', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700))),
                    ]),
            ),
            TextButton(onPressed: () => context.go('/home'), child: const Text('Sudah punya akun? Masuk')),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.verified_user_outlined, size: 13),
              const SizedBox(width: 4),
              Text('Data progres tersimpan aman secara offline & lokal',
                  style: GoogleFonts.inter(fontSize: 11, color: scheme.onSurfaceVariant)),
            ]),
          ]),
        ),
      ),
    );
  }
}

class _ValueBadge extends StatelessWidget {
  final IconData icon; final String title; final String sub;
  const _ValueBadge({required this.icon, required this.title, required this.sub});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerLow, borderRadius: BorderRadius.circular(16)),
        child: Column(children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(height: 4),
          Text(title, style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
          Text(sub, style: Theme.of(context).textTheme.labelSmall, maxLines: 1),
        ]),
      ),
    );
  }
}

class _SkillCard extends StatelessWidget {
  final String emoji; final String title; final String desc; final String? badge;
  final bool selected; final VoidCallback onTap;
  const _SkillCard({required this.emoji, required this.title, required this.desc, this.badge, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap, borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryContainer.withValues(alpha: 0.10) : scheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: selected ? Border.all(color: AppColors.primary, width: 1.5) : null,
        ),
        child: Row(children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: selected ? AppColors.primary : null)),
              if (badge != null) ...[
                const SizedBox(width: 6),
                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: AppColors.tertiaryContainer, borderRadius: BorderRadius.circular(999)),
                    child: Text(badge!, style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700))),
              ],
            ]),
            Text(desc, style: Theme.of(context).textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
          ])),
          Container(width: 20, height: 20,
              decoration: BoxDecoration(shape: BoxShape.circle, color: selected ? AppColors.primary : scheme.surfaceContainerHighest),
              child: selected ? const Icon(Icons.check, size: 13, color: Colors.white) : null),
        ]),
      ),
    );
  }
}

class _MinuteChip extends StatelessWidget {
  final String label; final String xp; final String sub; final bool selected; final VoidCallback onTap;
  const _MinuteChip({required this.label, required this.xp, required this.sub, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: selected ? Colors.white : null)),
            Text(xp, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: selected ? Colors.white : Theme.of(context).colorScheme.onSurfaceVariant)),
          ]),
          Text(sub, style: TextStyle(fontSize: 11, color: selected ? Colors.white70 : Theme.of(context).colorScheme.onSurfaceVariant)),
        ]),
      ),
    );
  }
}
