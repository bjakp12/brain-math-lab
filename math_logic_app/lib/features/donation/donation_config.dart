// Satu-satunya file yang perlu diisi untuk mengaktifkan donasi.
// 1) PayPal: ganti paypalEmail dengan email bisnis PayPal Anda, lalu buat
//    tautan donate di paypal.com/donate (otomatis cocok dengan builder di bawah).
// 2) QRIS: minta gambar QR statis ke acquirer/bank Anda, simpan sebagai
//    assets/brand/qris.png (sudah masuk cakupan assets/brand/ di pubspec).
class DonationConfig {
  /// GANTI dengan email PayPal bisnis Anda.
  static const paypalEmail = 'auradrexx@gmail.com';

  static const merchantName = 'Brain & Math Lab';

  /// File QR QRIS statis. Bila belum dipasang, tab QRIS menampilkan
  /// petunjuk + tombol PayPal sebagai jalan keluar (tidak crash).
  static const qrisAsset = 'assets/brand/qris.png';

  /// Pilihan nominal (USD — mata uang donasi PayPal lintas negara).
  static const paypalAmountsUsd = [1, 2, 5, 10];

  static bool get isConfigured => !paypalEmail.startsWith('auradrexx@');

  /// Tautan donate PayPal resmi. Murni fungsi — teruji di unit test.
  static String paypalUrl({required int amountUsd}) {
    final q = {
      'business': paypalEmail,
      'item_name': 'Donasi $merchantName',
      'amount': amountUsd.toString(),
      'currency_code': 'USD',
      'no_note': '0',
    };
    return Uri.https('www.paypal.com', '/donate', q).toString();
  }
}
