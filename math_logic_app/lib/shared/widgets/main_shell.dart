import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Bottom NavigationBar Material 3 untuk 3 tab utama.
class MainShell extends StatelessWidget {
  final StatefulNavigationShell shell;
  const MainShell({super.key, required this.shell});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: (i) => shell.goBranch(i, initialLocation: i == shell.currentIndex),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Beranda'),
          NavigationDestination(icon: Icon(Icons.grid_view_outlined), selectedIcon: Icon(Icons.grid_view), label: 'Modul'),
          NavigationDestination(icon: Icon(Icons.insights_outlined), selectedIcon: Icon(Icons.insights), label: 'Profil'),
        ],
      ),
    );
  }
}
