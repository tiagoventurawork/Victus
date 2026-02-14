import 'package:flutter/material.dart';
import '../../widgets/bottom_nav_bar.dart';
import 'dashboard_screen.dart';
import 'library_screen.dart';
import 'profile_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const _PlanoPlaceholder(),
    const LibraryScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}

class _PlanoPlaceholder extends StatelessWidget {
  const _PlanoPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Plano - Em desenvolvimento'),
      ),
    );
  }
}