import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/auth/auth_providers.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/data/app_state.dart';
import 'shared/widgets/logo_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: Bootstrap()));
}

/// Memuat profil + pengaturan lokal lebih dulu (backend "dari awal"),
/// lalu mencoba Firebase bila file konfigurasinya terpasang.
/// Tanpa Firebase pun aplikasi langsung jalan sebagai tamu.
class Bootstrap extends ConsumerStatefulWidget {
  const Bootstrap({super.key});
  @override
  ConsumerState<Bootstrap> createState() => _BootstrapState();
}

class _BootstrapState extends ConsumerState<Bootstrap> {
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _boot();
  }

  Future<void> _boot() async {
    await ref.read(profileProvider.notifier).load();
    await ref.read(settingsProvider.notifier).load();
    try {
      await Firebase.initializeApp();
      ref.read(firebaseReadyProvider.notifier).state = true;
    } catch (_) {
      // File google-services / plist belum dipasang → tetap mode tamu.
      // Lihat FIREBASE_SETUP.md untuk mengaktifkan login Google.
    }
    if (mounted) setState(() => _ready = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Color(0xFF3525CD),
          body: Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              LogoWidget(size: 84),
              SizedBox(height: 20),
              SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                    strokeWidth: 3, color: Colors.white),
              ),
            ]),
          ),
        ),
      );
    }
    return const BrainMathApp();
  }
}

class BrainMathApp extends ConsumerWidget {
  const BrainMathApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    return MaterialApp.router(
      title: 'Brain & Math Lab',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: settings.themeMode,
      routerConfig: appRouter,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: TextScaler.linear(settings.fontScale)),
        child: child!,
      ),
    );
  }
}
