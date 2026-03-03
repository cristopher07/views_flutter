import 'package:flutter/material.dart';
import 'package:views_flutter/l10n/app_localizations.dart';
import '../../../features/dashboard/presentation/views/dashboard_view.dart';
import '../../../features/history/presentation/views/history_view.dart';
import '../../../features/settings/presentation/views/settings_view.dart';
import '../../../features/transfers/presentation/views/transfers_view.dart';


class HomeTabsView extends StatefulWidget {
  const HomeTabsView({super.key});

  @override
  State<HomeTabsView> createState() => _HomeTabsViewState();
}

class _HomeTabsViewState extends State<HomeTabsView> {
  int _indexTabSelected = 0;

  final List<Widget> _viewsTab = const [
    DashboardView(),
    TransfersView(),
    HistoryView(),
    SettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: IndexedStack(
        index: _indexTabSelected,
        children: _viewsTab,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indexTabSelected,
        onDestinationSelected: (selectedIndex) {
          setState(() {
            _indexTabSelected = selectedIndex;
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard),
            label: localizations.dashboard,
          ),
          NavigationDestination(
            icon: const Icon(Icons.swap_horiz_outlined),
            selectedIcon: const Icon(Icons.swap_horiz),
            label: localizations.transfers,
          ),
          NavigationDestination(
            icon: const Icon(Icons.history_outlined),
            selectedIcon: const Icon(Icons.history),
            label: localizations.history,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: localizations.settings,
          ),
        ],
      ),
    );
  }
}
