import 'dart:async';

import 'package:flutter/material.dart';

import '../core/core.dart';
import '../state/app_scope.dart';
import 'calendar_page.dart';
import 'home_page.dart';
import 'settings_page.dart';
import 'stats_page.dart';

/// Нэвтэрсний дараах үндсэн бүрхүүл: доод навигаци + 4 таб.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> with WidgetsBindingObserver {
  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Апп нээлттэй байх үед сануулгын цаг тулсан эсэхийг минут тутамд шалгана.
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) AppScope.read(context).refreshNotifications();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      AppScope.read(context).refreshNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;

    return Scaffold(
      backgroundColor: context.pal.page,
      body: IndexedStack(
        index: _index,
        children: [
          HomePage(onSeeAll: () => setState(() => _index = 1)),
          const CalendarPage(),
          const StatsPage(),
          const SettingsPage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home_rounded),
            label: s('nav.home'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.calendar_month_outlined),
            selectedIcon: const Icon(Icons.calendar_month_rounded),
            label: s('nav.calendar'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.bar_chart_outlined),
            selectedIcon: const Icon(Icons.bar_chart_rounded),
            label: s('nav.stats'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings_rounded),
            label: s('nav.settings'),
          ),
        ],
      ),
    );
  }
}
