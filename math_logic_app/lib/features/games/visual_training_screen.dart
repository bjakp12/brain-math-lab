import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/app_widgets.dart';

/// Layar 12 — Visual Training rotasi objek 3D (isometrik via CustomPaint).
class VisualTrainingScreen extends StatefulWidget {
  const VisualTrainingScreen({super.key});
  @override
  State<VisualTrainingScreen> createState() => _VisualState();
}

class _VisualState extends State<VisualTrainingScreen> {
  String? picked = 'B';
  double rotation = 0; // 0/90/180/270 visual
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => context.pop()),
        title: const Text('Visual Training: Rotasi Objek', style: TextStyle(fontSize: 15)),
        actions: const [
          TimerBadge('00:45'), SizedBox(width: 6),
          Pill('Lvl 3', bg: AppColors.tertiaryContainer, fg: Colors.white, icon: Icons.military_tech),
          SizedBox(width: 40),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: scheme.surfaceContainerLow, borderRadius: BorderRadius.circular(24)),
            child: const Column(children: [
              Row(children: [
                Pill('Soal 2 dari 5', bg: AppColors.secondaryContainer, fg: Colors.white),
                SizedBox(width: 6),
                Pill('+40 XP Focus', bg: AppColors.tertiaryContainer, fg: Colors.white, icon: Icons.bolt),
                Spacer(),
                Pill('00:30 dtk', bg: AppColors.surfaceHigh, fg: AppColors.primary, icon: Icons.timer_outlined),
              ]),
              const SizedBox(height: 8),
              const Row(children: [
                Expanded(child: AppProgressBar(0.4)), SizedBox(width: 4),
                Expanded(child: AppProgressBar(0.4)), SizedBox(width: 4),
                Expanded(child: AppProgressBar(0.0)), SizedBox(width: 4),
                Expanded(child: AppProgressBar(0.0)), SizedBox(width: 4),
                Expanded(child: AppProgressBar(0.0)),
              ]),
              const SizedBox(height: 6),
              const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(children: [
                  Icon(Icons.view_in_ar, size: 14, color: AppColors.primary),
                  SizedBox(width: 4), Text('Persepsi Ruang & Rotasi Mental', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                ]),
                Row(children: [
                  Icon(Icons.stars, size: 13, color: AppColors.primary),
                  SizedBox(width: 2), Text('320 PTS', style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w700)),
                ]),
              ]),
            ]),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: scheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(18)),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(width: 36, height: 36, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.sync, color: Colors.white, size: 20)),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Instruksi Tantangan Rotasi', style: t.titleSmall),
                const Text('Objek manakah yang identik secara struktural dengan Objek Utama setelah diputar 90° searah jarum jam (sumbu Z)?',
                    style: TextStyle(fontSize: 12)),
              ])),
            ]),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: scheme.surfaceContainer, borderRadius: BorderRadius.circular(24)),
            child: Column(children: [
              const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Pill('Objek Referensi Utama', bg: Colors.white, fg: AppColors.primary, icon: Icons.token_outlined),
                Pill('● Orientasi: 0°', bg: AppColors.surfaceHigh, fg: AppColors.onSurface),
              ]),
              const SizedBox(height: 8),
              SizedBox(height: 180, child: CustomPaint(painter: _IsoPainter(rotation: rotation, highlight: true))),
              const SizedBox(height: 8),
              Row(children: [
                Expanded(child: FilledButton.tonal(
                    style: FilledButton.styleFrom(minimumSize: const Size(0, 40)),
                    onPressed: () => setState(() => rotation = (rotation - 90) % 360),
                    child: const Text('↺ Putar Kiri 90°', style: TextStyle(fontSize: 12)))),
                const SizedBox(width: 8),
                Expanded(child: FilledButton.tonal(
                    style: FilledButton.styleFrom(minimumSize: const Size(0, 40)),
                    onPressed: () => setState(() => rotation = (rotation + 90) % 360),
                    child: const Text('Putar Kanan 90° ↻', style: TextStyle(fontSize: 12)))),
                const SizedBox(width: 8),
                FilledButton.tonal(
                    style: FilledButton.styleFrom(minimumSize: const Size(44, 40), padding: EdgeInsets.zero),
                    onPressed: () {}, child: const Icon(Icons.visibility_outlined, size: 18)),
              ]),
            ]),
          ),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Pilih Bentuk yang Cocok', style: t.titleSmall),
            Text('Pilih satu jawaban', style: t.labelSmall),
          ]),
          const SizedBox(height: 8),
          GridView.count(
            crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 0.82,
            children: [
              _IsoOption(id: 'A', tag: '180°', label: 'Rotasi 180°', rot: 180, selected: picked == 'A', onTap: () => setState(() => picked = 'A')),
              _IsoOption(id: 'B', tag: null, label: 'Opsi B (Rotasi 90°)', rot: 90, selected: picked == 'B', chosen: true, onTap: () => setState(() => picked = 'B')),
              _IsoOption(id: 'C', tag: '270°', label: 'Opsi C (Rotasi 270°)', rot: 270, selected: picked == 'C', onTap: () => setState(() => picked = 'C')),
              _IsoOption(id: 'D', tag: 'Asimetris', label: 'Opsi D (Struktur Beda)', rot: 0, broken: true, selected: picked == 'D', onTap: () => setState(() => picked = 'D')),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: scheme.surfaceContainerLow, borderRadius: BorderRadius.circular(16)),
            child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(Icons.lightbulb, size: 18, color: AppColors.tertiary),
              SizedBox(width: 8),
              Expanded(child: Text('Tip Kognitif: Perhatikan posisi tonjolan kubus oranye di bagian ujung sebagai patokan sudut saat diputar.',
                  style: TextStyle(fontSize: 12))),
            ]),
          ),
        ]),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
        decoration: BoxDecoration(color: scheme.surface.withValues(alpha: 0.95)),
        child: SafeArea(
          top: false,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            FilledButton(
              onPressed: picked == null ? null : () => context.push('/math/hasil?cat=geometri'),
              child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('Konfirmasi Jawaban (+25 XP)'), SizedBox(width: 6), Icon(Icons.check, size: 18),
              ]),
            ),
            const SizedBox(height: 6),
            const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.circle, size: 7, color: AppColors.tertiary),
              SizedBox(width: 4), Text('Mode Offline Aktif', style: TextStyle(fontSize: 10)),
              SizedBox(width: 8), Text('•'), SizedBox(width: 8),
              Icon(Icons.vibration, size: 12), SizedBox(width: 4), Text('Haptic On', style: TextStyle(fontSize: 10)),
              SizedBox(width: 8), Text('•'), SizedBox(width: 8),
              Text('Sinkronisasi Otomatis', style: TextStyle(fontSize: 10)),
            ]),
          ]),
        ),
      ),
    );
  }
}

class _IsoOption extends StatelessWidget {
  final String id; final String? tag; final String label; final double rot;
  final bool selected; final bool chosen; final bool broken; final VoidCallback onTap;
  const _IsoOption({required this.id, this.tag, required this.label, required this.rot, this.selected = false, this.chosen = false, this.broken = false, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap, borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: selected ? scheme.surfaceContainerLow : scheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(22),
          border: selected ? Border.all(color: AppColors.primary, width: 1.5) : null,
        ),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(width: 24, height: 24, decoration: BoxDecoration(
                color: selected ? AppColors.primary : scheme.surfaceContainer, shape: BoxShape.circle),
                child: Center(child: Text(id, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800,
                    color: selected ? Colors.white : null)))),
            if (chosen && selected)
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.tertiaryContainer, borderRadius: BorderRadius.circular(999)),
                  child: const Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.check_circle, size: 11, color: Colors.white),
                    SizedBox(width: 2), Text('Terpilih', style: TextStyle(fontSize: 10, color: Colors.white)),
                  ]))
            else if (tag != null)
              Text(tag!, style: const TextStyle(fontSize: 10, color: AppColors.outline)),
          ]),
          Expanded(child: CustomPaint(painter: _IsoPainter(rotation: rot, highlight: selected, broken: broken))),
          Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
              color: selected ? AppColors.primary : null), textAlign: TextAlign.center, maxLines: 2),
        ]),
      ),
    );
  }
}

/// Painter kubus isometrik sederhana: basis T + kubus oranye penanda.
class _IsoPainter extends CustomPainter {
  final double rotation; final bool highlight; final bool broken;
  _IsoPainter({required this.rotation, this.highlight = false, this.broken = false});
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2, cy = size.height / 2;
    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(rotation * 3.14159265 / 180);
    canvas.translate(-cx, -cy);
    void cube(double x, double y, double s, Color top, Color left, Color right) {
      final pTop = Path()..moveTo(x, y - s * 0.5)..lineTo(x + s, y)..lineTo(x, y + s * 0.5)..lineTo(x - s, y)..close();
      final pLeft = Path()..moveTo(x - s, y)..lineTo(x, y + s * 0.5)..lineTo(x, y + s * 1.5)..lineTo(x - s, y + s)..close();
      final pRight = Path()..moveTo(x + s, y)..lineTo(x, y + s * 0.5)..lineTo(x, y + s * 1.5)..lineTo(x + s, y + s)..close();
      canvas.drawPath(pLeft, Paint()..color = left);
      canvas.drawPath(pRight, Paint()..color = right);
      canvas.drawPath(pTop, Paint()..color = top);
    }

    const top = Color(0xFFC3C0FF), left = Color(0xFF4F46E5), right = Color(0xFF3323CC);
    const oTop = Color(0xFFFFA726), oLeft = Color(0xFFF57C00), oRight = Color(0xFFE65100);
    const s = 22.0;
    if (broken) {
      cube(cx - s, cy, s, top, left, right);
      cube(cx + s, cy - s * 0.5, s, top, left, right);
      cube(cx + s * 2, cy + s * 0.6, s, oTop, oLeft, oRight);
    } else {
      cube(cx, cy + s, s, top, left, right);
      cube(cx - s, cy, s, top, left, right);
      cube(cx + s, cy, s, top, left, right);
      cube(cx, cy - s, s, top, left, right);
      cube(cx, cy - s * 2, s * 0.7, oTop, oLeft, oRight);
    }
    canvas.restore();
  }
  @override
  bool shouldRepaint(covariant _IsoPainter old) => old.rotation != rotation || old.highlight != highlight || old.broken != broken;
}
