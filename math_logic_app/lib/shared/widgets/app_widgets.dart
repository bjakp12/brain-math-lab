import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

/// Komponen reusable sesuai spek Bagian V:
/// TopAppBar, TimerBadge, ProgressBar, OptionCard, MetricCard,
/// ModuleCard, BottomBar, Dialog, Snackbar.

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final Widget? timer;
  final List<Widget>? actions;
  const AppTopBar({super.key, required this.title, this.showBack = false, this.timer, this.actions});
  @override
  Size get preferredSize => const Size.fromHeight(64);
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AppBar(
      leading: showBack
          ? IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).maybePop())
          : Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Container(
                width: 36, height: 36,
                decoration: BoxDecoration(color: scheme.primaryContainer, borderRadius: BorderRadius.circular(12)),
                child: Icon(Icons.psychology, color: scheme.onPrimaryContainer, size: 20),
              ),
            ),
      title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      actions: [
        if (timer != null) ...[timer!, const SizedBox(width: 8)],
        ...?actions,
        Container(
          width: 32, height: 32,
          margin: const EdgeInsets.only(right: 16),
          decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
          child: const Icon(Icons.person, color: Colors.white, size: 18),
        ),
      ],
    );
  }
}

class TimerBadge extends StatelessWidget {
  final String text;
  const TimerBadge(this.text, {super.key});
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: scheme.surfaceContainerHigh, borderRadius: BorderRadius.circular(999)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.timer_outlined, size: 16, color: scheme.primary),
        const SizedBox(width: 4),
        Text(text, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, fontFeatures: const [FontFeature.tabularFigures()])),
      ]),
    );
  }
}

class AppProgressBar extends StatelessWidget {
  final double value;
  final Color? color;
  final double height;
  const AppProgressBar(this.value, {super.key, this.color, this.height = 8});
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: LinearProgressIndicator(
        value: value.clamp(0.0, 1.0), minHeight: height,
        backgroundColor: scheme.surfaceContainerHighest,
        valueColor: AlwaysStoppedAnimation(color ?? scheme.primary),
      ),
    );
  }
}

class MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final String sub;
  final IconData icon;
  final Color iconBg;
  final Color iconFg;
  const MetricCard({super.key, required this.label, required this.value, required this.sub, required this.icon, required this.iconBg, required this.iconFg});
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerLowest, borderRadius: BorderRadius.circular(16)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(label, style: t.labelMedium),
          Container(width: 28, height: 28, decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
              child: Icon(icon, size: 15, color: iconFg)),
        ]),
        const SizedBox(height: 8),
        Text(value, style: t.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
        Text(sub, style: t.labelSmall),
      ]),
    );
  }
}

class Pill extends StatelessWidget {
  final String text;
  final Color bg;
  final Color fg;
  final IconData? icon;
  const Pill(this.text, {super.key, required this.bg, required this.fg, this.icon});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (icon != null) ...[Icon(icon, size: 13, color: fg), const SizedBox(width: 4)],
        Text(text, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: fg)),
      ]),
    );
  }
}

void showExitDialog(BuildContext context, {required VoidCallback onExit}) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: const Text('Keluar dari Latihan?'),
      content: const Text('Progres saat ini tersimpan sebagai draft.'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
        FilledButton(onPressed: () { Navigator.pop(context); onExit(); }, child: const Text('Ya, Keluar')),
      ],
    ),
  );
}

void showOfflineSnack(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Anda sedang offline. Progres tetap disimpan lokal.')),
  );
}
