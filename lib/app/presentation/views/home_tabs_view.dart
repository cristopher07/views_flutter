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

    return DefaultTabController(
      length: 4,
      child: Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        bottom: TabBar(
          onTap: (index) {
            setState(() {
              _indexTabSelected = index;
            });
          },
          tabs: [
            Tab(
              icon: Icon(
                _indexTabSelected == 0 
                  ? Icons.home 
                  : Icons.home_outlined,
              ),
              text: localizations.dashboard,
            ),
            Tab(
              icon: Icon(
                _indexTabSelected == 1 
                  ? Icons.send 
                  : Icons.send_outlined,
              ),
              text: localizations.transfers,
            ),
            Tab(
              icon: Icon(
                _indexTabSelected == 2 
                  ? Icons.history 
                  : Icons.history_outlined,
              ),
              text: localizations.history,
            ),
            Tab(
              icon: Icon(
                _indexTabSelected == 3 
                  ? Icons.settings 
                  : Icons.settings_outlined,
              ),
              text: localizations.settings,
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _indexTabSelected,
        children: _viewsTab,
      ),
      ),
    );
  }
}
