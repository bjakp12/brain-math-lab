import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/logo_widget.dart';
import 'donation_config.dart';

/// Bottom sheet donasi: tab PayPal (nominal USD) + tab QRIS (gambar statis).
/// Aman dibuka kapan pun — bila konfigurasi belum diisi, tampilkan petunjuk.
Future<void> showDonationSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _DonationSheet(),
  );
}

class _DonationSheet extends StatefulWidget {
  const _DonationSheet();
  @override
  State<_DonationSheet> createState() => _DonationSheetState();
}

class _DonationSheetState extends State<_DonationSheet> {
  int _tab = 0; // 0 PayPal, 1 QRIS
  int _amount = 2;
  bool _busy = false;

  Future<void> _donatePaypal() async {
    if (!DonationConfig.isConfigured) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Donasi PayPal belum diaktifkan pengembang. Coba lagi nanti.')),
      );
      return;
    }
    setState(() => _busy = true);
    try {
      final uri = Uri.parse(DonationConfig.paypalUrl(amountUsd: _amount));
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!ok && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak bisa membuka PayPal.')),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(999))),
        const SizedBox(height: 16),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LogoWidget(size: 44),
            SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Dukung Brain & Math Lab',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              Text('Donasi menjaga aplikasi gratis & tanpa iklan',
                  style: TextStyle(fontSize: 12)),
            ]),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: scheme.surfaceContainer,
              borderRadius: BorderRadius.circular(999)),
          child: Row(children: [
            _TabBtn(
                label: 'PayPal',
                selected: _tab == 0,
                onTap: () => setState(() => _tab = 0)),
            _TabBtn(
                label: 'QRIS',
                selected: _tab == 1,
                onTap: () => setState(() => _tab = 1)),
          ]),
        ),
        const SizedBox(height: 16),
        if (_tab == 0) ...[
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Pilih nominal (USD)', style: t.titleSmall),
          ),
          const SizedBox(height: 8),
          Wrap(spacing: 8, children: [
            for (final a in DonationConfig.paypalAmountsUsd)
              ChoiceChip(
                label: Text('\$$a'),
                selected: _amount == a,
                onSelected: (_) => setState(() => _amount = a),
              ),
          ]),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _busy ? null : _donatePaypal,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              if (_busy)
                const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2))
              else
                const Icon(Icons.volunteer_activism, size: 18),
              const SizedBox(width: 8),
              Text('Donasi \$$_amount via PayPal'),
            ]),
          ),
          const SizedBox(height: 8),
          Text('Dibuka aman di aplikasi/browser PayPal.',
              style: t.bodySmall, textAlign: TextAlign.center),
        ] else ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: scheme.outlineVariant),
            ),
            child: Image.asset(
              DonationConfig.qrisAsset,
              width: 220,
              height: 220,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => SizedBox(
                width: 220,
                height: 220,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.qr_code_2,
                          size: 64, color: AppColors.outline),
                      const SizedBox(height: 12),
                      Text('QR QRIS belum dipasang',
                          style: t.titleSmall, textAlign: TextAlign.center),
                      const SizedBox(height: 4),
                      Text(
                          'Minta gambar QR statis ke bank/acquirer, simpan sebagai ${DonationConfig.qrisAsset}. Sementara itu donasi via PayPal.',
                          style: t.bodySmall,
                          textAlign: TextAlign.center),
                    ]),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            TextButton.icon(
              onPressed: () {
                Clipboard.setData(const ClipboardData(
                    text: DonationConfig.merchantName));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Nama merchant disalin.')),
                );
              },
              icon: const Icon(Icons.copy, size: 16),
              label: Text('Salin: ${DonationConfig.merchantName}'),
            ),
          ]),
        ],
      ]),
    );
  }
}

class _TabBtn extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _TabBtn(
      {required this.label, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? scheme.surfaceContainerLowest : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Center(
            child: Text(label,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: selected ? scheme.onSurface : scheme.onSurfaceVariant)),
          ),
        ),
      ),
    );
  }
}
