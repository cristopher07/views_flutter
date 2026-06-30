import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:views_flutter/l10n/app_localizations.dart';

import '../../../features/dashboard/presentation/views/dashboard_view.dart';
import '../../../features/login/presentation/providers/login_providers.dart';
import '../../../features/mobile_topup/presentation/views/mobile_topup_view.dart';
import '../../../features/settings/presentation/views/settings_view.dart';
import '../../../features/transfers/presentation/views/screens/account_list_screen.dart';

class HomeTabsView extends ConsumerStatefulWidget {
  const HomeTabsView({super.key});

  @override
  ConsumerState<HomeTabsView> createState() => _HomeTabsViewState();
}

class _HomeTabsViewState extends ConsumerState<HomeTabsView> {
  int _indexTabSelected = 0;

  final List<Widget> _viewsTab = const [
    DashboardView(),
    AccountListScreen(),
    MobileTopUpView(),
    SettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    const brandYellow = Color(0xFFFFCC00);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            }
          },
        ),
        title: const Text('Banca App'),
        actions: [
          IconButton(
            tooltip: 'Cerrar sesion',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(loginProvider.notifier).logout();
              if (context.mounted) {
                context.goNamed('login');
              }
            },
          ),
        ],
      ),
      body: IndexedStack(index: _indexTabSelected, children: _viewsTab),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indexTabSelected,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
        onTap: (index) {
          setState(() {
            _indexTabSelected = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: _SelectedNavIcon(
              color: brandYellow,
              child: const Icon(Icons.home),
            ),
            label: localizations.dashboard,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.swap_horiz),
            activeIcon: _SelectedNavIcon(
              color: brandYellow,
              child: const Icon(Icons.swap_horiz),
            ),
            label: localizations.transfers,
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.payment_outlined),
            activeIcon: _SelectedNavIcon(
              color: brandYellow,
              child: Icon(Icons.payment),
            ),
            label: 'Pagos',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings_outlined),
            activeIcon: _SelectedNavIcon(
              color: brandYellow,
              child: const Icon(Icons.settings),
            ),
            label: localizations.settings,
          ),
        ],
      ),
    );
  }
}

class _SelectedNavIcon extends StatelessWidget {
  const _SelectedNavIcon({required this.color, required this.child});

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        child: IconTheme(
          data: const IconThemeData(color: Colors.black),
          child: child,
        ),
      ),
    );
  }
}
