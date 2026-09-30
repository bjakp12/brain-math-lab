import 'package:go_router/go_router.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/modules/module_catalog_screen.dart';
import '../../features/math/category_list_screen.dart';
import '../../features/math/material_detail_screen.dart';
import '../../features/math/question_screen.dart';
import '../../features/math/explanation_screen.dart';
import '../../features/math/result_screen.dart';
import '../../features/games/speed_training_screen.dart';
import '../../features/games/memory_sequence_screen.dart';
import '../../features/games/memory_maze_screen.dart';
import '../../features/games/visual_training_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../shared/widgets/main_shell.dart';

/// Alur navigasi sesuai spek Bagian IV:
/// Onboarding -> Shell(Beranda, Modul, Profil) -> Math flow / Games -> Hasil.
final appRouter = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => MainShell(shell: shell),
      branches: [
        StatefulShellBranch(routes: [GoRoute(path: '/home', builder: (_, __) => const HomeScreen())]),
        StatefulShellBranch(routes: [GoRoute(path: '/modul', builder: (_, __) => const ModuleCatalogScreen())]),
        StatefulShellBranch(routes: [GoRoute(path: '/profil', builder: (_, __) => const ProfileScreen())]),
      ],
    ),
    GoRoute(path: '/math', builder: (_, __) => const CategoryListScreen()),
    GoRoute(path: '/math/detail', builder: (c, s) {
      final cat = s.uri.queryParameters['cat'] ?? 'pecahan';
      return MaterialDetailScreen(categoryId: cat);
    }),
    GoRoute(path: '/math/soal', builder: (c, s) {
      final cat = s.uri.queryParameters['cat'] ?? 'pecahan';
      final idx = int.tryParse(s.uri.queryParameters['idx'] ?? '0') ?? 0;
      return QuestionScreen(categoryId: cat, index: idx);
    }),
    GoRoute(path: '/math/bahas', builder: (c, s) {
      final cat = s.uri.queryParameters['cat'] ?? 'pecahan';
      final idx = int.tryParse(s.uri.queryParameters['idx'] ?? '0') ?? 0;
      final pick = s.uri.queryParameters['pick'] ?? 'B';
      return ExplanationScreen(categoryId: cat, index: idx, picked: pick);
    }),
    GoRoute(path: '/math/hasil', builder: (c, s) {
      final cat = s.uri.queryParameters['cat'] ?? 'pecahan';
      return ResultScreen(categoryId: cat);
    }),
    GoRoute(path: '/speed', builder: (_, __) => const SpeedTrainingScreen()),
    GoRoute(path: '/memory', builder: (_, __) => const MemorySequenceScreen()),
    GoRoute(path: '/maze', builder: (_, __) => const MemoryMazeScreen()),
    GoRoute(path: '/visual', builder: (_, __) => const VisualTrainingScreen()),
    GoRoute(path: '/pengaturan', builder: (_, __) => const SettingsScreen()),
  ],
);
