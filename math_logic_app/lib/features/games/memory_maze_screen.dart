import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/app_widgets.dart';

/// Layar 11 — Memory Maze 4x4 dengan jebakan bom + D-Pad.
/// Fase 1: hafalkan jalur (5 dtk) -> Fase 2: jalur disembunyikan.
class MemoryMazeScreen extends StatefulWidget {
  const MemoryMazeScreen({super.key});
  @override
  State<MemoryMazeScreen> createState() => _MazeState();
}

class _MazeState extends State<MemoryMazeScreen> {
  static const n = 4;
  late List<Point<int>> safePath;
  late Set<Point<int>> bombs;
  Point<int> player = const Point(0, 0);
  Set<Point<int>> trail = {};
  int lives = 3, score = 1200, secs = 24;
  bool memorize = true;
  int peekLeft = 1;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _gen();
    Future.delayed(const Duration(seconds: 5), () { if (mounted) setState(() => memorize = false); });
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secs > 0) setState(() => secs--);
    });
  }

  void _gen() {
    final rnd = Random(11);
    safePath = [const Point(0, 0), const Point(1, 0), const Point(1, 1), const Point(2, 1), const Point(2, 2), const Point(3, 2), const Point(3, 3)];
    bombs = {};
    while (bombs.length < 3) {
      final p = Point(rnd.nextInt(n), rnd.nextInt(n));
      if (!safePath.contains(p) && p != const Point(0, 0) && p != const Point(3, 3)) bombs.add(p);
    }
    trail = {const Point(0, 0), const Point(1, 0)};
  }

  @override
  void dispose() { timer?.cancel(); super.dispose(); }

  void _move(int dx, int dy) {
    final np = Point(player.x + dx, player.y + dy);
    if (np.x < 0 || np.y < 0 || np.x >= n || np.y >= n) return;
    setState(() {
      player = np;
      if (bombs.contains(np)) {
        lives--;
        score = max(0, score - 100);
        player = const Point(0, 0);
        trail = {const Point(0, 0)};
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('💥 Kena jebakan! -1 nyawa'), backgroundColor: AppColors.error));
        if (lives <= 0) {
          timer?.cancel();
          showDialog(context: context, builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: const Text('Game Over'), content: Text('Skor: $score PTS'),
            actions: [FilledButton(onPressed: () => context.go('/math/hasil?cat=aritmatika'), child: const Text('Lihat Hasil'))],
          ));
        }
      } else {
        trail.add(np);
        score += 10;
        if (np == const Point(3, 3)) {
          timer?.cancel();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('🏁 Finish! +30 XP No-Trap'), backgroundColor: AppColors.tertiaryContainer));
          context.push('/math/hasil?cat=aritmatika');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    String coord(Point<int> p) => '${'ABCD'[p.x]}${p.y + 1}';
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => context.pop()),
        title: const Text('Memory Maze'),
        actions: const [
          Chip(label: Text('Lv. 11'), avatar: Icon(Icons.military_tech, size: 14)),
          SizedBox(width: 40),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: scheme.surfaceContainerLow, borderRadius: BorderRadius.circular(24)),
            child: Column(children: [
              const Row(children: [
                Pill('Level 3 • Medium', bg: AppColors.primaryFixed, fg: AppColors.onPrimaryFixed, icon: Icons.psychology),
                Spacer(),
                Pill('+30 XP No-Trap', bg: AppColors.tertiaryContainer, fg: Colors.white, icon: Icons.bolt),
              ]),
              const SizedBox(height: 10),
              Row(children: [
                _Hud(icon: Icons.stars, label: 'Skor', value: '$score PTS'),
                const SizedBox(width: 8),
                _Hud(icon: Icons.favorite, label: 'Nyawa', value: '$lives/3 ${lives == 3 ? 'Full' : ''}', red: true),
                const SizedBox(width: 8),
                _Hud(icon: Icons.timer_outlined, label: 'Waktu', value: '00:${secs.toString().padLeft(2, '0')}'),
              ]),
            ]),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.primaryContainer, AppColors.secondaryContainer]),
                borderRadius: BorderRadius.circular(24)),
            child: Row(children: [
              Container(width: 40, height: 40, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                  child: Icon(memorize ? Icons.visibility : Icons.visibility_off, color: Colors.white)),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(999)),
                    child: Text(memorize ? 'FASE MENGHAFAL' : 'FASE MENELUSURI',
                        style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700))),
                const SizedBox(height: 2),
                Text(memorize ? 'Hafalkan Jalur Hijau & Bom!' : 'Jalur Rahasia Telah Disembunyikan',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                const Text('Ingat titik jebakan dan melangkah aman menuju finish.',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
              ])),
            ]),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: scheme.surfaceContainerLow, borderRadius: BorderRadius.circular(24)),
            child: Column(children: [
              const Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Text('A', style: TextStyle(fontWeight: FontWeight.w800)),
                Text('B', style: TextStyle(fontWeight: FontWeight.w800)),
                Text('C', style: TextStyle(fontWeight: FontWeight.w800)),
                Text('D', style: TextStyle(fontWeight: FontWeight.w800)),
              ]),
              const SizedBox(height: 6),
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                  for (var r = 1; r <= 4; r++)
                    SizedBox(height: 68, child: Center(child: Text('$r', style: const TextStyle(fontWeight: FontWeight.w800)))),
                ]),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: scheme.surfaceContainerHigh, borderRadius: BorderRadius.circular(18)),
                    child: GridView.count(
                      crossAxisCount: 4, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 8, crossAxisSpacing: 8,
                      children: [
                        for (var y = 0; y < n; y++)
                          for (var x = 0; x < n; x++)
                            _tile(context, Point(x, y), coord),
                      ],
                    ),
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: scheme.surfaceContainer, borderRadius: BorderRadius.circular(14)),
                child: const Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                  _Legend2(icon: Icons.person, label: 'Posisi'),
                  _Legend2(icon: Icons.check, label: 'Jejak'),
                  _Legend2(icon: Icons.flag, label: 'Finish'),
                  _Legend2(icon: Icons.warning_amber_rounded, label: 'Jebakan'),
                ]),
              ),
            ]),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: scheme.surfaceContainerLow, borderRadius: BorderRadius.circular(24)),
            child: Column(children: [
              Row(children: [
                FilledButton.tonal(
                    style: FilledButton.styleFrom(minimumSize: const Size(0, 36)),
                    onPressed: peekLeft > 0 ? () { setState(() { peekLeft--; memorize = true; }); Future.delayed(const Duration(seconds: 2), () { if (mounted) setState(() => memorize = false); }); } : null,
                    child: Text('Intip (${peekLeft}x)')),
                const Spacer(),
                Text('Gunakan D-Pad', style: t.labelSmall),
                const Spacer(),
                FilledButton.tonal(
                    style: FilledButton.styleFrom(minimumSize: const Size(0, 36)),
                    onPressed: () => setState(() { player = const Point(0, 0); trail = {const Point(0, 0)}; }),
                    child: const Text('Reset')),
              ]),
              const SizedBox(height: 8),
              SizedBox(
                width: 200, height: 200,
                child: Stack(alignment: Alignment.center, children: [
                  Container(width: 64, height: 64, decoration: BoxDecoration(color: scheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(16))),
                  Positioned(top: 0, child: _PadBtn(icon: Icons.arrow_drop_up, onTap: () => _move(0, -1))),
                  Positioned(bottom: 0, child: _PadBtn(icon: Icons.arrow_drop_down, onTap: () => _move(0, 1))),
                  Positioned(left: 0, child: _PadBtn(icon: Icons.arrow_left, onTap: () => _move(-1, 0))),
                  Positioned(right: 0, child: _PadBtn(icon: Icons.arrow_right, onTap: () => _move(1, 0))),
                ]),
              ),
            ]),
          ),
          const SizedBox(height: 8),
          const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.circle, size: 8, color: AppColors.tertiary),
            SizedBox(width: 4), Text('Mode Offline Aktif', style: TextStyle(fontSize: 11)),
            SizedBox(width: 8), Icon(Icons.vibration, size: 13), SizedBox(width: 4),
            Text('Haptic On', style: TextStyle(fontSize: 11)),
          ]),
        ]),
      ),
    );
  }

  Widget _tile(BuildContext context, Point<int> p, String Function(Point<int>) coord) {
    final scheme = Theme.of(context).colorScheme;
    final isPlayer = p == player;
    final isStart = p == const Point(0, 0);
    final isFinish = p == const Point(3, 3);
    final onPath = safePath.contains(p);
    final isBomb = bombs.contains(p);
    final stepped = trail.contains(p);
    Color bg = scheme.surfaceContainer;
    Widget? child = Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.outlineVariant, shape: BoxShape.circle));
    if (memorize && onPath && !isStart) { bg = AppColors.tertiaryFixed.withValues(alpha: 0.4); child = const Icon(Icons.check_circle, color: AppColors.tertiary, size: 20); }
    if (memorize && isBomb) { bg = AppColors.errorContainer; child = const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 20); }
    if (isStart) { bg = scheme.surfaceContainerLowest; child = const Icon(Icons.tour_outlined, size: 18); }
    if (isFinish) { bg = AppColors.secondaryFixed; child = const Icon(Icons.flag, color: AppColors.primary, size: 20); }
    if (!memorize && stepped && !isPlayer && !isStart) { bg = AppColors.tertiaryFixed.withValues(alpha: 0.35); child = const Icon(Icons.check_circle, color: AppColors.tertiary, size: 18); }
    if (isPlayer) {
      bg = AppColors.primaryContainer;
      child = Container(width: 34, height: 34, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: const Icon(Icons.navigation, color: AppColors.primary, size: 18));
    }
    return Container(
      height: 64,
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14)),
      child: Stack(children: [
        Center(child: child),
        Positioned(right: 4, bottom: 2, child: Text(coord(p), style: const TextStyle(fontSize: 8, color: AppColors.outline))),
      ]),
    );
  }
}

class _Hud extends StatelessWidget {
  final IconData icon; final String label; final String value; final bool red;
  const _Hud({required this.icon, required this.label, required this.value, this.red = false});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainer, borderRadius: BorderRadius.circular(14)),
        child: Row(children: [
          Container(width: 30, height: 30, decoration: BoxDecoration(
              color: red ? AppColors.errorContainer : Theme.of(context).colorScheme.surfaceContainerHighest, shape: BoxShape.circle),
              child: Icon(icon, size: 15, color: red ? AppColors.error : AppColors.primary)),
          const SizedBox(width: 6),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: const TextStyle(fontSize: 10)),
            Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800), maxLines: 1),
          ])),
        ]),
      ),
    );
  }
}

class _Legend2 extends StatelessWidget {
  final IconData icon; final String label;
  const _Legend2({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Icon(icon, size: 15, color: AppColors.primary),
      Text(label, style: const TextStyle(fontSize: 10)),
    ]);
  }
}

class _PadBtn extends StatelessWidget {
  final IconData icon; final VoidCallback onTap;
  const _PadBtn({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, borderRadius: BorderRadius.circular(16),
      child: Container(width: 60, height: 60,
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHigh, borderRadius: BorderRadius.circular(16)),
          child: Icon(icon, size: 30)),
    );
  }
}
